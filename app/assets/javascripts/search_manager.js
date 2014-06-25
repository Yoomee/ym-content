// handles page search - uses navAutocomplete widget
window.SearchManager = {
  init: function() {
    // TODO: loading animations, clear input after content replaced
    // TODO: write test
    function loadContentPageInTree(cp_id) {
      $.ajax({
        type: 'GET',
        url: '/content_packages?open=' + cp_id,
        dataType: "script"
      });
      return false;
    }

    $("#content_search_link").navAutocomplete({
      source: "/navigation_items/search",
      minlength: 2,
      select: function(event, ui) {
        loadContentPageInTree(ui.item.id);
      }
    });

    $("#content_search_link").on("click", function() {
      return this.select();
    });
  }
};
