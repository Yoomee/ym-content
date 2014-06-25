// handles page search - uses navAutocomplete widget
window.SearchManager = {
  init: function() {

    function loadContentPageInTree(cp_id) {
      window.location.href = "/content_packages?open=" + cp_id;
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
