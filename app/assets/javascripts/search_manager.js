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

    $("#content_search_link").navAutocomplete({
      source: "/navigation_items/search",
      minlength: 2,
      select: function(event, ui) {
        console.log('select pressed')
      }
    });

    $("#content_search_link").on("click", function() {
      return this.select();
    });
  }
};
