/*
 * Call outs plugin.
 * To include in a project add 'callOuts' to config.redactor_plugins in config/initializers/ym_content.rb
 * Adpated from http://imperavi.com/redactor/plugins/clips/
 */

if (!RedactorPlugins) var RedactorPlugins = {};

RedactorPlugins.callOuts = function()
{
  return {
    init: function()
    {
      var items = [
        ['Information Callout', '<p class="call-out-box call-out-box-information"><span class="fa fa-info-circle"></span> Your text here</p>'],
        ['Contact Callout', '<p class="call-out-box call-out-box-contact"><span class="fa fa-comment"></span> Your text here</p>'],
        ['Date Callout', '<p class="call-out-box call-out-box-date"><span class="fa fa-calendar"></span> Your text here</p>'],
        ['Time Callout', '<p class="call-out-box call-out-box-time"><span class="fa fa-clock-o"></span> Your text here</p>']
      ];

      this.callOuts.template = $('<ul id="redactor-modal-list">');

      for (var i = 0; i < items.length; i++)
      {
        var li = $('<li>');
        var a = $('<a href="#" class="redactor-callouts-link">').text(items[i][0]);
        var div = $('<div class="redactor-callouts">').hide().html(items[i][1]);

        li.append(a);
        li.append(div);
        this.callOuts.template.append(li);
      }

      this.modal.addTemplate('callOuts', '<section>' + this.utils.getOuterHtml(this.callOuts.template) + '</section>');

      var button = this.button.add('callOuts', 'Call outs');
      this.button.setAwesome('callOuts', 'fa-bullhorn');
      this.button.addCallback(button, this.callOuts.show);

    },
    show: function()
    {
      this.modal.load('callOuts', 'Insert Callouts', 400);

      this.modal.createCancelButton();

      $('#redactor-modal-list').find('.redactor-callouts-link').each($.proxy(this.callOuts.load, this));

      this.selection.save();
      this.modal.show();
    },
    load: function(i,s)
    {
      $(s).on('click', $.proxy(function(e)
      {
        e.preventDefault();
        this.callOuts.insert($(s).next().html());

      }, this));
    },
    insert: function(html)
    {
      this.selection.restore();
      this.insert.html(html, false);
      this.modal.close();
      this.observe.load();
    }
  };
};

