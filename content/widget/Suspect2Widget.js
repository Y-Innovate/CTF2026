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
    "dojo/text!./templates/Suspect2Widget.html"
], function(declare, lang, domClass, on, xhr, registry, _WidgetBase, _TemplatedMixin, _WidgetsInTemplateMixin, template) {
    return declare([_WidgetBase, _TemplatedMixin, _WidgetsInTemplateMixin], {
        baseClass: "suspect2Widget",
        templateString: template,
        title: "",
        startup: function() {
            this.inherited(arguments);

            this.buttonSkip2.style.display = "none";

            on(this.buttonHint2, "click", lang.hitch(this, function(event) {
                xhr("API/v1/hints?hintCode=SUSPECT2", {
                    handleAs: "json",
                    preventCache: true,
                    sync: true
                }).then(lang.hitch(this, function(data) {
                    if (data && data.hintText) {
                        this.hint2.innerText = data.hintText;
                        domClass.add(this.hint2, "open");
                    }
                }), lang.hitch(this, function(err) {
                    console.log(err);
                }));
            }));

            on(this.buttonFetchTSQ2, "click", lang.hitch(this, function(event) {
                const tsqName = this.inputWork2.value;

                xhr("API/v1/tsqueues?tsqName=" + tsqName, {
                    handleAs: "json",
                    preventCache: true,
                    sync: true
                }).then(lang.hitch(this, function(data) {
                    if (data && data.tsqContent) {
                        let result = '';

                        result = data.tsqContent.substring(0, 80).trimEnd();
                        for (i = 1; i < (data.tsqContent.length + 79) / 80; i++) {
                            result += "\n" + data.tsqContent.substring(i * 80, (i + 1) * 80).trimEnd();
                        }
                
                        this.feedback2.innerText = result;
                    }
                }), lang.hitch(this, function(err) {
                    console.log(err);
                }));
            }));

            on(this.buttonFinalInput2, "click", lang.hitch(this, function(event) {
                this.finalFeedback2.innerText = "";

                let answer2 = this.inputAnswer2.value;

                if (answer2.length > 0) {
                    let postData = "answer_suspect_2=" + encodeURIComponent(answer2);

                    xhr.post("process_suspect_answer.json", {
                        handleAs: "json",
                        data: postData,
                        preventCache: true,
                        sync: true
                    }).then(lang.hitch(this, function(data) {
                        if (data && data.correct && data.correct == "true") {
                            this.fragmentResolved();
                        } else {
                            this.finalFeedback2.innerText = "That is not correct";
                        }
                    }), lang.hitch(this, function(err) {
                        this.finalFeedback2.innerText = err;
                    }));
                } else {
                    this.finalFeedback2.innerText = "Give a non blank value";
                }
            }));

            on(this.buttonSkip2, "click", function(event) {
                let parent = registry.byId("suspects");
                parent.switchSuspects(3);
            });

            xhr("API/v1/loginInfo", {
                handleAs: "json",
                preventCache: true,
                sync: true
            }).then(lang.hitch(this, function(data) {
                if (data && data.fragmentsResolved && Array.isArray(data.fragmentsResolved)) {
                    let suspect2Done = false;

                    for (i = 0; i < data.fragmentsResolved.length && !suspect2Done; i++) {
                        if (data.fragmentsResolved[i].fragment && data.fragmentsResolved[i].fragment == "SUSPECT2" && data.fragmentsResolved[i].positiveOrNegative == "P")
                            suspect2Done = true;
                    }

                    if (suspect2Done) {
                        this.fragmentResolved();
                    }
                }
            }), lang.hitch(this, function(err) {
                console.log(err);
            }));
        },
        fragmentResolved: function() {
            this.status2.innerText = "RESOLVED";
            this.buttonSkip2.style.display = "inline";
            domClass.add(this.domNode, "solved");
        }
    });
});