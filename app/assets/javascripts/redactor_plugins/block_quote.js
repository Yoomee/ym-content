/*
 * Fancy blockquotes plugin.
 * To include in a project add 'blockQuote' to config.redactor_plugins in config/initializers/ym_content.rb
 */

if (!RedactorPlugins) var RedactorPlugins = {};

RedactorPlugins.blockQuote = function() {
  return {
    getTemplate: function () {
      return String()
        + '<section id="redactor-modal-blockquote-insert">'
          + '<p>'
          + '<label for="redactor-blockquote-quote">Quote*</label>'
          + '<textarea id="redactor-blockquote-quote"></textarea>'
          + '</p>'
          + '<p>'
          + '<label for="redactor-blockquote-citation">Citation</label>'
          + '<input id="redactor-blockquote-citation" type="text" />'
          + '</p>'
        + '</section>';
    },
    init: function() {

      this.modal.addTemplate('blockQuote', this.blockQuote.getTemplate());

      var button = this.button.add('blockQuote', 'Block Quote');
      this.button.setAwesome('blockQuote', 'fa-quote-left');
      this.button.addCallback(button, this.blockQuote.show);

    },
    show: function () {

      this.modal.load('blockQuote', 'Insert Block Quote', 400);
      this.modal.createCancelButton();

      var actionBtn = this.modal.createActionButton(this.lang.get('insert'));
      actionBtn.on('click', this.blockQuote.insert);

      this.selection.save();
      this.modal.show();

      var text = this.selection.getText() !== '' ? this.selection.getText() : '';
      $('#redactor-blockquote-quote').val(text);

      $('#redactor-blockquote-quote').focus();
    },
    insert: function () {
      var quote = $('#redactor-blockquote-quote').val();
      var citation = $('#redactor-blockquote-citation').val();

      if (quote === '') {
        $('#redactor-blockquote-quote').parent('p').before('<p class="redactor-modal-error">Error - please give a quote</p>');
        return;
      }

      if (citation !== '') {
        citation = '<cite>- ' + citation + '</cite>';
      }

      var html = '<p class="redactor-wrap-marker">[QUOTE-START]</p><blockquote class="blockquote-fancy"><p>' + quote + '</p>' + citation + '</blockquote><p class="redactor-wrap-marker">[QUOTE-END]</p>';

      this.selection.restore();
      this.modal.close();
      this.insert.htmlWithoutClean(html);
      this.blockQuote.update;
    },
    update: function() {
      $('.blockquote-fancy').each(function () {
        var $this = $(this);
        var quoteContent = $this.text();
        var citeText = $this.find('cite').text();
        var quoteText = citeText.length ? quoteContent.substring( 0, quoteContent.indexOf(citeText)) : quoteContent;
        var citation = citeText.length ? '<cite>' + citeText + '</cite>' : '';

        $this.html('<p>' + quoteText + '</p>' + citation);
      });
    }
  };

};
