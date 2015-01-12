window.Tabs = (->

  $tabs = null

  toggleButtons = (e) ->
    $('.js-tab-previous').toggle !$(e.target).parent().is(':first-child')
    $('.js-tab-next').toggle !$(e.target).parent().is(':last-child')

  init = ->
    $tabs = $('.cms-tabs li')

  $ ->
    $('.js-tab-next').click (e) ->
      e.preventDefault()
      $tabs.filter('.active').next('li').find('a[data-toggle="tab"]').tab('show');

    $('.js-tab-previous').click (e) ->
      e.preventDefault()
      $tabs.filter('.active').prev('li').find('a[data-toggle="tab"]').tab('show');

    # Hide relevant buttons on first and last tabs
    $('a[data-toggle="tab"]').on 'show.bs.tab', (e) ->
      toggleButtons(e)

    init()

)()
