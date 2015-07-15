/*
 * Update redactor editor to wrap content as required for plugins
 * Called on redactor init and change
 */

window.redactorPluginUpdates = (function() {
  update = function(action) {

    wrapBlocks('.redactor-editor h2[data-expand="start"]', '.redactor-editor p:contains([EXPAND-END])', 'expanding-content', action);
    wrapBlocks('.redactor-editor p:contains([DOC-START])', '.redactor-editor p:contains([DOC-END])', 'document-block', action);
    updateMarkers();
    RedactorPlugins.dateBlock().update();
    RedactorPlugins.video().update();

    if (action !== 'change'){
      RedactorPlugins.blockQuote().update();
      this.formatHighlightBlocks(action);
    }
  },
  formatHighlightBlocks = function(action) {
    wrapBlocks('.redactor-editor p:contains([HIGHLIGHT-START])', '.redactor-editor p:contains([HIGHLIGHT-END])', 'highlight-block', action);
  };

  function updateMarkers() {
    // Ensure markers have class and non-markers have not
    $('.redactor-editor p').each(function () {
      if (checkMarkers($(this))) {
        $(this).addClass('redactor-wrap-marker');
        if($(this).find('span').length) {
          return;
        }
        $(this).wrapInner('<span></span>')
        return;
      }
      $(this).removeClass('redactor-wrap-marker');
    });

  }

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

  function checkMarkers(el) {
    var str = el.text();
    var markers = ['[HIGHLIGHT-START]', '[HIGHLIGHT-END]', '[EXPAND-START]', '[EXPAND-END]', '[CALLOUT-START]', '[CALLOUT-END]', '[QUOTE-START]', '[QUOTE-END]', '[DATEBLOCK-START]', '[DATEBLOCK-END]', '[DOC-START]', '[DOC-END]'];
    var markersLength = markers.length;
    var isMarker = false;

    for(var i = 0; i < markersLength; i++) {
      if(str.indexOf(markers[i]) !== -1 || el.data('expand') === 'start' ) {
        isMarker = true;
      }
    }

    return isMarker;
  }

  return {
    update: update,
    formatHighlightBlocks: formatHighlightBlocks
  };
})();