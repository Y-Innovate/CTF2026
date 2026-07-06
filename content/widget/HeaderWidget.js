define([
    "dojo/_base/declare",
    "dojo/_base/lang",
    "dijit/_WidgetBase",
    "dijit/_TemplatedMixin",
    "dijit/_WidgetsInTemplateMixin",
    "dojo/text!./templates/HeaderWidget.html"
], function(declare, lang, _WidgetBase, _TemplatedMixin, _WidgetsInTemplateMixin, template) {
    return declare([_WidgetBase, _TemplatedMixin, _WidgetsInTemplateMixin], {
        baseClass: "headerWidget",
        templateString: template,
        title: "",
        bootLines: [
            {text:"> adding application to current plan...", cls:"amber"},
            {text:"> assigning service class to started task...", cls:"corrupt"},
            {text:"> scanning ISPF table...", cls:"amber"},
            {text:"> generating SVC dump, analyzing with IPCS...", cls:"corrupt"},
            {text:"> re-IPL not needed. good luck, detective.", cls:"amber"},
        ],
        lineIdx: 0,
        charIdx: 0,
        startup: function() {
            this.inherited(arguments);

            this.typeBoot();
        },
        typeBoot: function() {
            if (this.lineIdx >= this.bootLines.length) {
                this.bootText.innerHTML += '<span class="caret">&nbsp;</span>';
                return;
            }

            const current = this.bootLines[this.lineIdx];

            if (this.charIdx === 0) {
                this.bootText.innerHTML += '<span class="' + current.cls + '">';
            }

            if (this.charIdx < current.text.length) {
                const span = this.bootText.querySelectorAll('span.' + current.cls);
                span[span.length-1].textContent += current.text[this.charIdx];
                this.charIdx++;
                $this = this;
                setTimeout(function() { $this.typeBoot() }, 14 + Math.random()*18);
            } else {
                this.bootText.innerHTML += '</span>\n';
                this.lineIdx++; this.charIdx = 0;
                $this = this;
                setTimeout(function() { $this.typeBoot() }, 220);
            }
        }
    });
});
