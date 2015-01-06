window.CharacterLimits = (->
  input = null

  length = ->
    if unit() == "word"
      text = if input.hasClass("redactor_editor") then input.text() else input.val()
      words = text.trim().replace(/\s+/gi, ' ').split(' ')
      if words[0] == "" then 0 else words.length
    else
      if input.hasClass("redactor_editor") then input.text().length - 1 else input.val().length

  limit = ->
    if input.hasClass("redactor_editor") then input.siblings("[data-limit-quantity]").data("limit-quantity") else input.data("limit-quantity")

  unit = ->
    if input.hasClass("redactor_editor") then input.siblings("[data-limit-unit]").data("limit-unit") else input.data("limit-unit")

  updateCounter = ->
    input.siblings(".js-limit-quantity").text counterText

  updateWarning = ->
    input.parents(".form-group").toggleClass('word-count-exceeded', length() > limit())

  counterText = ->
    length() + "/" + limit()

  redactorChanged = ->
    inputChanged(this.$source.closest(".redactor_box").find('.redactor_editor'))

  inputChanged = (a) ->
    input = $(a)
    updateCounter()
    updateWarning()

  registerRedactor = (r) ->
    rInput = r.$source
    rOptions = r.opts
    rOptions.initCallback = null
    rOptions.changeCallback = redactorChanged
    r.destroy()
    rInput.redactor(rOptions)
    rInput.after $("<span/>").text("0/0").addClass("pull-right word-count js-limit-quantity label label-default")
    inputChanged rInput

  # jQuery Event bindings
  $ ->
    $("[data-limit-quantity]").each ->
      input = $(this)
      if !input.hasClass('redactor')
        input.after $("<span/>").text(counterText).addClass("pull-right word-count js-limit-quantity label label-default")
        inputChanged this

    $("[data-limit-quantity]").keyup ->
      inputChanged this


  # Reveal public pointers to
  # private functions and properties
  registerRedactor: registerRedactor
)()


