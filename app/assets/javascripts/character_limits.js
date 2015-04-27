window.CharacterLimits = (function() {
  var counterText, input, inputChanged, length, limit, redactorChanged, registerRedactor, unit, updateCounter, updateWarning;
  input = null;
  length = function() {
    var text, words;
    if (unit() === "word") {
      text = input.hasClass("redactor-editor") ? input.prev('.redactor-editor').text() : input.val();
      words = text.trim().replace(/\s+/gi, ' ').split(' ');
      if (words[0] === "") {
        return 0;
      } else {
        return words.length;
      }
    } else {
      if (input.hasClass("redactor")) {
        return input.prev('.redactor-editor').text().length;
      } else {
        return input.val().length;
      }
    }
  };
  limit = function() {
    if (input.hasClass("redactor-editor")) {
      return input.siblings("[data-limit-quantity]").data("limit-quantity");
    } else {
      return input.data("limit-quantity");
    }
  };
  unit = function() {
    if (input.hasClass("redactor-editor")) {
      return input.siblings("[data-limit-unit]").data("limit-unit");
    } else {
      return input.data("limit-unit");
    }
  };
  updateCounter = function() {
    return input.siblings(".js-limit-quantity").text(counterText);
  };
  updateWarning = function() {
    return input.parents(".form-group").toggleClass('word-count-exceeded', length() > limit());
  };
  counterText = function() {
    return length() + "/" + limit();
  };
  redactorChanged = function(r) {
    return inputChanged(r.$element);
  };
  inputChanged = function(a) {
    input = $(a);
    updateCounter();
    return updateWarning();
  };
  registerRedactor = function(r) {
    var rInput, rOptions;
    rInput = r.$element;
    rInput.after($("<span/>").text("0/0").addClass("word-count js-limit-quantity"));
    return inputChanged(rInput);
  };
  $(function() {
    $("[data-limit-quantity]").each(function() {
      input = $(this);
      if (!input.hasClass('redactor')) {
        input.after($("<span/>").text(counterText).addClass("word-count js-limit-quantity"));
        return inputChanged(this);
      }
    });
    return $("[data-limit-quantity]").keyup(function() {
      return inputChanged(this);
    });
  });
  return {
    registerRedactor: registerRedactor,
    redactorChanged: redactorChanged
  };
})();
