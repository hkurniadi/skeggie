function q_search()
{
	var today = new Date();
	var month = today.getMonth() + 1;
	var year = today.getFullYear();
	var getUrl = window.location;
	var baseUrl = getUrl.protocol + "//" + getUrl.host;
	if (document.getElementById("search_for").value == "1") {
		var url = baseUrl + "/search";
		if (document.getElementById("search_term").value != "" && document.getElementById("search_term").value.split(" ").length == 2) {
			if(month >=1 && month <= 4) {
			var semester = "Spring";
		}
		else if(month >=5 && month <=8) {
			var semester = "Summer";
		}
		else {
			var semester = "Fall";
		}
		//if (document.getElementById("search_term").value.split(" ")[1].length == 3 || (document.getElementById("search_term").value.split(" ")[1].length == 4 && document.getElementById("search_term").value.split(" ")[1][3] == "W")){
		if (document.getElementById("search_term").value.split(" ")[1].length <= 4){
			url += "/" + semester + "%20" + year + "/" + document.getElementById("search_term").value.toLowerCase().split(" ").join("/")+"/1";
		}
		}
		location.href = url;
	}
	else {
		var url = baseUrl + "/" + "profile/search";
		if (document.getElementById("search_term").value != ""){
				url += "/1/" + document.getElementById("search_term").value;
		}
		location.href = url;
	}
	return false;
}

function process()
{
  var getUrl = window.location;
	var max = document.getElementById("coursenum").maxLength;
  var baseUrl = getUrl.protocol + "//" + getUrl.host + "/" + getUrl.pathname.split('/')[1];
  var url= baseUrl + "/" + document.getElementById("semester").value + "/" + document.getElementById("department").value.toLowerCase();
	var wqb = false;
  
  if ((document.getElementById("coursenum").value != '') && (document.getElementById("coursenum").value.length <= max)) {
    url += "/" + document.getElementById("coursenum").value.toLowerCase() + "/" + document.getElementById("sortby").value;
    var tempCourseNum = document.getElementById("coursenum").value;
  }
  if (document.getElementById("wqb_0").checked == true) {
  	url += "/Writing";
		var wqb = true;
  }
  if (document.getElementById("wqb_1").checked == true) {
		if (wqb == false){
			wqb = true
			url += "/Quantitative"
		}
		else {
			url += "&Quantitative";
		}
  }
	if (document.getElementById("wqb_2").checked == true) {
		if (wqb == false){
			wqb = true
			url += "/Breadth-Humanities";
		}
		else {
			url += "&Breadth-Humanities";
		}
  	
  }
	if (document.getElementById("wqb_3").checked == true) {
		if (wqb == false){
			wqb = true
			url += "/Breadth-Science";
		}
		else {
			url += "&Breadth-Science";
		}
  	
  }
	if (document.getElementById("wqb_4").checked == true) {
		if (wqb == false){
			wqb = true
			url += "/Breadth-Social_Sciences";
		}
		else {
			url += "&Breadth-Social_Sciences";
		}
  	
  }
  location.href=url;
  return false;
}

function setValue(valueToSelect, idToSelect)
{
  var element = document.getElementById(idToSelect);
  element.value = valueToSelect;
}