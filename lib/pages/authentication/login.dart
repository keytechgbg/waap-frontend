import 'package:flutter/material.dart';
import 'package:waap/STYLES.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:waap/components/WaapButton.dart';
import 'package:waap/services/api.dart';
import 'package:waap/services/shared.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username = "";

  String password = "";

  String error = "";

  BuildContext mycontext;

  final _formKey = GlobalKey<FormState>();

  validate() async {
    Map data = await API.login(username: username, password: password);
    if (data.containsKey("token")) {
      Shared.logIn(username: username, token: "Token " + data["token"]);
      Navigator.pushNamedAndRemoveUntil(mycontext, "/", (Route route) => false);
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
          child: SingleChildScrollView(
        child: Container(
          width: W,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  padding: STYLES.buttonTopPadding,
                  alignment: Alignment.bottomLeft,
                  child: WaapButton(
                    Icon(Icons.arrow_back),
                    type: WaapButton.RIGHT,
                    callback: () {
                      Navigator.pop(context);
                    },
                  )),
              SizedBox(
                height: 60,
              ),
              Container(
                width: W,
                padding:
                    EdgeInsets.only(top: 50, right: 30, left: 30, bottom: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.symmetric(
                        horizontal: BorderSide(
                      width: 5,
                      color: STYLES.palette["primary"],
                    ))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            onChanged: (String s) {
                              username = s;
                            },
                            initialValue: username,
                            validator: (_) {
                              return (_ == "")
                                  ? "username_field_is_required".tr()
                                  : null;
                            },
                            decoration: STYLES.loginFormText
                                .copyWith(labelText: "username".tr()),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          TextFormField(
                            onChanged: (String s) {
                              password = s;
                            },
                            initialValue: password,
                            validator: (_) {
                              return (_ == "")
                                  ? "password_field_is_required".tr()
                                  : null;
                            },
                            decoration: STYLES.loginFormText.copyWith(
                              labelText: "password".tr(),
                            ),
                            obscureText: true,
                            obscuringCharacter: "●",
                          )
                        ],
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
                        "login".tr(),
                        style: STYLES.text["button1"],
                      ),
                      onPressed: validate,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
