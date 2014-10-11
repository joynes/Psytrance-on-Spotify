var columns = 4;
var maxCount = 16;
var guid = null;
jQuery.support.cors = true;
var style = "All";
var filter = "grey";
var page = "0";

function onLoginAttempt(uid) {
	//alert("uid = " + uid + " guid  = " + guid);
	if (uid == null) {
		var savedUid = $.cookie("guid");
		if (savedUid != null && savedUid != "") {
			guid = savedUid;
		}
		//alert("uid = " + uid + " guid  = " + guid);
	}
	else 
		guid = uid;
	$.cookie("guid", guid, { expires: 999 });
	buildTable(style, page, filter);
}

function onClickLink(url, id) {
	
	var tag = '#' + id;
	$(tag).addClass('lessOpacity');

	if (guid != null) {
		query = 'http://psytrance.se/albumClicked.php?uid=' + guid + "&url="
				+ url;

		$.ajax({
			url : query,
			dataType : 'text',
			cache : false, // 'cache: false' must be present for IE 7 & 8
			success : function(data) {
				//console.log(data);
				window.location = url;
			}

		});
	}
	else {
		window.location = url;
	}
}

function buildTableCallback(data) {
	var count = data.size;
	data = data.albums;

	$('table').remove();
	$('#pageinator').remove();
	$('#feedback').remove();

	$('#bodydiv').append(
			'<table cellpadding="0" border="0" cellspacing="10" width="1100px">');

	for ( var i = 0; i < data.length; i++) {
		if (i % columns == 0) {
			$('table').append('<tr id="tr' + i + '" ' + 'align="center">');
		}

		tag = "#tr" + Math.floor(i / columns) * columns;

		var imgClass = '';
		//console.log(data[i].uid);
		if (data[i].uid != null && filter == 'grey') {
			imgClass = ' class="lessOpacity" ';
		}
		var img = '<img width="180" id="e' + i + '"src="' + data[i].image + '" border="0" ' + imgClass + '/>';
		
		var cell = '<a href="javascript:onClickLink:onClickLink(\'' + data[i].spotify + '\', \'e' + i + '\');">' + img + '</a><br/>';
		text = data[i].title + ' (' + data[i].info + ')' + '<div style="color:#aaa;">' + data[i].artist + '</div>';

		cell += text;
		cell += '<div style="font-style:italic;font-size:80%">' + data[i].releasedate
				+ '&nbsp;<a STYLE="TEXT-DECORATION: NONE;" href="' + data[i].psyshop + '">buy</a></div>';
		
		$(tag).append('<td>' + cell + '</tr>');

	}

	$('#bodydiv').append('<div id="pageinator" align="center" style="padding: 30px;">Page: </div>');

	for ( var i = 0; i < (count / maxCount); i++) {
		var color = "";
		if (page == i) color = "color:yellow;";
		$('#pageinator').append('&nbsp;<a id="' + i + '" href="page" STYLE="TEXT-DECORATION: NONE; ' + color + '"> ' + i + ' </a>&nbsp;');

	}

	$('#pageinator').click(
			function(event) {
				event.preventDefault();
				page = $(event.target).attr('id');
				
				$.cookie("page", page, { expires: 999 });
				buildTable(style, page, filter);

			});
	$('#bodydiv').append('<a id="feedback" style="padding: 10px;" href="http://www.facebook.com/pages/Psytrance-from-Spotify/229788967085077"> Give feedback </a>');

}

function buildTable(style, page, filter) {
	uid = guid;
	if (filter == 'all') uid = null;
	
	query = 'http://psytrance.se/rest.php?style=' + style + '&page=' + page
			+ '&pageSize=' + maxCount + '&uid=' + uid + "&filter=" + filter;
	
	console.log("query " + query);
	$.ajax({
		url : query,
		dataType : 'json',
		cache : false, // 'cache: false' must be present for IE 7 & 8
		success : function(data) {
			buildTableCallback(data);
		}

	});

	$.getJSON(query, function(data) {

	});
}
$(document).ready(function() {
	///onLoginAttempt('527887425');
	
	// coockie handling
	var savedStyle = $.cookie("style");

	if (savedStyle != null && savedStyle != "")
		style = savedStyle;
	$("[name=style]").filter("[value=" + style + "]").prop("checked", true);

	var savedFilter = $.cookie("filter");

	if (savedFilter != null && savedFilter != "")
		filter = savedFilter;
	$("[name=filter]").filter("[value=" + filter + "]").prop("checked", true);
	
	var savedUid = $.cookie("guid");
	if (savedUid != null && savedUid != "") {
		guid = savedUid;
	}

	var savedPage = $.cookie("page");

	if (savedPage != null && savedPage != "")
		page = savedPage;
	
	$(":radio").click(function countChecked() {
		if (this.name == 'style') {
			style = $("input[name='style']:radio:checked").val();
			$.cookie("style", style, { expires: 999 });
			buildTable(style, 0, filter);
		} else if (this.name == 'filter') {
			if (guid == null) {
				alert("You must log in with facebook to be able to filter");
			} else {
				filter = $("input[name='filter']:radio:checked").val();
				$.cookie("filter", filter, { expires: 999 });
				buildTable(style, 0, filter);
			}
		} else {
			alert('What checkbox?');
		}

	});

	buildTable(style, page, filter);
	

});
