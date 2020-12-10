import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:waap/pages/wrapper.dart';
import 'STYLES.dart';
import 'package:waap/services/shared.dart';
import 'package:waap/pages/authentication/authenticator.dart';
import 'package:waap/pages/home/main_page.dart';
import 'package:waap/pages/errorpage.dart';
import 'package:waap/pages/loading.dart';

void main() {
  runApp(EasyLocalization(
      preloaderWidget: LoadingPage(),
      preloaderColor: STYLES.palette["background"],
      supportedLocales: [Locale('en')],
      fallbackLocale: Locale('en'),
      path: 'assets/i18n',
      // <-- change patch to your
      useOnlyLangCode: true,
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        theme: STYLES.main_theme,
        initialRoute: '/',
        routes: {
          '/': (context) => Wrapper(),
        });
  }
}
