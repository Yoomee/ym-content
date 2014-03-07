window.YmContent =
  Sitemap:
    init: ->
      YmContent.Sitemap.filter()
      $('select#status').change ->
        YmContent.Sitemap.filter()
      $('#site-map').on 'click', '.has-children td.td-name', ->
        link = $(this)
        row = link.parent()
        if $(this).data('open') == 1
          link.data('open', 0)
          link.find('i.sitemap-caret').removeClass('fa-caret-down').addClass('fa-caret-right')
          depth = row.data('depth')
          loop
            row = row.next()
            if row.data('depth') > depth
              row.hide()
              link = row.find('td.td-name')
              link.data('open',0)
              link.find('i.sitemap-caret').removeClass('fa-caret-down').addClass('fa-caret-right')
            else
              break
        else if $(this).data('loaded') == 1
          link.data('open', 1)
          link.find('i.sitemap-caret').removeClass('fa-caret-right').addClass('fa-caret-down')
          depth = row.data('depth')
          loop
            row = row.next()
            if row.data('depth') == (depth + 1)
              row.show()
            else if row.data('depth') == depth
              break
        else
          content_package_id = row.attr('id').split('-').slice(-1)[0]
          link.data('loaded',0)
          setTimeout("YmContent.Sitemap.loading(#{content_package_id})", 250)
          $.get("/content_packages/#{content_package_id }/children").success ->
            link.data('loaded',1)
            link.data('open',1)
            link.find('i.sitemap-caret').removeClass('fa-spin').removeClass('fa-spinner').removeClass('fa-caret-right')
            link.find('i.sitemap-caret').addClass('fa-caret-down')
    filter: ->
      status = $('select#status').val()
      if status.length > 0
        $("#site-map tr.content-package").hide()
        $("#site-map tr.status-#{status}").show()
      else
        $("#site-map tr.content-package").show()
    loading:(id) ->
      link = $("#content-package-#{id} td.td-name")
      if link.data('loaded') == 0
        link.find('i.sitemap-caret').removeClass('fa-caret-right').addClass('fa-spinner').addClass('fa-spin')
      