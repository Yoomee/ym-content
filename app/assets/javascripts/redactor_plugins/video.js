/*
 * Video plugin.
 * To include in a project add 'video' to config.redactor_plugins in config/initializers/ym_content.rb
 * http://imperavi.com/redactor/plugins/video/ (modified to add wrapper div)
 */

if (!RedactorPlugins) var RedactorPlugins = {};

(function($)
{
  RedactorPlugins.video = function()
  {
    return {
      reUrlYoutube: /https?:\/\/(?:[0-9A-Z-]+\.)?(?:youtu\.be\/|youtube\.com\S*[^\w\-\s])([\w\-]{11})(?=[^\w\-]|$)(?![?=&+%\w.-]*(?:['"][^<>]*>|<\/a>))[?=&+%\w.-]*/ig,
      reUrlVimeo: /https?:\/\/(www\.)?vimeo.com\/(\d+)($|\/)/,
      getTemplate: function() {
        return String()
        + '<section id="redactor-modal-video-insert">'
          + '<label>Paste a YouTube or Vimeo link here.<br>(e.g. https://www.youtube.com/watch?v=8uDuls5TyNE)</label>'
          + '<textarea id="redactor-insert-video-area" style="height: 160px;"></textarea>'
        + '</section>';
      },
      init: function() {
        var button = this.button.addAfter('image', 'video', this.lang.get('video'));
        this.button.addCallback(button, this.video.show);
      },
      show: function()
      {
        this.modal.addTemplate('video', this.video.getTemplate());

        this.modal.load('video', this.lang.get('video'), 700);
        this.modal.createCancelButton();

        var button = this.modal.createActionButton(this.lang.get('insert'));
        button.on('click', this.video.insert);

        this.selection.save();
        this.modal.show();

        $('#redactor-insert-video-area').focus();

      },
      insert: function() {
        var data = $('#redactor-insert-video-area').val();

        if (!data.match(/<iframe|<video/gi))
        {
          data = this.clean.stripTags(data);

          var iframeStart = '<p class="responsive-video-wrapper"><iframe src="',
            iframeEnd = '" frameborder="0" allowfullscreen></iframe></p>';

          if (data.match(this.video.reUrlYoutube))
          {
            data = data.replace(this.video.reUrlYoutube, iframeStart + '//www.youtube.com/embed/$1' + iframeEnd);
          }
          else if (data.match(this.video.reUrlVimeo))
          {
            data = data.replace(this.video.reUrlVimeo, iframeStart + '//player.vimeo.com/video/$2' + iframeEnd);
          }
        }

        this.selection.restore();
        this.modal.close();

        var current = this.selection.getBlock() || this.selection.getCurrent();

        if (current) $(current).after(data);
        else
        {
          this.insert.html(data);
        }

        this.code.sync();
      },
      update: function() {
        // do not have responsive wrapper on paras without iframe
        $('p.responsive-video-wrapper').each(function () {
          if (!$(this).find('iframe').length) {
            $(this).removeClass('responsive-video-wrapper');
          }
        });
      }

    };
  };
})(jQuery);