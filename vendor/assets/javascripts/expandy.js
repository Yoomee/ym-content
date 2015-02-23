if (!RedactorPlugins) var RedactorPlugins = {};

// RedactorPlugins.expandyHeader = function () {
//     return {
//         init: function () {
//             var button = this.button.add('expandyHeader', 'ExpandyHeader');

//             this.button.setAwesome('expandyHeader', 'fa-tasks');

//             this.button.addCallback(button, this.expandyHeader.insert);
//         },
//         insert: function () {
//             this.insert.htmlWithoutClean('<h2 data-expand="start">Hello world!</h2>');
//         }
//     };
// };

// RedactorPlugins.expandyEnd = function () {
//     return {
//         init: function () {
//             var button = this.button.add('expandyEnd', 'ExpandyEnd');

//             this.button.setAwesome('expandyEnd', 'fa-tasks');

//             this.button.addCallback(button, this.expandyEnd.insert);
//         },
//         insert: function () {

//             this.insert.htmlWithoutClean('<img src="/assets/redactor-expand-end.jpg" data-expand="end" class="redactor-plugin-helper" title="Expand End" alt="Expand End" />');

//         }
//     };
// };

RedactorPlugins.expandContent = function () {
    return {
        init: function () {
            var button = this.button.add('expandContent', 'ExpandContent');

            this.button.setAwesome('expandContent', 'fa-tasks');

            this.button.addCallback(button, this.expandContent.insert);
        },
        insert: function () {
            this.insert.htmlWithoutClean('<h2 data-expand="start" class="redactor-expand-heading">Expand Heading</h2><p>Your text here</p><img src="/assets/redactor-expand-end.jpg" data-expand="end" class="redactor-plugin-helper" title="Expand End" alt="Expand End" />');
        }
    };
};