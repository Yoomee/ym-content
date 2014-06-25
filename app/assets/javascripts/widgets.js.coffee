# ui widgets

# custom autocomplete for navigation links
$.widget "custom.navAutocomplete", $.ui.autocomplete,
  _renderItem: (ul, item) ->
    $("<li>").append($("<a>").html("<span>" + item.label + "</span><br><em>" + item.value + "</em>")).appendTo(ul)
