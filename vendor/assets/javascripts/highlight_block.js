if (!RedactorPlugins) var RedactorPlugins = {};

// RedactorPlugins.highlightBlockStart = function () {
//     return {
//         init: function () {
//             var button = this.button.add('highlightBlockStart', 'Highlight BlockStart');

//             this.button.setAwesome('highlightBlockStart', 'fa-exclamation');

//             this.button.addCallback(button, this.highlightBlockStart.insert);
//         },
//         insert: function () {
//             this.insert.htmlWithoutClean('<img src="/assets/redactor-highlight-start.jpg" data-highlight="start" class="redactor-plugin-helper" title="Highlight Start" alt="Highlight Start" />');
//         }
//     };
// };

// RedactorPlugins.highlightBlockEnd = function () {
//     return {
//         init: function () {
//             var button = this.button.add('highlightBlockEnd', 'Highlight Block End');

//             this.button.setAwesome('highlightBlockEnd', 'fa-exclamation');

//             this.button.addCallback(button, this.highlightBlockEnd.insert);
//         },
//         insert: function () {
//             this.insert.htmlWithoutClean('<img src="/assets/redactor-highlight-end.jpg" data-highlight="end" class="redactor-plugin-helper" title="Highlight End" alt="Highlight End" />');
//         }
//     };
// };

RedactorPlugins.highlightBlock = function () {
    return {
        init: function () {
            var button = this.button.add('highlightBlock', 'Highlight Block ');

            this.button.setAwesome('highlightBlock', 'fa-exclamation');

            this.button.addCallback(button, this.highlightBlock.insert);
        },
        insert: function () {
            this.insert.htmlWithoutClean('<img src="/assets/redactor-highlight-start.jpg" data-highlight="start" class="redactor-plugin-helper" title="Highlight Start" alt="Highlight Start" /><p>Your text here</p><img src="/assets/redactor-highlight-end.jpg" data-highlight="end" class="redactor-plugin-helper" title="Highlight End" alt="Highlight End" />');
        }
    };
};

