import 'package:flutter/material.dart';
import 'package:waap/STYLES.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:waap/components/WaapButton.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String username;

  String password;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var H = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    var W = MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.left -
        MediaQuery.of(context).padding.right;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Color(0xFF4C540B),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          color: STYLES.palette["background"],
          width: W,
          height: H,
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
                            decoration: STYLES.loginFormText
                                .copyWith(labelText: "username".tr()),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          TextFormField(
                              decoration: STYLES.loginFormText
                                  .copyWith(labelText: "password".tr()),
                              obscureText: true,
                              obscuringCharacter: "●"),
                          SizedBox(
                            height: 50,
                          ),
                          TextFormField(
                            decoration: STYLES.loginFormText
                                .copyWith(labelText: "email".tr()),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    RaisedButton(
                      child: Text(
                        "login".tr(),
                        style: STYLES.text["button1"],
                      ),
                      onPressed: () {},
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
