/*
 * Remove Open link in new tab option
 */

if (!RedactorPlugins) var RedactorPlugins = {};

(function($) {
  RedactorPlugins.linksSameTabOnly = function() {
    return {
      init: function() {
        this.modal.addCallback('link', $.proxy(this.linksSameTabOnly.load, this));
      },
      load: function() {
        $('#redactor-link-blank').parent('label').remove();
      }
    };
  };
})(jQuery);