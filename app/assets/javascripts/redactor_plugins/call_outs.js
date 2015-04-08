/*
 * Call outs plugin.
 * To include in a project add 'callOuts' to config.redactor_plugins in config/initializers/ym_content.rb
 * Adpated from http://imperavi.com/redactor/plugins/clips/
 */

if (!RedactorPlugins) var RedactorPlugins = {};

RedactorPlugins.callOuts = function()
{
  return {
    init: function() {

      var items = [
        ['Information Callout', 'call-out-box-information', 'fa-info-circle'],
        ['Contact Callout', 'call-out-box-contact', 'fa-comment'],
        ['Date Callout', 'call-out-box-date', 'fa-calendar'],
        ['Time Callout', 'call-out-box-time', 'fa-clock-o']
      ];

      this.callOuts.template = $('<ul id="redactor-modal-list">');

      for (var i = 0; i < items.length; i++)
      {
        var li = $('<li>');
        var a = $('<a href="#" class="redactor-callouts-link" data-type="' + items[i][1] + '" data-icon-name="' + items[i][2] + '">').text(items[i][0]);

        li.append(a);
        this.callOuts.template.append(li);
      }

      this.modal.addTemplate('callOuts', '<section>' + this.utils.getOuterHtml(this.callOuts.template) + '</section>');

      var button = this.button.add('callOuts', 'Call outs');
      this.button.setAwesome('callOuts', 'fa-bullhorn');
      this.button.addCallback(button, this.callOuts.show);
    },
    show: function() {
      this.modal.load('callOuts', 'Insert Callouts', 400);

      this.modal.createCancelButton();

      $('#redactor-modal-list').find('.redactor-callouts-link').each($.proxy(this.callOuts.load, this));

      this.selection.save();
      this.modal.show();
    },
    load: function(i,s) {
      $(s).on('click', $.proxy(function(e) {
        e.preventDefault();

        var text = this.selection.getText();
        var msg = text.length ? text : 'Your text here';
        var icon = $(s).data('icon-name');
        var className = $(s).data('type');

        var html = '<p class="redactor-wrap-marker">[CALLOUT-START]</p>' +
        '<p class="call-out-box ' + className + '"><span class="fa ' + icon +'"></span> ' + msg + '</p>' +
        '<p class="redactor-wrap-marker">[CALLOUT-END]</p>';

        this.callOuts.insert(html);

      }, this));
    },
    insert: function(html) {
      this.selection.restore();
      this.insert.htmlWithoutClean(html, false);
      this.modal.close();
      this.observe.load();
    }
  };
};

