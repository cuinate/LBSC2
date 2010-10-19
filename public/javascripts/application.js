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


 var initializeAdmin = function() {
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
	 		var content = $('<div/>', {
	           'class': 'place_search_result'
	         })
	         .append($('<span/>', {
	           text: text_result
	         }))
			 .append($('<span/>'))
			 .append($('<a/>',{
	           click: function() {
	             save_new_add_place(place_lists[p]);
	           },
	           text: "添加"
	         }));
	
	      
	
	// 3 --- append function to marker 
		google.maps.event.addListener(marker, 'click', function(){
			 infoWindow.setContent(content.get(0));
	         infoWindow.open(map, marker);
		});
		
	//	open_marker_info_window(place_list, marker));
	// 4. --- append the result to search place list 
	     
	 //  $("#place_result").append(content);
	    
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
	
	function search_place_callback(data){
		var timer;
		var search_result = $("#search_result").empty().show();
		if (data.length > 0){
			
		}
		else{
		// showing no place found and tell user to add the place
		search_result.append('<li class = "search_result_new_place" id="search_add_new_place"> 没有发现地点，新增一个吧！</li>')
		setTimeout(hide_search_result,10000);
		$("#search_add_new_place").click(function(){
			search_add_new_place();
		});
		}
	
	}
	
	function search_add_new_place(){
		 $("#select_place_dialog").dialog("open");
		return false;
	}
	

	
	var initializeAdmin = function(){
		initializeDefaults();
		
//		$("#search_input").keyup(function(){
		$("#search_input").live("change",function(){
			var query = $(this).val();
			add_place_name = query;
			if (query.length > 0){
				$.getJSON(
					'showplace.json',
					{	type:    1,
						paras:  query
					},
					search_place_callback
					);
				
			}
		});
	
// search place dialog 
	$('#select_place_dialog').dialog({
      autoOpen: false,
      modal: true,
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

		
	}
	
	
	
	
	return {
	initializeAdmin: initializeAdmin	
	};
}();