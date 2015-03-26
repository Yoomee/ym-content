/*
 * Storify plugin.
 * To include in a project add 'storify' to config.redactor_plugins in config/initializers/ym_content.rb
 */

if (!RedactorPlugins) var RedactorPlugins = {};

(function($)
{
  RedactorPlugins.storify = function()
  {
    return {
      getTemplate: function()
      {
        return String()
        + '<section id="redactor-modal-storify-insert">'
          + '<p>'
          + '<label for="redactor-insert-storify">Paste a Storify link here*<br>(e.g. https://storify.com/Girlguiding/girlguiding-s-comic-relief-danceathon)</label>'
          + '<input id="redactor-insert-storify" type="text" />'
          + '</p>'
          + '<p>'
          + '<label for="redactor-insert-storify-height">Height (px)*</label>'
          + '<input id="redactor-insert-storify-height" type="number" value="750" />'
          + '</p>'
        + '</section>';
      },
      init: function() {
        var button = this.button.add('storify', 'Insert Storify');
        this.button.setAwesome('storify', 'fa-book');
        this.button.addCallback(button, this.storify.show);
      },
      show: function() {
        this.modal.addTemplate('storify', this.storify.getTemplate());

        this.modal.load('storify', 'Insert Storify', 600);
        this.modal.createCancelButton();

        var button = this.modal.createActionButton(this.lang.get('insert'));
        button.on('click', this.storify.insert);

        this.selection.save();
        this.modal.show();

        $('#redactor-insert-storify-area').focus();

      },
      insert: function() {
        var input = $('#redactor-insert-storify').val();
        var heightInput = $('#redactor-insert-storify-height').val();


        var src = input.replace(/https:/i, '');

        if (!src.match(/storify.com/) || !typeof height === 'number') {

          if ($('.redactor-modal-error').length) {
            return;
          }
          $('#redactor-modal-storify-insert').append('<p class="redactor-modal-error">Error - please add a Storify link and height</p>')
          return;
        }

        var iframe = '<div class="storify"><iframe src="' + src + '/embed?header=false&border=false" width="100%" height="' + heightInput + '" frameborder="no" allowtransparency="true"></iframe></div>';
        var script = '<script src="' + src + '.js?header=false&border=false"></script>';
        var noscript = '<noscript>[<a href="' + src + '" target="_blank">View on Storify</a>]</noscript>';
        var data = iframe + script + noscript;

        this.selection.restore();
        this.modal.close();

        var current = this.selection.getBlock() || this.selection.getCurrent();

        if (current) {
          $(current).after(data);
        } else {
          this.insert.html(data);
        }

        this.code.sync();
      }

    };
  };
})(jQuery);