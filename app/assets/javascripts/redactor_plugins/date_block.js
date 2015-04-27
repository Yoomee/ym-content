/*
 * Date block plugin.
 * To include in a project add 'dateBlock' to config.redactor_plugins in config/initializers/ym_content.rb
 */

if (!RedactorPlugins) var RedactorPlugins = {};

RedactorPlugins.dateBlock = function() {
  return {
    getTemplate: function () {
      return String()
        + '<section id="redactor-modal-dateblock-insert">'
          + '<p>'
          + '<label for="redactor-dateblock-day">Day (number)*</label>'
          + '<input id="redactor-dateblock-day" type="text" />'
          + '</p>'
          + '<p>'
          + '<label for="redactor-dateblock-month">Month (e.g. JAN)*</label>'
          + '<input id="redactor-dateblock-month" type="text" />'
          + '</p>'
          + '<p>'
          + '<label for="redactor-dateblock-year">Year*</label>'
          + '<input id="redactor-dateblock-year" type="text" />'
          + '</p>'
          + '<p>'
          + '<label for="redactor-dateblock-text">Text*</label>'
          + '<textarea id="redactor-dateblock-text"></textarea>'
          + '</p>'
        + '</section>';
    },
    init: function() {

      this.modal.addTemplate('dateBlock', this.dateBlock.getTemplate());

      var button = this.button.add('dateBlock', 'Date Block');
      this.button.setAwesome('dateBlock', 'fa-calendar');
      this.button.addCallback(button, this.dateBlock.show);
    },
    show: function () {

      this.modal.load('dateBlock', 'Insert Date Block', 400);
      this.modal.createCancelButton();

      var actionBtn = this.modal.createActionButton(this.lang.get('insert'));
      actionBtn.on('click', this.dateBlock.insert);

      this.selection.save();
      this.modal.show();
    },
    insert: function () {
      var text = $('#redactor-dateblock-text').val().replace( /\n/g, '<br>' );
      var day = $('#redactor-dateblock-day').val();
      var month = $('#redactor-dateblock-month').val();
      var year = $('#redactor-dateblock-year').val();
      var dayClass = day.length > 2 ? ' dateblock-day-range' : '';

      if (text === '' || day === '' || month === '' || year === '') {
        if($('.redactor-modal-error').length) {
          return;
        }
        $('#redactor-dateblock-day').parent('p').before('<p class="redactor-modal-error">Error - please complete all the fields</p>');
        return;
      }

      var date = '<span class="dateblock-day' + dayClass + '">' + day + '</span><span class="dateblock-month">' + month + '</span><span class="dateblock-year">' + year + '</span>';
      var html = '<p class="redactor-wrap-marker">[DATEBLOCK-START]</p><div class="dateblock"><p class="dateblock-inner dateblock-date">' + date + '</p><p class="dateblock-inner dateblock-text">' + text + '</p></div><p class="redactor-wrap-marker">[DATEBLOCK-END]</p>';

      this.selection.restore();
      this.modal.close();
      this.insert.htmlWithoutClean(html);
    },
    update: function () {
      // Update html formatting so not lost on init / change
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
  };
};