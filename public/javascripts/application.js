// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var lbsc = function(){

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
		alert("as your wish!");
	}
	

	
	var initializeAdmin = function(){
//		$("#search_input").keyup(function(){
		$("#search_input").live("change",function(){
			var query = $(this).val();
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
		
	}
	
	
	
	
	return {
	initializeAdmin: initializeAdmin	
	};
}();