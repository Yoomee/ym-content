$(document).ready(function(){
  if ($(window).width() < 300) {
   $('.cms-sidebar').removeClass("affix-bottom");
  }

  $('.control-label').click(function(){
    $(this).next('.form-wrapper').fadeToggle();
  });
});