import 'package:flutter/material.dart';
import 'package:waap/STYLES.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:waap/components/SafeScroll.dart';
import 'package:waap/components/WaapButton.dart';
import 'package:waap/services/api.dart';
import 'package:waap/services/shared.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String username = "", uerror = null;

  String password = "", perror = null;

  String email = "", eerror = null;

  String error = "";

  BuildContext mycontext;

  final _formKey = GlobalKey<FormState>();

  validate() async {
    Map data = await API.register(
        username: username, password: password, email: email);

    if (data.containsKey("token")) {
      Shared.logIn(username: username, token: "Token " + data["token"]);
      Navigator.pushNamedAndRemoveUntil(mycontext, "/", (Route route) => false);
      return;
    }

    if (data.containsKey("username")) {
      uerror = data["username"].join();
    } else
      uerror = null;
    if (data.containsKey("password")) {
      perror = data["password"].join();
    } else
      perror = null;
    if (data.containsKey("email")) {
      eerror = data["email"].join();
    } else
      eerror = null;
    if (data.containsKey("non_field_errors")) {
      error = data["non_field_errors"];
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
                                      : uerror;
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
                                        : perror;
                                  },
                                  decoration: STYLES.loginFormText
                                      .copyWith(labelText: "password".tr()),
                                  obscureText: true,
                                  obscuringCharacter: "●"),
                              SizedBox(
                                height: 50,
                              ),
                              TextFormField(
                                onChanged: (String s) {
                                  email = s;
                                },
                                initialValue: email,
                                validator: (_) {
                                  return (_ == "")
                                      ? "email_field_is_required".tr()
                                      : eerror;
                                },
                                decoration: STYLES.loginFormText
                                    .copyWith(labelText: "email".tr()),
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
                            "create_account".tr(),
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
