$(document).ready(function(){
  $('.more-persona').on('click', function(){
    $(this).closest('.row').next('.persona-summary').toggle();
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
      $('#content_package_publish_at_fields').removeClass('hidden');
    }
    else{
      $('#content_package_publish_at_fields').addClass('hidden');
    }
  });
  $('input#content_package_publish_at').change(function() {
    if ($('input#content_package_publish_at').val()) {
      $('#content_package_publish_at_fields .help-block').removeClass('hidden');
    }
    else{
      $('#content_package_publish_at_fields .help-block').addClass('hidden');
    }
  });
});
