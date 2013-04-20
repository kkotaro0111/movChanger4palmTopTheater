var c, v, ctx;

function init(){
	c = document.getElementById("canvastag");
	v = document.getElementById("videotag");
	ctx = c.getContext("2d");
	console.log(c, v);
	/*
	   setInterval(function(){
	   drawVideo();
	   }, 1000/30);
	   */
	webkitRequestAnimationFrame(drawVideo);

}

function drawVideo(){
	ctx.save();
	ctx.drawImage(v, 0, 0, 640, 360);
	ctx.restore();
	webkitRequestAnimationFrame(drawVideo);
}

init();


