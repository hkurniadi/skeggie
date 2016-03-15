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
		if (document.getElementById("search_term").value.split(" ")[1].length == 3 || (document.getElementById("search_term").value.split(" ")[1].length == 4 && document.getElementById("search_term").value.split(" ")[1][3] == "W")){
			url += "/" + semester + "%20" + year + "/" + document.getElementById("search_term").value.split(" ").join("/")+"/1";
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
  var url= baseUrl + "/" + document.getElementById("semester").value + "/" + document.getElementById("department").value;
  if ((document.getElementById("coursenum").value != '') && (document.getElementById("coursenum").value.length == max)) {
    url += "/" + document.getElementById("coursenum").value + "/" + document.getElementById("sortby").value;
    var tempCourseNum = document.getElementById("coursenum").value;
  }
  location.href=url;
  return false;
}

function setValue(valueToSelect, idToSelect)
{
  var element = document.getElementById(idToSelect);
  element.value = valueToSelect;
}