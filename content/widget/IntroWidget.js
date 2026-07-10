define([
    "dojo/_base/declare",
    "dojo/_base/lang",
    "dojo/on",
    "dojo/request/xhr",
    "dijit/_WidgetBase",
    "dijit/_TemplatedMixin",
    "dijit/_WidgetsInTemplateMixin",
    "dojo/text!./templates/IntroWidget.html"
], function(declare, lang, on, xhr, _WidgetBase, _TemplatedMixin, _WidgetsInTemplateMixin, template) {
    return declare([_WidgetBase, _TemplatedMixin, _WidgetsInTemplateMixin], {
        baseClass: "introWidget",
        templateString: template,
        title: "",
        startup: function() {
            this.inherited(arguments);

            on(this.buttonExecuteSQL, "click", lang.hitch(this, function(event) {
                var reqData = {
                    sqlquery: this.inputSQL.value
                };

                reqData = JSON.stringify(reqData);
                
                console.log(reqData);

                xhr.post("API/v1/sqlquery", {
                    handleAs: "json",
                    data: reqData,
                    preventCache: true,
                    sync: true
                }).then(lang.hitch(this, function(data) {
                    console.log(data);
                }), lang.hitch(this, function(err) {
                    console.log(err);
                }))
            }));

            xhr("API/v1/loginInfo", {
                handleAs: "json",
                preventCache: true,
                sync: true
            }).then(lang.hitch(this, function(data) {
                if (data && data.nickname) {
                    this.spanNickname1.innerText = data.nickname;
                    this.spanNickname2.innerText = data.nickname;
                }
            }), lang.hitch(this, function(err) {
                console.log(err);
            }));
        }
    });
});
