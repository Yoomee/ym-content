window.NavigationManager =
  init: () ->
    $.widget "custom.navAutocomplete", $.ui.autocomplete,
      _renderItem: (ul, item) ->
        $("<li>").append($("<a>").html("<span>" + item.label + "</span><br><em>" + item.value + "</em>")).appendTo(ul)
    $("#navigation_item_link").navAutocomplete
      source: "/navigation_items/search"
      minlength: 2

    $("#navigation_item_link").on "click", ->
      this.select()

    $("#navigation_item_item_type").change ->
      if this.value == "dropdown"
        $("#navigation_item_link_input").hide()
      else
        $("#navigation_item_link_input").show()


