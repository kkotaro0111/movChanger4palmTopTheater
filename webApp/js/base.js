var cvs = {};

function drawVideo(){
	//console.log("test", $(c).width());
	for( var key in cvs ){
		var o = cvs[key];
		var cc = o.context;
		var v = o.video.get(0);
		if(o.width == 0){
			o.width = o.video.width();
			o.height = o.video.height();

			var pos = (o.height - o.viewcon.height()) / 2;
			o.canvas.css("top", "-" + pos + "px");
		}
		cc.save();
		cc.drawImage(v, 0, 0, 640, o.height * o.width / 640); // need change size;
		cc.restore();
	}
	webkitRequestAnimationFrame(drawVideo);
}

$(function(){
	ws = new WebSocket("ws://utageworks.jpn.ph:9001");
	ws.onmessage = function(evt) {
		evt.data.match(/^([^:]*):(.*)$/);
		var elem = RegExp.$1
		var cmt = RegExp.$2
		console.log(evt.data, elem, cmt);
		if(!/msg/.test(elem)){
			cvs[elem].width = 0;
			cvs[elem].height = 0;

			cvs[elem].src = "./movie/" + cmt + ".mp4";
			cvs[elem].video.attr("src", cvs[elem].src);
			webkitRequestAnimationFrame(drawVideo);
		}
	};

	ws.onclose = function() {
		console.log("Closed index")
	};

	ws.onopen = function() {
		console.log("recver open")
		ws.send("msg:Connected");
	};

	$("#front").on("touchstart", function(){
		location.reload();
	});

	//init
	var vc =  $("#wrap").find(".viewcon");
	vc.each(function(){
		var t = $(this);
		var id = t.attr("id");
		cvs[id] = {};
		cvs[id].viewcon = t;
		cvs[id].video = $("#v" + id);
		cvs[id].canvas = $("<canvas>").attr({
			width: "640px",
			height: "640px",
			id: "canv"+id.substr(0,1)
		});
		$("#"+id).html(cvs[id].canvas);
		cvs[id].context = cvs[id].canvas.get(0).getContext("2d");

		cvs[id].width = 0;
		cvs[id].height = 0;
	});
});
