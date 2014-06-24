// handles page search
window.SearchManager = {
  init: function() {
    $.widget("custom.navAutocomplete", $.ui.autocomplete, {
      _renderItem: function(ul, item) {
        return $("<li>").append(
          $("<a>").html("<span>" + item.label + "</span><br><em>" + item.value + "</em>")
        ).appendTo(ul);
      }
    });

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
