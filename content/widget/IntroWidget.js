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
                let sqltext = this.inputSQL.value;

                sqltext = sqltext.replace("\n", " ");

                if (sqltext.trim().length > 0) {
                    let reqData = {
                        sqlquery: sqltext
                    };

                    reqData = JSON.stringify(reqData);

                    xhr.post("API/v1/sqlquery", {
                        handleAs: "json",
                        data: reqData,
                        preventCache: true,
                        sync: true
                    }).then(lang.hitch(this, function(data) {
                        if (data && data.sqlcode) {
                            this.sqlresult.innerText = "sqlcode " + data.sqlcode;
                            for (let i = 0; i < data.sqlResults.length; i++) {
                                this.sqlresult.innerText += "\n" + data.sqlResults[i].resultLine;
                            }
                        } else {
                            this.sqlresult.innerText = JSON.stringify(data);
                        }
                    }), lang.hitch(this, function(err) {
                        console.log(err);
                    }))
                }
            }));

            on(this.buttonFinalInput, "click", lang.hitch(this, function(event) {
                this.finalFeedback.innerText = "";

                let arrCheckboxes = this.listOfSuspects.getElementsByTagName("input");

                let postData = "";

                for (let i = 0; i < arrCheckboxes.length; i++) {
                    if (arrCheckboxes[i].checked) {
                        if (postData.length > 0) {
                            postData += "&"
                        }
                        postData += "checked_suspect=" + arrCheckboxes[i].value;
                    }
                }

                if (postData.length > 0) {
                    xhr.post("process_suspect_list.json", {
                        handleAs: "json",
                        data: postData,
                        preventCache: true,
                        sync: true
                    }).then(lang.hitch(this, function(data) {
                        if (data && data.correct && data.correct == "true") {
                            location.href = "suspects.html";
                        } else {
                            this.finalFeedback.innerText = "That is not correct";
                        }
                    }), lang.hitch(this, function(err) {
                        this.finalFeedback.innerText = err;
                    }));
                } else {
                    this.finalFeedback.innerText = "Select at least one";
                }
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
