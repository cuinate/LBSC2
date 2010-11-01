// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :default

//------------------------------------------------//
//          LBSC V2 module
//------------------------------------------------//
var Lbsc2 = {
	
	flashDialog: function(status, title, body) {
		  		if (status === 'fail') status = 'error';
				  Lbsc2.Flash.add(status, body);
		},
	check_login:function(){
		 var log_in_sign = $('#login_sign').attr("user");
		 if (log_in_sign == "yes")
		   return true;
		 else
          return false;
	}
}

//------------------------------------------------//
//          flash message
//------------------------------------------------//
Lbsc2.Flash = (function() {

  var DISPLAY_DURATION   = 5000;
  var ANIMATION_DURATION = 200;

  function slideUp(element) {
    $(element).slideUp(ANIMATION_DURATION);
  }

  function deferredSlideUp(element) {
    return function() {
      slideUp(element);
    }
  }

  Jaml.register('new_flash_dialog', function(data) {
    with(this) {
      div({ cls: 'flash_msg ' + data.type },
        p(data.message)
      );
    }
  });

  return {
    setup: function() {
      $('div.flash_msg').each( function(i, el) {
        window.setTimeout(deferredSlideUp(el), DISPLAY_DURATION);
      });
    },

    add: function(type, message) {
      var data = {
        type: type || 'success',
        message: message || ''
      };

      var $msg = $( Jaml.render('new_flash_dialog', data) );
      $msg.hide().prependTo(document.body).slideDown(ANIMATION_DURATION);

      window.scrollTo(0, 0);
      window.setTimeout(deferredSlideUp($msg[0]), DISPLAY_DURATION);
    },

    success: function(message) {
      this.add('success', message);
    },

    error: function(message) {
      this.add('error', message);
    }
  }
})();

/*---------------------------------------------------------------------*/
/*        			lbsc V2 function moudle         				   */
/*---------------------------------------------------------------------*/
var lbsc = function(){
	
  var defaultLatLng;
  var defaultZoom = 13;
  var geocoder;
  var infoWindow; 
  var map;
  var marker;
  var markers;
  var place_list = new Array(); //for one single place item: hash table
  var place_lists = new Array();
  var maxZoom = 15;
  var add_place_name;
  var searchResultSelection = 0;
	
/*---------------------------------------------------------------------*/
/*        			google map 										   */
/*---------------------------------------------------------------------*/

 var centerMapOnAddress = function() {
    geocodeAddress($.trim($('#address').val()));
  }


 var initializeAdmin1 = function() {
    initializeDefaults();
    initializeMap('gmap_wrap');
    centerMapOnAddress();

    $('#center_map').click(function() {
      centerMapOnAddress();
    });
  }

  var initializeDefaults = function() {

    defaultLatLng = new google.maps.LatLng(39.989059, 116.351811);
    geocoder = new google.maps.Geocoder();
    infoWindow = new google.maps.InfoWindow();
    marker = new google.maps.Marker({ draggable: true });
    markers = [];

    google.maps.event.addListener(marker, 'dragend', function() {
      setPosition(marker.getPosition());
    });

    $(document).ajaxError(function(e, xhr, settings, exception) {
      if (xhr.status == 400) {
        alert($.parseJSON(xhr.responseText).error);
      } else {
        alert('ZOMG! An error ocurred, please try again.');
      }
    });
  }

  var initializeMap = function(id) {
    map = new google.maps.Map(document.getElementById(id), {
      center: defaultLatLng,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      zoom: defaultZoom
    });
  }


// search google map based on the string input
 var search = function(place_name) {
    $('.s_result').hide().filter('.searching').show();
    var search_name = place_name;

    geocoder.geocode({ 'address': search_name }, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
	    
		$.each(results, function(p, place) {
	//	 var place = data;
		 var place_latitude = place.geometry.location.lat();
		 var place_longtitude = place.geometry.location.lng();
	    // 1.---- first to save the required information into array. 
	     
	   		for (i=0; i<place.address_components.length; i++){
				for (j=0;j<place.address_components[i].types.length;j++)
				{
				if(place.address_components[i].types[j] == "point_of_interest")
					place_list["name"] =  place.address_components[i].long_name;
				if(place.address_components[i].types[j] == "locality")
					place_list["city"] = place.address_components[i].long_name;
				}
			}
			place_list["latitude"] = place_latitude;
			place_list["longtitude"]= place_longtitude;
			place_list["address"] = place.formatted_address;
		    place_lists.push(place_list);
	  // 2 --- save to markers on google map;
		var latLng = new google.maps.LatLng(place_latitude, place_longtitude);
	       var marker = new google.maps.Marker({
	         map: map,
	         position: latLng, 
	         title: place_list["address"] 
	       });

		   var place_list_index = place_lists.index;
	       markers.push(marker);
	
	  // 3. generate dynamic content 
	        var place_index = p + 1;
	        var text_result = place_index  + ": " + place_list["name"];
	 		var content = $('<div/>')
	         .append($('<span/>', {
			  'class':'infowindow_text',
	           text: text_result
	         }))
			 .append("<br><br>")
			 .append($('<a/>', {
			 'class':'add_place_button',
	           click: function() {
	             save_new_add_place(place_lists[p]);
	           },
			   text: "添加地点"
	         }));
	
	      
	
	// 3 --- append function to marker 
		google.maps.event.addListener(marker, 'click', function(){
			 infoWindow.setContent(content.get(0));
	         infoWindow.open(map, marker);
		});
		
	//	open_marker_info_window(place_list, marker));
	// 4. --- append the result to search place list 
	     var place_content = $('<li/>',
			  {'class': 'search_place_list'})
			 .append($('<a/>', {
	           click: function() {
				google.maps.event.trigger(markers[p],"click");
	           },
			   text: text_result
	         }))
			.append('<br>');
			
	   $("#place_result").append(place_content);
	    
      });

    }}
      );
  }

 var save_new_add_place = function(place){
	//post current place 
	$("#select_place_dialog").dialog("close");
	$.post(
	'/addplace', 
      {
		name : place["name"],
		address : place["address"],
		latitude :place["latitude"],
		longtitude: place["longtitude"],
		city:place["city"],
		authenticity_token: authToken()
	  },
	  function(data){

	   $(this).dialog("close");
		}

    );

	return false;
  
	
}

/* ------ open marker info window -----------*/
  var open_marker_info_window = function(place_list,marker)
	{
	  	 var content = $('<div/>', {
           'class': 'lb_field_tag'
         })
         .append($('<span/>', {
           text: place_list["address"]
         }));


         infoWindow.setContent(content.get(0));
         infoWindow.open(map, marker);
	}
/*---------------------------------------------------------------------*/
/*        			application related 							   */
/*---------------------------------------------------------------------*/

   function get_new_place_list(){
	  var add_place_city = IPData[2];
	  var search_name = add_place_name + " " + add_place_city;
	  search(search_name);
    }

	function hide_search_result(){
		$("#search_result").css("display","none");
	}
// search box callback function 
	function search_place_callback(data){
		
		var timer;
		var search_result = $("#search_result").empty().show();
		$("#search_loading").css("display","none");
		if (data.length > 0){
			$.each(data, function(p, place) {
			var place_name = place.place["name"];
			var place_address = place.place["address"];
			var place_link = "/places/" + place.place["id"];
			place_name = "地点：" + place_name ;
			 search_result.append($('<li/>', {
				 'class':'search_place_have_result',
				// 'id': place.place["id"],
		           click: function() {
					window.location.replace(place_link);
		           //alert("got you!" + place_link);
		 			//$("#ask_question_place_name").append(place.place["name"]);
					//$("#ask_question_place_id").attr("value",place.place["id"]);
					//$("#ask_question_dialog").dialog("open");
		           },
				   text: place_name,
				   title: place_address,
				   url:place_link
		         }));
			});
		//setTimeout(hide_search_result,5000);
		}
		else{
		// showing no place found and tell user to add the place
		search_result.append('<li class = "search_result_new_place" id="search_add_new_place"> 没有发现地点，新增一个吧！</li>')
		setTimeout(hide_search_result,5000);
		$("#search_add_new_place").click(function(){
		  //	alert("got tyou");
		   if (Lbsc2.check_login())
			search_add_new_place();
		   else
			{
				Lbsc2.flashDialog('success', 'Success!', '你还没有登录！现在转向登录页面！');
			//	setTimeout(window.location.replace("/login"),2*10000);
				window.location.replace("/login");
			//	window.location ="/login";
	    	}
		});
		}
	
	}
	
	function search_add_new_place(){
		 $("#select_place_dialog").dialog("open");
		return false;
	}
    function clear_dialog() {
		infoWindow.close();
 		markers = [];
		$("#place_list").empty().show();
     }


    
   /* ------- search box result function   -----------------*/
   function search_navigate(direction){
	$("#search_input").trigger("focusout");
//	$("#search_result").trigger("keydown");
	 if($("#search_result li .search_result_item_hover").size == 0){
		searchResultSelection == -1;
	}
	 if(direction == 'up' && searchResultSelection != -1){
		if(searchResultSelection !=0)
			searchResultSelection--;
	}
	else if(direction == 'down'){
		if(searchResultSelection != $("#search_result li").size() - 1){
			searchResultSelection++;
		}
	}
	$("#search_result li").removeClass("search_result_item_hover");
	$("#search_result li").eq(searchResultSelection).addClass("search_result_item_hover");
	
   }
   /* ------- place/id page question navigation switching function   -----------------*/
	function place_id_question_nav(nav_tab)
	{
		id = $('#place_id_nav').attr("place_id");
		nav_type = $("#ql_nav_which").attr("nav_type");

		$("#"+ nav_type).attr('class','inactive');
		$(nav_tab).attr('class','question_list_active');

		q_type= $(nav_tab).attr("id");
		$("#ql_nav_which").attr("nav_type",q_type);

		$.get(
			"/showplace.js",
			{
				id: id ,
				type:q_type
			}

			);
	}
  /* ------- initialization function   -----------------*/
	var initializeAdmin = function(){
		initializeDefaults();
		$("#search_input").focus(function(){
			this.value = '';
	/*		$("#search_input").bind('keypress',function(e){
				if(e.keyCode == 40)
				 {
				  search_navigate('down');
				 }
			});*/
			$("#search_input").bind('keyup',function(e){
				var query = $(this).val();
				add_place_name = query;
				if (query.length > 0){
			//		$("#search_loading").css("display","block");
					$.getJSON(
						'/place/like.json',
						{
							paras:  query
						},
						search_place_callback
						);
			 		if(e.keyCode == 40)
					 {
					 // search_navigate('down');
					 }
			}
			});
		});
		
		/*------ search input focus out ---------*/
		$("#search_input").focusout(function(){
			$("#search_input").unbind("keyup");
			this.value = '输入地点名称进行查询：';
		});

		$("#search_result").keydown(function(e) {
		      switch(e.keyCode) { 
		         // User pressed "up" arrow
		         case 38:
		            search_navigate('up');
		         break;
		         // User pressed "down" arrow
		         case 40:
		            search_navigate('down');
		         break;
		         // User pressed "enter"
		         case 13:
					currentUrl = $("#search_result li").eq(searchResultSelection).attr("url");
		            if(currentUrl != '') {
		               window.location = currentUrl;
		            }
		         break;
		      }
		});

		// place/id view question ajax  --- render partial view 
		$("#open_question").click(function(){
			var nav_tab = "#open_question";
			place_id_question_nav(nav_tab);
		});
		$("#new_question").click(function(){
			var nav_tab = "#new_question";
			place_id_question_nav(nav_tab);
		});
	
		$("#hot_question").click(function(){
			var nav_tab = "#hot_question";
			place_id_question_nav(nav_tab);
		});
		
		$("#place_activities").click(function(){
			var nav_tab = "#place_activities";
			place_id_question_nav(nav_tab);
		});

	    // follow question handling 
    	$('#qfollowship_link').click(function(){
		 	 var	question_id = $('#question_page_id').attr("question_id");
			 var	user_id  = $('#user_id_nav').attr("user_id");
			 var	qfollowship = $('#followship_quesition').attr("class");
			 var    action_id;
			if (qfollowship == "followed_on")
				{
					$('#followship_quesition').attr("class","followed_off");
					action_id = 8 ; // remove the followship
					$.get(
						"/action.json",
						{
							user_id: user_id,
							question_id: question_id,
							action_id: action_id
						},
						function(data){
								Lbsc2.flashDialog('success', 'Success!', '你已经成功移除此问题的关注！');
						});			
				}
			else
				{
					$('#followship_quesition').attr("class","followed_on");
					action_id = 6; // add the followship
					$.get(
						"/action.json",
						{
							user_id: user_id,
							question_id: question_id,
							action_id: action_id
						},
						function(data){
								Lbsc2.flashDialog('success', 'Success!', '你已成功地添加此问题的关注！');
						});

				}

		});
		// following:unfollow place ajax handling 
		$('#followship_link').click(function(){
		 	 var	place_id = $('#place_id_nav').attr("place_id");
			 var	user_id  = $('#user_id_nav').attr("user_id");
			 var	followship = $('#followship_place').attr("class");
			// qustion_id for question page 
			// question_id = 
			 var    action_id;
			if (followship == "followed_on")
				{
					$('#followship_place').attr("class","followed_off");
					action_id = 7 ; // remove the followship
					$.get(
						"/action.json",
						{
							user_id: user_id,
							place_id: place_id,
							action_id: action_id
						},
						function(data){
								Lbsc2.flashDialog('success', 'Success!', '你已成功移除此地点的关注！');
						});			
				}
			else
				{
					$('#followship_place').attr("class","followed_on");
					action_id = 5; // add the followship
					$.get(
						"/action.json",
						{
							user_id: user_id,
							place_id: place_id,
							action_id: action_id
						},
						function(data){
								Lbsc2.flashDialog('success', 'Success!', '你已成功添加此地点的关注！');
						});
			
				}
	
		});
	
		// search place dialog 
			$('#select_place_dialog').dialog({
		      autoOpen: false,
		      modal: true,
			  beforeclose: function(event, ui) {
		       		infoWindow.close();
			 		markers = [];
					$("#place_list").empty();
		      },
			  open: function(event, ui) {
		       // $('#search_places_name').val('');
		        // $('#search_places_address').val('');
		        $('.s_result').hide().filter(':first').show();
				get_new_place_list();
		        initializeMap('search-map');
		      },
			  buttons:{
		      "取消": function() {
							$(this).dialog("close");
		        	      }
			  },
		      width: 720,
		      resizable: false
		    });

		// ask quesiton dialog 
			$('#ask_question_dialog').dialog({
		      autoOpen: false,
		      modal: true,
			  buttons:{
		      "OK": function() {
							// post "question" back to server and save it 
							place_id = $("#ask_question_place_id").val();
							description = $("#question_input").val();
							points = $("#question_points option:selected").text();
							$.post(
							'/addquestion', 
						      {
								place_id : place_id,
								description: description,
								points :points,
								authenticity_token: authToken()
							  },
							  function(data){

							   $(this).dialog("close");
								}

						    );
							$(this).dialog("close");
		        	      }
			  },
		      width: 300,
			  height: 250,
		      resizable: false
		    });
		
		}
	
	
	
	
	return {
	initializeAdmin: initializeAdmin	
	};
}();
