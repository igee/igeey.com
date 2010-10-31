// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
  $(document).ready(function(){
    $('#dialog_flash a').click();
    
    $(".open_dialog").click(function(){dialog($(this).attr('title'),("url:"+$(this).attr('href')),"540px","auto","text");  return false;})
    
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
    
    $(".event_box").hover(
      function () {
        $(this).addClass("hover");
      },
      function () {
        $(this).removeClass("hover");
      }
    );
    
    $(".tabContents").hide(); // Hide all tab conten divs by default
    
    $(".tabContents:first").show(); // Show the first div of tab content by default
    $("#tabContaier ul li a:first").addClass("active");
    $("#tabContaier ul li a").click(function(){ //Fire the click event
      var activeTab = $(this).attr("href"); // Catch the click link
      $("#tabContaier ul li a").removeClass("active"); // Remove pre-highlighted link
      $(this).addClass("active"); // set clicked link to highlight state
      $(".tabContents").hide(); // hide currently visible tab content div
      $(activeTab).fadeIn(); // show the target tab content div by matching clicked link.
      return false;
    });
  })  