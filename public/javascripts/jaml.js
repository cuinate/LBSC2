/* Templating. */
/**
 * @class Jaml
 * @author Ed Spencer (http://edspencer.net)
 * Jaml is a simple JavaScript library which makes HTML generation easy and pleasurable.
 * Examples: http://edspencer.github.com/jaml
 * Introduction: http://edspencer.net/2009/11/jaml-beautiful-html-generation-for-javascript.html
 */
Jaml = function() {
  return {
    automaticScope: true,
    templates: {},
    helpers  : {},

    /**
     * Registers a template by name
     * @param {String} name The name of the template
     * @param {Function} template The template function
     */
    register: function(name, template) {
      this.templates[name] = template;
    },

    /**
     * Renders the given template name with an optional data object
     * @param {String} name The name of the template to render
     * @param {Object} data Optional data object
     */
    render: function(name, data) {
      if (!(name in this.templates)) {
        throw "Jaml error: Template '" + name + "' does not exist.";
      }

      var template = this.templates[name],
          renderer = new Jaml.Template(template);

      try {
        return renderer.render(data);
      } catch(e) {
        if (window.console && console.log) {
          console.log(e);
        } else if (window.blackberry) {
          alert("Jaml error: " + e);
        }
        throw e;
      }
    },

    /**
     * Registers a helper function
     * @param {String} name The name of the helper
     * @param {Function} helperFn The helper function
     */
    registerHelper: function(name, helperFn) {
      this.helpers[name] = helperFn;
      Jaml.Template.prototype[name] = helperFn;
    },

    registerHelpers: function(obj) {
      for (var name in obj) {
        Jaml.registerHelper(name, obj[name]);
      }
    }
  };
}();

/**
 * @constructor
 * @param {String} tagName The tag name this node represents (e.g. 'p', 'div', etc)
 */
Jaml.Node = function(tagName) {
  /**
   * @property tagName
   * @type String
   * This node's current tag
   */
  this.tagName = tagName;

  /**
   * @property attributes
   * @type Object
   * Sets of attributes on this node (e.g. 'cls', 'id', etc)
   */
  this.attributes = {};

  /**
   * @property children
   * @type Array
   * Array of rendered child nodes that will be included as this node's innerHTML
   */
  this.children = [];
};

Jaml.Node.prototype = {
  /**
   * Adds attributes to this node
   * @param {Object} attrs Object containing key: value pairs of node attributes
   */
  setAttributes: function(attrs) {
    for (var key in attrs) {
      var mappedKey = key == 'cls' ? 'class' : key;

      this.attributes[mappedKey] = attrs[key];
    }
  },

  /**
   * Adds a child string to this node. This can be called as often as needed to add children to a node
   * @param {String} childText The text of the child node
   */
  addChild: function(childText) {
    this.children.push(childText);
  },

  /**
   * Renders this node with its attributes and children
   * @param {Number} lpad Amount of whitespace to add to the left of the string (defaults to 0)
   * @return {String} The rendered node
   */
  render: function(lpad) {
    lpad = lpad || 0;

    function _interpret(item) {
      switch (typeof item) {
      case 'number':
        return item + '';
      case 'string':
        return item;
      default:
        if (!('render') in item) {
          throw "Can't render " + item;
        }
        return item.render(lpad + 2);
      }
    }

    var node      = [],
        textnode  = (this instanceof Jaml.TextNode),
        multiline = this.multiLineTag();

    if (!textnode) node.push(this.getPadding(lpad));

    node.push("<" + this.tagName);

    for (var key in this.attributes) {
      node.push(" " + key + "=\"" + this.attributes[key] + "\"");
    }

    if (this.isSelfClosing()) {
      node.push(" />\n");
    } else {
      node.push(">");

      if (multiline) node.push("\n");

      for (var i=0; i < this.children.length; i++) {
        node.push(_interpret(this.children[i]));
      }

      if (multiline) node.push(this.getPadding(lpad));
      node.push("</", this.tagName, ">");
    }

    return node.join("");
  },

  /**
   * Returns true if this tag should be rendered with multiple newlines (e.g. if it contains child nodes)
   * @return {Boolean} True to render this tag as multi-line
   */
  multiLineTag: function() {
    var childLength = this.children.length,
        multiLine   = childLength > 0;

    if (childLength == 1 && this.children[0] instanceof Jaml.TextNode) multiLine = false;
    return multiLine;
  },

  /**
   * Returns a string with the given number of whitespace characters, suitable for padding
   * @param {Number} amount The number of whitespace characters to add
   * @return {String} A padding string
   */
  getPadding: function(amount) {
    return new Array(amount + 1).join(" ");
  },

  /**
   * Returns true if this tag should close itself (e.g. no </tag> element)
   * @return {Boolean} True if this tag should close itself
   */
  isSelfClosing: function() {
    var selfClosing = false;

    for (var i = this.selfClosingTags.length - 1; i >= 0; i--){
      if (this.tagName == this.selfClosingTags[i]) selfClosing = true;
    }

    return selfClosing;
  },

  /**
   * @property selfClosingTags
   * @type Array
   * An array of all tags that should be self closing
   */
  selfClosingTags: ['img', 'meta', 'br', 'hr']
};

Jaml.TextNode = function(text) {
  this.text = text;
};

Jaml.TextNode.prototype = {
  render: function() {
    return this.text;
  }
};


/**
 * Represents a single registered template. Templates consist of an arbitrary number
 * of trees (e.g. there may be more than a single root node), and are not compiled.
 * When a template is rendered its node structure is computed with any provided template
 * data, culminating in one or more root nodes.  The root node(s) are then joined together
 * and returned as a single output string.
 *
 * The render process uses two dirty but necessary hacks.  First, the template function is
 * decompiled into a string (but is not modified), so that it can be eval'ed within the scope
 * of Jaml.Template.prototype. This allows the second hack, which is the use of the 'with' keyword.
 * This allows us to keep the pretty DSL-like syntax, though is not as efficient as it could be.
 */
Jaml.Template = function(tpl) {
  /**
   * @property tpl
   * @type Function
   * The function this template was created from
   */
  this.tpl = tpl;

  this.nodes = [];
};

Jaml.Template.prototype = {
  /**
   * Renders this template given the supplied data
   * @param {Object} data Optional data object
   * @return {String} The rendered HTML string
   */
  render: function(data) {
    data = data || {};

    if (data.constructor.toString().indexOf("Array") == -1) {
      data = [data];
    }

    if (Jaml.automaticScope) {
      with(this) {
        for (var i = 0; i < data.length; i++) {
          eval("(" + this.tpl.toString() + ")(data[i], i)");
        };
      }
    } else {
      for (i = 0; i < data.length; i++) {
        this.tpl.call(this, data[i], i);
      }
    }

    var roots  = this.getRoots(),
        output = "";

    for (i = 0; i < roots.length; i++) {
      output += roots[i].render();
    };

    return output;
  },

  /**
   * Returns all top-level (root) nodes in this template tree.
   * Templates are tree structures, but there is no guarantee that there is a
   * single root node (e.g. a single DOM element that all other elements nest within)
   * @return {Array} The array of root nodes
   */
  getRoots: function() {
    var roots = [];

    for (var i=0; i < this.nodes.length; i++) {
      var node = this.nodes[i];

      if (node.parent == undefined) roots.push(node);
    };

    return roots;
  },

  tags: [
    "html", "head", "body", "script", "meta", "title", "link", "script",
    "div", "p", "span", "a", "img", "br", "hr",
    "table", "tr", "th", "td", "thead", "tbody",
    "ul", "ol", "li",
    "dl", "dt", "dd",
    "h1", "h2", "h3", "h4", "h5", "h6", "h7",
    "form", "input", "textarea", "button", "label", "fieldset", "legend",
    "select", "option",
    "b", "i", "u", "em", "strong",
    "var", "samp", "dfn", "code", "pre", "kbd", "tt",
    "big", "small", "address",

    "article", "aside", "audio", "canvas", "datalist", "details", "embed",
    "figcaption", "figure", "footer", "keygen", "mark", "meter", "nav",
    "output", "progress", "section", "source", "summary", "time", "video"
  ]
};

/**
 * Adds a function for each tag onto Template's prototype
 */
(function() {
  var tags = Jaml.Template.prototype.tags;

  /**
   * This function is created for each tag name and assigned to Template's
   * prototype below.
   */
  function makeTagHelper(tagName) {
    var fn = function(attrs) {
      var node = new Jaml.Node(tagName);

      var firstArgIsAttributes =  (typeof attrs == 'object')
                               && !(attrs instanceof Jaml.Node)
                               && !(attrs instanceof Jaml.TextNode);

      if (firstArgIsAttributes) node.setAttributes(attrs);

      var startIndex = firstArgIsAttributes ? 1 : 0;

      for (var i=startIndex; i < arguments.length; i++) {
        var arg = arguments[i];

        if (typeof arg == "string" || arg == undefined) {
          arg = new Jaml.TextNode(arg || "");
        }

        if (arg instanceof Jaml.Node || arg instanceof Jaml.TextNode) {
          arg.parent = node;
        }

        node.addChild(arg);
      };

      this.nodes.push(node);

      return node;
    };

    fn.__isTagHelper = true;

    return fn;
  }

  for (var i = tags.length - 1; i >= 0; i--){
    var tagName = tags[i];
    Jaml.Template.prototype[tagName] = makeTagHelper(tagName);
  };
})();

Jaml.registerHelpers({
  _interpretTemplate: function(arg) {
    var template = null;
    if (typeof arg === 'string') {
      template = (arg in Jaml.templates) ?
       new Jaml.Template(Jaml.templates[arg]) : arg;
    }

    if (typeof arg === 'function') {
      template = new Jaml.Template(arg);
    }

    return template;
  },

  _normalize: function(item, data) {
    return typeof item === 'string' ? item : item.render(data);
  },

  /**
   * Renders a template identified by name _or_ an anonymous function.
   * @param {String | Function} name The name of the template to render, or a
   *   function that can be passed to the `Jaml.Template` constructor.
   * @param {Object} data Optional data object
   */
  renderToString: function(template, data) {
    template = this._interpretTemplate(template);
    return this._normalize(template, data);
  },

  renderIf: function(condition, template, data) {
    if (!!condition) {
      return this.renderToString(template, data);
    }

  },

  renderCollection: function(name, collection) {
    var result = [], data;
    for (var i = 0, len = collection.length; i < len; i++) {
      data = collection[i];
      result.push(Jaml.render(name, data));
    }

    return result.join('\n');
  }
});