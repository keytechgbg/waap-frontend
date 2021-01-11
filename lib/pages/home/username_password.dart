import 'package:flutter/material.dart';
import 'package:waap/STYLES.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:waap/components/SafeScroll.dart';
import 'package:waap/components/WaapButton.dart';
import 'package:waap/services/api.dart';
import 'package:waap/services/shared.dart';

class UsernamePasswordPage extends StatefulWidget {
  @override
  _UsernamePasswordPageState createState() => _UsernamePasswordPageState();
}

class _UsernamePasswordPageState extends State<UsernamePasswordPage> {
  String username = "";

  String old_password = "";

  String new_password = "";

  TextEditingController ocontroller;
  TextEditingController ncontroller;

  String error = "";

  String perror = "";

  BuildContext mycontext;

  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    ocontroller=TextEditingController(text: "");
    ncontroller=TextEditingController(text: "");
  }

  initialize() async {
    username = await Shared.getUsername();
    return 1;
  }

  validate() async {
    Map data = ocontroller.text?.length>0 && ncontroller.text?.length>0 ?await API.changePassword(
        old_password: old_password, new_password: new_password): {};
    if (data.containsKey("success")) {
      old_password = "";
      new_password = "";
      perror =null;
      _formKey.currentState.validate();
      ocontroller.clear();
      ncontroller.clear();
      setState(() {

      });
      //Navigator.pop(mycontext);
      return;
    }

    if (data.containsKey("old_password")) {
      perror = data["old_password"] is String
          ? data["old_password"]
          : data["old_password"].join();
    } else {
      perror = "";
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
                          "profile".tr(),
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
              FutureBuilder(
                  future: initialize(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData)
                      return Column(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 10),
                                  child: Text(
                                    "username".tr() + " :",
                                    style: STYLES.text["title"],
                                  ),
                                ),
                                Text(
                                  username,
                                  style: STYLES.text["title"],
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 50,),
                          Container(child: Row(
                            children: [Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: Text("change_password".tr(), style: STYLES.text["title"],),
                            )],)),
                          Container(
                            width: W,
                            padding: EdgeInsets.only(
                                top: 20, right: 30, left: 30, bottom: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                          controller: ocontroller ,
                                          onChanged: (String s) {
                                            old_password = s;
                                          },
                                          validator: (_) {
                                            return (_ == "")
                                                ? "old_password_field_is_required"
                                                    .tr()
                                                : perror;
                                          },
                                          decoration: STYLES.loginFormText
                                              .copyWith(hintText: "old_password".tr()),
                                          obscureText: true,
                                          obscuringCharacter: "●"),
                                      SizedBox(
                                        height: 50,
                                      ),
                                      TextFormField(controller: ncontroller ,
                                        onChanged: (String s) {
                                          new_password = s;
                                        },
                                        validator: (_) {
                                          return (_ == "")
                                              ? "new_password_field_is_required"
                                                  .tr()
                                              : null;
                                        },
                                        obscureText: true,
                                        obscuringCharacter: "●",
                                        decoration: STYLES.loginFormText
                                            .copyWith(
                                            hintText: "new_password".tr()),
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
                                    "change".tr(),
                                    style: STYLES.text["button1"],
                                  ),
                                  onPressed: validate,
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    if (snapshot.hasError) print(snapshot.error);
                    return Container();
                  }),
            ],
          ),
        ),
      )),
    );
  }
}
