// application function define

function more_timeline(dom){
  dom.html('读取中...');
  $.get(dom.attr('href'),function(data){
    dom.replaceWith(data);
    $('.timeago').trigger('replace.time');
    $('pre').trigger('replace.url');
  });
  
  return false;
};

function redirect_clear(id, type){
  $.post('/notifications/redirect_clear',{'id':id,'type':type});
};


(function($){
  
  $('.timeago').live('replace.time', function() {
    $(this).html('(' + jQuery.timeago($(this).html()) + ')').removeClass('timeago');
  }).trigger('replace.time');
  
  $('pre').live('replace.url', function() {
    var rURL = /(http:\/\/|https:\/\/)((\w|\;|=|\?|\.|\/|&|-|!|#|%)+)/g;
    $(this).html(
      $(this).html().replace(rURL, "<a href='$1$2' target='_blank' rel='nofollow'>$1$2</a>")
    );
  }).trigger('replace.url');
      
  $('.event_reply').live('click', function(e) {
    $(this).parent().next().toggle();
    e.preventDefault();
  });
  
  $('.reply_reply').live('click', function(e){
    var reply_field = $(this).parent().parent().parent().parent().find('input[type=text]');
    reply_field.val($(this).attr('title'));
    reply_field.focus();
    e.preventDefault();
  });
  
  $(".zoom_photo").live('click', function(e) {
    var childrens = $(this).children();
    childrens.first().toggle();
    childrens.last().toggle();
    e.preventDefault();
  });
  
  $(".event_box")
    .live('mouseover', function() {$(this).addClass("hover")})
    .live('mouseout', function() {$(this).removeClass("hover")});
  
  $(".following")
    .live('mouseover', function() {$(this).html('取消关注')})
    .live('mouseout', function() {$(this).html("正在关注")});

  $(".open_dialog").live('click', function(e) {
    IG.dialog.init({title: $(this).attr('title'),url: $(this).attr('href')});
    e.preventDefault();
  });
  
  $(".answer").live('click', function(e) {
    var id = $(this).attr('href');
    IG.dialog.init({title: $(this).attr('title'),content: $(id).html()});
    e.preventDefault();
  });
  
   
  $(document).ready(function(){
  
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
  
    $('textarea').autoResize()

    if(!('placeholder' in document.createElement('input'))){
      $('input[placeholder!=""]').hint();
    };
  
    $(".tabContents").hide().first().show();
    $("#tabNav li a:first").addClass("active");
    $("#tabNav li a").click(function(){ 
      var activeTab = $(this).attr("href"); 
      $("#tabNav li a").removeClass("active"); 
      $(this).addClass("active");
      $(".tabContents").hide();
      $(activeTab).fadeIn();
      return false;
    });
  
    $('#dialog_flash a').click();  
    
  });  
  
}( jQuery ));
