// Lee dialog 1.0 http://www.xij.cn/blog/?p=68

var dialogFirst=true;
function dialog(title,content,width,height,cssName){

if(dialogFirst==true){
  var temp_float=new String;
  temp_float="<div id=\"floatBoxBg\" style=\"height:"+$(document).height()+"px;filter:alpha(opacity=0);opacity:0;\"></div>";
  temp_float+="<div id=\"floatBox\" class=\"floatBox\">";
  temp_float+="<div class=\"dialog_title\"><h4></h4><span id='close_dialog'>关闭</span></div>";
  temp_float+="<div class=\"dialog_content\"></div>";
  temp_float+="</div>";
  $("body").append(temp_float);
  dialogFirst=false;
}

$("#floatBox #close_dialog").click(function(){
  $("#floatBoxBg").animate({opacity:"0"},"normal",function(){$(this).hide();});
  $("#floatBox").animate({top:($(document).scrollTop()-(height=="auto"?300:parseInt(height)))+"px"},"normal",function(){$(this).hide();}); 
});
$("#floatBoxBg").click(function(){$("#floatBox #close_dialog").click()})

$("#floatBox .dialog_title h4").html(title);
contentType=content.substring(0,content.indexOf(":"));
content=content.substring(content.indexOf(":")+1,content.length);
switch(contentType){
  case "url":
  var content_array=content.split("?");
  $("#floatBox .dialog_content").ajaxStart(function(){
    $(this).html("读取中..请稍后");
  });
  $.ajax({
    url:content_array[0]+"?layout=false&" + content_array[1],
	error:function(){
	  $("#floatBox .dialog_content").html("error...");
	},
    success:function(html){
      $("#floatBox .dialog_content").html(html);
    }
  });
  break;
  case "text":
  $("#floatBox .dialog_content").html(content);
  break;
  case "id":
  $("#floatBox .dialog_content").html($("#"+content+"").html());
  break;
  case "iframe":
  $("#floatBox .dialog_content").html("<iframe src=\""+content+"\" width=\"100%\" height=\""+(parseInt(height)-30)+"px"+"\" scrolling=\"auto\" frameborder=\"0\" marginheight=\"0\" marginwidth=\"0\"></iframe>");
}

$("#floatBoxBg").show();
$("#floatBoxBg").animate({opacity:"0.6"},"normal");
$("#floatBox").attr("class","floatBox "+cssName);
$("#floatBox").css({display:"block",left:(($(document).width())/2-(parseInt(width)/2))+"px",top:($(document).scrollTop()-(height=="auto"?300:parseInt(height)))+"px",width:width,height:height});
$("#floatBox").animate({top:($(document).scrollTop()+80)+"px"},"fast"); 
}
