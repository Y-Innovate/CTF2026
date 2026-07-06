define([
    "dojo/_base/declare",
    "dojo/_base/lang",
    "dojo/on",
    "dijit/_WidgetBase",
    "dijit/_TemplatedMixin",
    "dijit/_WidgetsInTemplateMixin",
    "dojo/text!./templates/NicknameWidget.html"
], function(declare, lang, on, _WidgetBase, _TemplatedMixin, _WidgetsInTemplateMixin, template) {
    return declare([_WidgetBase, _TemplatedMixin, _WidgetsInTemplateMixin], {
        baseClass: "nicknameWidget",
        templateString: template,
        title: "",
        startup: function() {
            this.inherited(arguments);

            on(this.buttonTransmit, "click", lang.hitch(this, function(event) {
                this.buttonTransmit.disabled = true;

                this.feedback1.innerText = "";

                if (this.inputNickname.value == "") {
                    this.feedback1.innerText = "Nickname is mandatory";
                } else {
                    console.log("REST call goes here");
                }

                this.buttonTransmit.disabled = false;
            }));
        }
    });
});
