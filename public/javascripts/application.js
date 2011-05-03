// application function define

function set_title(photo_id){
  $('#photo_set_title_' + photo_id).show();
  $('#set_title_' + photo_id).hide();
  $('#delete_link_' + photo_id).hide();$('#sumbit_link_' + photo_id).show();
};

function load_bindngs(){
	$(".timeago").each(function(){$(this).html('(' + jQuery.timeago($(this).html()) + ')');$(this).removeClass('timeago')});
	$('.event_reply').click(function(){$(this).parent().next().toggle();return false});
	$('.reply_reply').click(function(){
			var reply_field = $(this).parent().parent().parent().parent().find('input[type=text]')
			reply_field.val($(this).attr('title'));
			reply_field.focus();
			return false;
			});
	$('pre').each(function(index){$(this).html($(this).html().replace(/(http:\/\/|https:\/\/)((\w|=|\?|\.|\/|&|-|!|#|%)+)/g, "<a href='$1$2' target='_blank' rel='nofollow'>$1$2</a>"))});
	$('form').submit(function(){$(this).find('input:submit').attr('disabled',true)});
	$(".zoom_photo").click(function(){$(this).children().first().toggle();$(this).children().last().toggle();return false});
	$(".event_box").hover(
		function () {$(this).addClass("hover");},
		function () {$(this).removeClass("hover");}
	);
}

function more_timeline(dom){
  dom.html('读取中...');
  $.get(dom.attr('href'),function(data){
    dom.replaceWith(data);
    load_bindngs()
  });
  return false;
};

function redirect_clear(id, type){
    $.post('/notifications/redirect_clear',{'id':id,'type':type});
    };

// bindings
$(document).ready(function(){
  load_bindngs()
  $(".open_dialog").click(function(){dialog($(this).attr('title'),("url:"+$(this).attr('href')),"570px","auto","text");  return false;})
  $(".answer").click(function(){dialog($(this).attr('title'),("id:"+$(this).attr('href')),"570px","auto","text");  return false;})
  $('#dialog_flash a').click();
  $('.with_tip').poshytip({
    className: 'tip-yellowsimple',
    showOn: 'focus',
    alignTo: 'target',
    alignX: 'right',
    alignY: 'center',
    offsetX: 5
  });
  
  $('.with_explain').poshytip({
    className: 'tip-yellowsimple',
    showTimeout: 1,
    alignTo: 'target',
    alignX: 'center',
    offsetY: 5,
    allowTipHover: false
  });
  
  if(!('placeholder' in document.createElement('input'))){
    $('input[placeholder!=""]').hint();
  };
  
  $(".tabContents").hide();
  $(".tabContents:first").show();
  $("#tabContaier ul li a:first").addClass("active");
  $("#tabContaier ul li a").click(function(){ 
    var activeTab = $(this).attr("href"); 
    $("#tabContaier ul li a").removeClass("active"); 
    $(this).addClass("active");
    $(".tabContents").hide();
    $(activeTab).fadeIn();
    return false;
  });
})
