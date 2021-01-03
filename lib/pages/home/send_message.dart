import 'package:flutter/material.dart';
import 'package:waap/STYLES.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:waap/components/SafeScroll.dart';
import 'package:waap/components/WaapButton.dart';

import 'package:waap/services/api.dart';


class SendMessagePage extends StatefulWidget {
  SendMessagePage(this.mode);

  int mode;

  static const int PROPOSAL = 0;
  static const int PROBLEM = 1;

  static Map _MODES = {PROPOSAL: "proposal".tr(), PROBLEM: "problem".tr()};

  @override
  _SendMessagePageState createState() => _SendMessagePageState();
}

class _SendMessagePageState extends State<SendMessagePage> {
  String message = "";

  TextEditingController mcontroller;

  String error = "";

  BuildContext mycontext;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    mcontroller = TextEditingController(text: "");
  }

  validate() async {
    Map data = mcontroller.text?.length > 0
        ? (widget.mode == SendMessagePage.PROPOSAL)
            ? await API.sendProposal(message)
            : await API.reportProblem(message)
        : {};
    if (data.containsKey("success")) {
      message = "";
      _formKey.currentState.validate();
      mcontroller.clear();
      setState(() {});
      Navigator.pop(mycontext);
      return;
    }

    if (data.containsKey("non_field_errors")) {
      error = data["non_field_errors"] is String
          ? data["non_field_errors"]
          : data["non_field_errors"].join();
    } else {
      error = "";
    }
    setState(() {});
    _formKey.currentState.validate();
  }

  @override
  Widget build(BuildContext context) {
    mycontext = mycontext ?? context;
    var H = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    var W = MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.left -
        MediaQuery.of(context).padding.right;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: STYLES.palette["background"],
      ),
      body: SafeArea(
          child: SafeScroll(
        child: Container(
          width: W,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: STYLES.buttonTopPadding,
                child: Stack(
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: WaapButton(
                          Icon(Icons.arrow_back),
                          type: WaapButton.RIGHT,
                          callback: () {
                            Navigator.pop(context);
                          },
                        )),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          SendMessagePage._MODES[widget.mode],
                          style: STYLES.text["pageTitle"],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Column(
                children: [
                  Container(
                    width: W,
                    padding: EdgeInsets.only(
                        top: 20, right: 30, left: 30, bottom: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: mcontroller,
                            minLines: 10,
                            maxLines: 10,
                            onChanged: (String s) {
                              message = s;
                            },
                            validator: (_) {
                              return (_ == "")
                                  ? "message_cant_be_blank".tr()
                                  : null;
                            },
                            decoration: STYLES.loginFormText,
                          ),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(minHeight: 50),
                          child: Center(
                            child: Text(
                              error,
                              style: STYLES.text["error"],
                            ),
                          ),
                        ),
                        RaisedButton(
                          child: Text(
                            "send".tr(),
                            style: STYLES.text["button1"],
                          ),
                          onPressed: validate,
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
