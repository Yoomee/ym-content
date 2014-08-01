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
  $('select#content_package_status').change(function() {
    if ($('select#content_package_status option:selected').val() === 'published'){
      $('#content_package_publish_at_fields').addClass('hidden');
    }
    else{
      $('#content_package_publish_at_fields').removeClass('hidden');
    }
  });
});