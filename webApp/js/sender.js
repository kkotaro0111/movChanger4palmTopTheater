$(function(){
	ws = new WebSocket("ws://utageworks.jpn.ph:9001");
	ws.onmessage = function(evt) {
		//$("#middle").append("<p>"+evt.data+"</p>");
		console.log(evt);
	};

	ws.onclose = function() {
		console.log("closed sender")
	};

	ws.onopen = function() {
		console.log("sender open");
		ws.send("msg:Connected");
	};

	$("body").on("keypress",".itext",function(e){
		var t = $(this);
		var i = t.attr("id");
		if(e.keyCode ==13){
			var val = t.val();
			ws.send(i+":"+val);
			t.val("");
		}
	});
});
