/*
 * Document Block plugin.
 * To include in a project add 'documentsBlock' to config.redactor_plugins in config/initializers/ym_content.rb
 */

if (!RedactorPlugins) var RedactorPlugins = {};

RedactorPlugins.documentsBlock = function() {
  return {
    getTemplate: function () {
      return String()
        + '<section id="redactor-modal-documentsblock-insert">'
          + '<p>'
          + '<label for="redactor-documentsblock-title">Title</label>'
          + '<input id="redactor-documentsblock-title" type="text" />'
          + '</p>'
          + '<p>'
          + '<label for="redactor-documentsblock-desc">Description</label>'
          + '<input id="redactor-documentsblock-desc" type="text" />'
          + '</p>'
          + '<p>Add links to the pdf, word, epub, and mobi files below:</p>'
          + '<p>'
          + '<label for="redactor-documentsblock-pdf">PDF link</label>'
          + '<input id="redactor-documentsblock-pdf" type="text" />'
          + '</p>'
          + '<p>'
          + '<label for="redactor-documentsblock-word">Word link</label>'
          + '<input id="redactor-documentsblock-word" type="text" />'
          + '</p>'
          + '<p>'
          + '<label for="redactor-documentsblock-epub">ePub link</label>'
          + '<input id="redactor-documentsblock-epub" type="text" />'
          + '</p>'
          + '<p>'
          + '<label for="redactor-documentsblock-mobi">Mobi link</label>'
          + '<input id="redactor-documentsblock-mobi" type="text" />'
          + '</p>'
        + '</section>';
    },
    init: function() {
      this.modal.addTemplate('documentsBlock', this.documentsBlock.getTemplate());
      var button = this.button.add('documentsBlock', 'Documents Block');
      this.button.setAwesome('documentsBlock', 'fa-file-o');
      this.button.addCallback(button, this.documentsBlock.show);
    },
    show: function () {
      this.modal.load('documentsBlock', 'Insert Document', 600);
      this.modal.createCancelButton();
      var actionBtn = this.modal.createActionButton(this.lang.get('insert'));
      actionBtn.on('click', this.documentsBlock.insert);
      this.selection.save();
      this.modal.show();
    },
    insert: function () {
      var title = $('#redactor-documentsblock-title').val();
      var desc = $('#redactor-documentsblock-desc').val();
      var pdf = $('#redactor-documentsblock-pdf').val();
      var word = $('#redactor-documentsblock-word').val();
      var epub = $('#redactor-documentsblock-epub').val();
      var mobi = $('#redactor-documentsblock-mobi').val();

      $('.readactor-modal-error').remove();
      var errorMsg = '';
      var errors = false;

      if (title === '') {
        errors = true;
        errorMsg += '<br>Title required.';
      }

      if (pdf === '' && word === '' && epub === '' && mobi === '') {
        errors = true;
        errorMsg += '<br>File link required.'
      }

      if (pdf !== '' && !validateLink(pdf, 'pdf')) {
        errorMsg += '<br>Invalid file type - file should be a PDF.';
        errors = true;
      }

      if (word !== '' && !validateLink(word, 'doc')) {
        errorMsg += '<br>Invalid file type - file should be a Word doc.';
        errors = true;
      }

      if (epub !== '' && !validateLink(epub, 'epub')) {
        errorMsg += '<br>Invalid file type - file should be a ePub.';
        errors = true;
      }

      if (mobi !== '' && !validateLink(mobi, 'mobi')) {
        errorMsg += '<br>Invalid file type - file should be a Mobi.';
        errors = true;
      }

      if (errors) {
        $('#redactor-modal-documentsblock-insert').prepend('<p class="readactor-modal-error">Error:>' + errorMsg +'</p>');
        return;
      }

      var startTag = '[DOC-START]';
      var endTag = '[DOC-END]';
      var titleHtml = '<h3>' + title + '</h3>';
      var descHtml = desc !== '' ? '<p>' + desc + '</p>' : '';
      var pdfHtml = pdf !== '' ? '<li><a href="' + pdf + '">Download ' + title + ' as PDF</a></li>' : '';
      var wordHtml = word !== '' ? '<li><a href="' + word + '">Download ' + title + ' as Word</a></li>' : '';
      var epubHtml = epub !== '' ? '<li><a href="' + epub + '">Download ' + title + ' as ePub</a></li>' : '';
      var mobiHtml = mobi !== '' ? '<li><a href="' + mobi + '">Download ' + title + ' as Mobi</a></li>' : '';

      var html = startTag + titleHtml + descHtml + '<ul>' + pdfHtml + wordHtml + epubHtml + mobiHtml + '</ul>' + endTag;

      this.selection.restore();
      this.modal.close();
      this.insert.htmlWithoutClean(html);
    }
  };

  function validateLink(link, type) {
    var array = link.split('.');
    var linkType = array[array.length -1];

    if (linkType == type) {
      return true;
    }
  }

};
