SirTrevor.Blocks.Alert = SirTrevor.Block.extend({

  type: "alert",

  title: function() { return 'Alert'; },

  editorHTML: '<div class="st-required st-text-block" style="text-align: left; font-size: 0.75em;" contenteditable="true"></div>',

  icon_name: 'text',

  loadData: function(data){
    this.getTextBlock().html(SirTrevor.toHTML(data.text, this.type));
  }
});