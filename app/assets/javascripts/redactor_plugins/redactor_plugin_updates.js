/*
 * Update redactor editor to wrap content as required for plugins
 * Called on redactor init and change
 */

window.redactorPluginUpdates = (function() {
  update = function(action) {

    wrapBlocks('.redactor-editor h2[data-expand="start"]', '.redactor-editor p:contains([EXPAND-END])', 'expanding-content', action);
    wrapBlocks('.redactor-editor p:contains([HIGHLIGHT-START])', '.redactor-editor p:contains([HIGHLIGHT-END])', 'highlight-block', action);

    $('.redactor-editor .highlight-block p.redactor-wrap-marker').removeClass('redactor-wrap-marker');

    $('.redactor-editor .redactor-wrap-marker').each(function () {
      var text = $(this).text();

      if (text.indexOf('HIGHLIGHT-START') === -1 && text.indexOf('HIGHLIGHT-END') === -1 && text.indexOf('EXPAND-END') === -1 && $(this).data('expand') !== 'start' ) {
        $(this).removeClass('redactor-wrap-marker');
      }
    });

    wrapDateBlocks();
  };

  function wrapBlocks(startEl, endEl, wrapperClass, action) {

    var $startEl = $(startEl);

    $startEl.each(function () {
      var $start = $(this);
      var className = $(this).data('class') ? ' ' + wrapperClass + '-' + $(this).data('class') : ''; // need this?
      var $end = $start.nextAll(endEl);

      if ($start.hasClass('redactor-primary')) {
        className += ' highlight-block-primary';
      }

      if ($start.hasClass('redactor-secondary')) {
        className += ' highlight-block-secondary';
      }

      if ($start.hasClass('redactor-tertiary')) {
        className += ' highlight-block-tertiary';
      }

      if (! $end.length) {
        return false;
      }

      if (action === 'change' && $start.hasClass('redactor-wrap-marker')) {
        return;
      }

      $start.addClass('redactor-wrap-marker');
      $end.addClass('redactor-wrap-marker');

      $start.nextUntil($end).wrapAll('<div class="' + wrapperClass + className + '"></div>');

    });
  }

  function wrapDateBlocks() {
    $('.dateblock-inner.dateblock-date').each(function () {
      if ($(this).parent('.dateblock').length) {
        return;
      }

      var div = $('<div class="dateblock" />').insertBefore($(this));
      var next = $(this).next('.dateblock-text');

      div.append($(this));
      div.append(next);
    });

  }

  return {
    update: update
  };
})();