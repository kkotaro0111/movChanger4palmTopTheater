$("#addBtn").on("click",function(){
	$.ajax({
		dataType: "json",
	url: "http://gdata.youtube.com/feeds/api/videos?alt=json&max-results=10&v=2&orderby=published&q=" + $("#addyoutube").val(),
	success: function(){
		var json = arguments[0];
		console.log("ajax", json.feed.entry);
		var ul = $("<ul>");
		$.each(json.feed.entry, function(index,entry){
			console.log(entry);
			console.log(entry.media$group.media$title);
			var thumb = $("<img>").attr({
				src: entry.media$group.media$thumbnail[0].url,
				width: entry.media$group.media$thumbnail[0].width,
				height: entry.media$group.media$thumbnail[0].height,
			});
			var title = $("<p>").text(entry.media$group.media$title.$t);
			var list = $("<li>").html(thumb).append(title);
			ul.append(list);
		});
		$("#searchlist").html(ul);
	}
	});
});

function showMyVideos(json){
	console.log(arguments);
	var str = JSON.stringify(json);
	console.log(str);
}

function listVideo(){
	console.log(arguments);
}
