// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
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
	        var text_result = "结果" + place_index  + ":" + place_list["name"];
	 		var content = $('<div/>')
	         .append($('<span/>', {
			  'class':'infowindow_text',
	           text: text_result
	         }))
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
		if (data.length > 0){
			$.each(data, function(p, place) {
			var place_name = place.place["address"];
			place_name = "地点：" + place_name ;
			 search_result.append($('<li/>', {
				 'class':'search_place_have_result',
				// 'id': place.place["id"],
		           click: function() {
		           // alert("got you!" + place.place["id"] + place_name);
		 			$("#ask_question_place_name").append(place.place["name"]);
					$("#ask_question_place_id").attr("value",place.place["id"]);
					$("#ask_question_dialog").dialog("open");
		           },
				   text: place_name
		         }));
			});
	//	setTimeout(hide_search_result,5000);
		}
		else{
		// showing no place found and tell user to add the place
		search_result.append('<li class = "search_result_new_place" id="search_add_new_place"> 没有发现地点，新增一个吧！</li>')
		setTimeout(hide_search_result,5000);
		$("#search_add_new_place").click(function(){
		  //	alert("got tyou");
			search_add_new_place();
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
	var initializeAdmin = function(){
		initializeDefaults();
		$("#search_input").focus(function(){
			this.value = '';
		});
		$("#search_input").focusout(function(){
			this.value = '输入地点名称进行查询：';
		});
		$("#search_input").keyup(function(){
   //		$("#search_input").live("change",function(){
			var query = $(this).val();
			add_place_name = query;
			if (query.length > 0){
				$.getJSON(
					'/place/like.json',
					{
						paras:  query
					},
					search_place_callback
					);
				
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
	
	// following place/question dialog 
	$('#follow_place').click(function(){
		place_id = $('#place_id_nav').attr("place_id");
		user_id  = $('#user_id_nav').attr("user_id");
		$.get(
			"/action.json",
			{
				user_id: user_id,
				place_id: place_id,
				action_id: 5
			});
		$('#follow_place_link').replaceWith('<div id="followed_place" class="followed_place"></div>');
		
	
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
	      "OK": function() {
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