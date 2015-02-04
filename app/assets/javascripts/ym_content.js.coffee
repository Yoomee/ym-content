#= require widgets
#= require navigation_manager
#= require custom
#= require character_limits
#= require tabs
#= require search_manager
#= require eventable
#= require underscore
#= require sir-trevor
#= require redactor
#= require_tree ./sir_trevor_custom_blocks

$(document).ready ->

  $('input,textarea,select').focusin ->
    $(this).parents('.form-group').addClass('focus')
  $('input,textarea,select').focusout ->
    $(this).parents('.form-group').removeClass('focus')

  # Set quick find menu width to be size of container
  $.ui.autocomplete::_resizeMenu = ->
    ul = @menu.element
    ul.outerWidth @element.outerWidth()
    return

window.YmContent =
  ContentPackages:
    initForm: ->
      $('#content_package_content_type_id').change ->
        YmContent.ContentPackages.updateGoal()
      $('#content_package_notes').change ->
        YmContent.ContentPackages.goalChangedByUser = true
      YmContent.ContentPackages.updateGoal()
    updateGoal: ->
      unless YmContent.ContentPackages.goalChangedByUser
        goal = YmContent.ContentPackages.descriptions[$('#content_package_content_type_id').val()]
        $('#content_package_notes').val(goal)
    goalChangedByUser: false
  ContentTypes:
    init: ->
      $('.sitemap').on 'click', 'td.td-name', ->
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
            if row.data('depth')?
              if row.data('depth') == (depth + 1)
                row.show()
              else if row.data('depth') == depth
                break
             else
               break
        else
          content_type_id = row.attr('id').split('-').slice(-1)[0]
          link.data('loaded',0)
          setTimeout("YmContent.ContentTypes.loading(#{content_type_id })", 250)
          $.get("/content_types/#{content_type_id}/children").success ->
            link.data('loaded',1)
            link.data('open',1)
            link.find('i.sitemap-caret').removeClass('fa-spin').removeClass('fa-spinner').removeClass('fa-caret-right')
            link.find('i.sitemap-caret').addClass('fa-caret-down')
      $('.js-duplicate-link').on 'click', ->
        YmContent.ContentTypes.seedId = $(this).data('content-type-id')
        $('#duplicate-modal').modal()
      $('.js-duplicate-submit').on 'click', ->
        path = "/content_types/#{YmContent.ContentTypes.seedId}/duplicate"
        duplicateTo = $('#duplicate_to').val()
        if duplicateTo != ""
          path += "?to=#{duplicateTo}"
        window.location = path
    loading:(id) ->
      link = $("#content-type-#{id} td.td-name")
      if link.data('loaded') == 0
        link.find('i.sitemap-caret').removeClass('fa-caret-right').addClass('fa-spinner').addClass('fa-spin')
  Redactor:
    init: ->
      $('.redactor textarea').redactor
        removeClasses: true,
        removeStyles: true,
        buttons: [ 'unorderedlist', 'orderedlist', 'link', 'html' ],
        convertDivs: true,
        path:'vendor/assets/javascripts/redactor',
        focusCallback: (e) ->
          $(e.currentTarget).parents(".form-group").addClass("focus")
        blurCallback: (e) ->
          $(e.currentTarget).parents(".form-group").removeClass("focus")
        initCallback: (e) ->
          if CharacterLimits && this.$element.data('limit-quantity')
            CharacterLimits.registerRedactor(this)

  Sitemap:
    init: ->
      YmContent.Sitemap.filter()
      $('select#status').change ->
        YmContent.Sitemap.filter()
      $('#sitemap').on 'click', '.has-children td.td-name', ->
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
            if row.data('depth')?
              if row.data('depth') == (depth + 1)
                row.show()
              else if row.data('depth') == depth
                break
             else
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
        $('h1').text("Content list - #{$('select#status option:selected').text()}")
        $("#sitemap tr.content-package").hide()
        $("#sitemap tr.status-#{status}").show()
      else
        $('h1').text('Content list')
        $("#sitemap tr.content-package").show()
    loading:(id) ->
      link = $("#content-package-#{id} td.td-name")
      if link.data('loaded') == 0
        link.find('i.sitemap-caret').removeClass('fa-caret-right').addClass('fa-spinner').addClass('fa-spin')
  Sortable:
    init: ->
      $('.sortable').sortable
        placeholder: 'well well-placeholder'
        containment: 'parent'
      $('a.sortable-submit').click (event) ->
        url = $(this).attr('href') + '?'
        url += $('.sortable').sortable("serialize")
        $(this).attr('href', url)
