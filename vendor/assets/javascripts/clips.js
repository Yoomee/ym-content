// Adpated from http://imperavi.com/redactor/plugins/clips/

if (!RedactorPlugins) var RedactorPlugins = {};

RedactorPlugins.clips = function()
{
	return {
		init: function()
		{
			var items = [
				['Info Block', '<p class="call-out-box information-box"><span class="fa fa-info-circle"></span> Your text here</p>'],
				['Contact Block', '<p class="call-out-box contact-box"><span class="fa fa-comment"></span> Your text here</p>'],
				['Date Block', '<p class="call-out-box date-box"><span class="fa fa-calendar"></span> Your text here</p>'],
				['Time Block', '<p class="call-out-box date-box"><span class="fa fa-clock-o"></span> Your text here</p>'],
			];

			this.clips.template = $('<ul id="redactor-modal-list">');

			for (var i = 0; i < items.length; i++)
			{
				var li = $('<li>');
				var a = $('<a href="#" class="redactor-clip-link">').text(items[i][0]);
				var div = $('<div class="redactor-clip">').hide().html(items[i][1]);
				// console.log(div)
				li.append(a);
				li.append(div);
				this.clips.template.append(li);
			}

			this.modal.addTemplate('clips', '<section>' + this.utils.getOuterHtml(this.clips.template) + '</section>');

			var button = this.button.add('clips', 'Call outs');
			this.button.addCallback(button, this.clips.show);

		},
		show: function()
		{
			this.modal.load('clips', 'Insert Callouts', 400);

			this.modal.createCancelButton();

			$('#redactor-modal-list').find('.redactor-clip-link').each($.proxy(this.clips.load, this));

			this.selection.save();
			this.modal.show();
		},
		load: function(i,s)
		{
			$(s).on('click', $.proxy(function(e)
			{
				e.preventDefault();
				this.clips.insert($(s).next().html());

			}, this));
		},
		insert: function(html)
		{
			console.log(html)
			this.selection.restore();
			this.insert.html(html, false); //don't clean html
			this.modal.close();

			this.observe.load();
		}
	};
};

