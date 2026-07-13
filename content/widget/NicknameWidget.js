define([
    "dojo/_base/declare",
    "dojo/_base/lang",
    "dojo/on",
    "dojo/request/xhr",
    "dijit/_WidgetBase",
    "dijit/_TemplatedMixin",
    "dijit/_WidgetsInTemplateMixin",
    "dojo/text!./templates/NicknameWidget.html"
], function(declare, lang, on, xhr, _WidgetBase, _TemplatedMixin, _WidgetsInTemplateMixin, template) {
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
                    let reqData = {
                        userid: this.spanUserid.innerText,
                        nickname: this.inputNickname.value,
                        email: this.inputEmail.value
                    };
                    
                    reqData = JSON.stringify(reqData);
                    
                    xhr.post("API/v1/detectives", {
                        handleAs: "json",
                        data: reqData,
                        sync: true
                    }).then(lang.hitch(this, function (data) {
                        if (data && data.returnCode && data.returnCode == "00") {
                            location.reload();
                        } else {
                            if (data && data.returnCode) {
                                alert("API/v1/detectives gave retcode " + data.returnCode + " " + data.reasonCode + " " + data.infoMessage);
                            }
                            console.log(data);
                        }
                    }), function (err) {
                        console.log(err);
                    });
                }

                this.buttonTransmit.disabled = false;
            }));

            xhr("API/v1/loginInfo", {
                handleAs: "json",
                preventCache: true,
                sync: true
            }).then(lang.hitch(this, function(data) {
                if (data && data.userid) {
                    this.spanUserid.innerText = data.userid;
                }
            }), lang.hitch(this, function(err) {
                console.log(err);
            }));
        }
    });
});
