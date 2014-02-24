window.YmContent =
  Sitemap:
    init: ->
      YmContent.Sitemap.filter()
      $('select#status').change ->
        YmContent.Sitemap.filter()
    filter: ->
      status = $('select#status').val()
      if status.length > 0
        $("#site-map tr.content-package").hide()
        $("#site-map tr.status-#{status}").show()
      else
        $("#site-map tr.content-package").show()
      