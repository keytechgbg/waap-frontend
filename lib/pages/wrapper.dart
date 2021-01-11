import 'package:flutter/material.dart';
import 'package:waap/STYLES.dart';
import 'package:waap/services/shared.dart';
import 'package:waap/pages/authentication/authenticator.dart';
import 'package:waap/pages/home/main_page.dart';
import 'package:waap/pages/errorpage.dart';
import 'package:waap/pages/loading.dart';

class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      initialData: false,
      future: Shared.isAuthenticated(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        var page;
        if (snapshot.hasData)
          page = (snapshot.data) ? MainPage() : Authentificator();
        else if (snapshot.hasError)
          page = ErrorPage();
        else
          page = LoadingPage();

        STYLES.width =MediaQuery.of(context).size.width;
        return
        Theme(data: STYLES.main_theme, child: page);
      },
    );


  }
}