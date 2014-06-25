$(document).ready(function(){
  $('.more-persona').on('click', function(){
    $(this).parent('.row').next('.persona-summary').toggle();
  });
  $('#content_attributes').on('click', '.nested-fields .reveal', function(e){
    e.preventDefault();
    $(this).next('.hide-it').slideToggle();
    if($('.hide-it').is(':visible')){
      $(this).text('Show less');
    }
    else{
      $(this).text('Show more');
    }
  });
});