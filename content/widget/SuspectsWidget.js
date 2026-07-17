define([
    "dojo/_base/declare",
    "dojo/_base/lang",
    "dojo/dom-class",
    "dojo/on",
    "dojo/request/xhr",
    "dijit/registry",
    "dijit/_WidgetBase",
    "dijit/_TemplatedMixin",
    "dijit/_WidgetsInTemplateMixin",
    "widget/Suspect1Widget",
    "widget/Suspect2Widget",
    "widget/Suspect3Widget",
    "dojo/text!./templates/SuspectsWidget.html"
], function(declare, lang, domClass, on, xhr, registry, _WidgetBase, _TemplatedMixin, _WidgetsInTemplateMixin, Suspect1Widget, Suspect2Widget, Suspect3Widget, template) {
    return declare([_WidgetBase, _TemplatedMixin, _WidgetsInTemplateMixin], {
        baseClass: "suspectsWidget",
        templateString: template,
        title: "",
        startup: function() {
            this.inherited(arguments);

            this.switchSuspects(1);

            xhr("API/v1/loginInfo", {
                handleAs: "json",
                preventCache: true,
                sync: true
            }).then(lang.hitch(this, function(data) {
                if (data && data.fragmentsResolved && Array.isArray(data.fragmentsResolved)) {
                    let introDone = false;

                    for (i = 0; i < data.fragmentsResolved.length && !introDone; i++) {
                        if (data.fragmentsResolved[i].fragment && data.fragmentsResolved[i].fragment == "INTRO")
                            introDone = true;
                    }

                    if (!introDone) {
                        location.href = "index.html";
                    }
                }
                if (data && data.nickname) {
                    this.spanNickname1.innerText = data.nickname;
                }
            }), lang.hitch(this, function(err) {
                console.log(err);
            }));

            on(this.chip1, "click", lang.hitch(this, function(event) {
                this.switchSuspects(1);
            }));

            on(this.chip2, "click", lang.hitch(this, function(event) {
                this.switchSuspects(2);
            }));

            on(this.chip3, "click", lang.hitch(this, function(event) {
                this.switchSuspects(3);
            }));
        },
        switchSuspects: function(chip) {
            if (chip == 1) {
                domClass.add(this.chip1, "selected");
                domClass.remove(this.fragmentSuspect1.domNode, "hidden");
            } else {
                domClass.remove(this.chip1, "selected");
                domClass.add(this.fragmentSuspect1.domNode, "hidden");
            }

            if (chip == 2) {
                domClass.add(this.chip2, "selected");
                domClass.remove(this.fragmentSuspect2.domNode, "hidden");
            } else {
                domClass.remove(this.chip2, "selected");
                domClass.add(this.fragmentSuspect2.domNode, "hidden");
            }

            if (chip == 3) {
                domClass.add(this.chip3, "selected");
                domClass.remove(this.fragmentSuspect3.domNode, "hidden");
            } else {
                domClass.remove(this.chip3, "selected");
                domClass.add(this.fragmentSuspect3.domNode, "hidden");
            }
        }
    });
});