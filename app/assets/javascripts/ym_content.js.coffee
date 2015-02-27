#= require jquery-migrate
#= require autogrow
#= require jquery-ui
#= require jquery-ui/datepicker
#= require jquery-ui-timepicker-addon
#= require jquery-ui/autocomplete
#= require jquery-ui/sortable
#= require bootstrap/tab
#= require bootstrap-colorpicker

#= require cocoon
#= require widgets
#= require navigation_manager
#= require custom
#= require character_limits
#= require tabs
#= require search_manager
#= require underscore
#= require sir-trevor
#= require redactor
#= require_tree ./sir_trevor_custom_blocks
#= require autocomplete-field
#= require select2

$(document).ready ->

  $('input,textarea,select').focusin ->
    $(this).parents('.form-group').addClass('focus')
  $('input,textarea,select').focusout ->
    $(this).parents('.form-group').removeClass('focus')

  $('.select2').select2
    tags: true,
    tokenSeparators: [',']

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
        changeCallback: (e) ->
          if CharacterLimits && this.$element.data('limit-quantity')
            CharacterLimits.redactorChanged(this)

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

window.YmAssets =
  addDefaults: (options, defaultOptions) ->
    if typeof(options) == 'object'
      $.extend(defaultOptions, options)
    else
      defaultOptions
  scrollTo: (elem, options) ->
    elem = $(elem)
    if elem.length
      options = YmAssets.addDefaults(options, {offset: 0, duration: 750})
      $('html, body').stop().animate
        scrollTop: (elem.position().top - options.offset)
      , options.duration
  Tabs:
    init: () ->
      # Activate tab from anchor
      if window.location.hash
        target_tab_link = $(".nav-tabs li a[href='#{window.location.hash}']").first()
        target_tab_link.tab('show') if target_tab_link.length
      # Highlight tabs with errors and activate first tab with errors
      $('.tab-pane').has('input.error, .control-group.error').each (idx,pane) =>
        link = $(".tabbable .nav a[href='##{$(pane).attr('id')}']")
        link.parent().addClass('error')
        link.tab('show') if idx is 0
  Bootstrap:
    init: () ->
      # $('a[data-toggle]').on 'click', event, ->
      #   event.preventDefault()
      $("[data-toggle='modal'][data-modal-url]").on 'click', ->
        $('.temp-modal').modal('hide')
        new_modal = $("<div class='modal temp-modal'></div>")
        if (`$(this)`.data('modal-id') != undefined)
          new_modal.attr('id', `$(this)`.data('modal-id'))
        new_modal.modal({backdrop: `$(this)`.data('backdrop')})
        new_modal.load(`$(this)`.data('modal-url'))
        new_modal.on 'hidden', () ->
          `$(this)`.remove()
  Forms:
    initColorPickers: () ->
      $('.colorpicker-control input').colorpicker().on 'changeColor', (colorpicker) ->
        colorDisplay = $(this).parents('.colorpicker-control').find('.add-on i')
        colorDisplay.css('background-color', colorpicker.color.toHex())
    initDatepickers: () ->
      $('input.datepicker').datepicker(
        dateFormat: 'dd/mm/yy'
      )
      $('input.datetime').datetimepicker(
        dateFormat: 'dd/mm/yy'
        timeFormat: 'hh:mm'
      )
      $('input.timepicker').timepicker({
        timeFormat: 'hh:mm',
        stepMinute: 5
      })
    LoadingText:
      add: (elem) ->
        submitBtns = elem.find("input[type='submit']")
        submitBtns.addClass('disabled')
        clickedBtn = elem.find("input[type='submit'][data-clicked='true']")
        if clickedBtn.length
          submitBtn = clickedBtn
        else
          if submitBtns.length > 1
            submitBtn = $((btn for btn in submitBtns when $(btn).data('primary') == true)[0])
          else
            submitBtn = $(submitBtns[0])
        if submitBtn?
          loadingText = (submitBtn.data("loading-text") || 'Saving...')
          submitBtn.attr('data-non-loading-text', submitBtn.val()).val(loadingText)
      remove: (elem) ->
          submitBtn = elem.find("input[type='submit']")
          submitBtn.removeClass('disabled').val(submitBtn.data('non-loading-text'))
      init: () ->
        $(".formtastic input[type='submit']").on "click", (event) ->
          $(this).attr('data-clicked',true)
        $(".formtastic:not('.loading-text-disabled')").on "submit", ->
          YmAssets.Forms.LoadingText.add($(this))
        unless typeof(ClientSideValidations) == 'undefined'
          ClientSideValidations.callbacks.form.fail = (element, message, callback) ->
            YmAssets.Forms.LoadingText.remove(element)
    init: () ->
      YmAssets.Forms.LoadingText.init()
      YmAssets.Forms.initDatepickers()
      YmAssets.Forms.initColorPickers()
      $('textarea:not(.redactor):not([data-dont-grow=true])').autogrow()

  Modals:
    initAutoModal: () ->
      $('#flash-modal').modal('show')
      if res = window.location.search.match(/modal=(\w+)/)
        if $("##{res[1]}").length
          $("##{res[1]}").modal('show')
          search_params = window.location.search.replace('?', '').split('&')
          search_params.splice($.inArray("modal=#{res[1]}", search_params), 1)
          if search_params.length > 0
            search_params = "?#{search_params.join('&')}"
          else
            search_params = ""
          new_href = "#{window.location.origin}#{window.location.pathname}#{search_params}"
          if history.pushState != undefined
            history.pushState
              path: this.path,
              '',
              new_href
  ReadMoreTruncate:
    init: () ->
      $('.read-more-link').on 'click', (event) ->
        event.preventDefault()
        wrapper = $(this).parents('.read-more-wrapper:first')
        wrapper.children('.read-more-trunc').hide()
        wrapper.children('.read-more-full').show()

  init: ->
    YmAssets.Tabs.init()
    YmAssets.Bootstrap.init()
    YmAssets.Forms.init()
    YmAssets.Modals.initAutoModal()
    YmAssets.ReadMoreTruncate.init()

$(document).ready ->
  YmAssets.init()
