import 'package:flutter/material.dart';

import 'package:waap/STYLES.dart';
import 'package:waap/components/WaapButton.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:waap/services/api.dart';
import 'package:waap/services/shared.dart';

class StatisticsPage extends StatelessWidget {


  Future<Map<String, int>> updateStats()async{
    var stats = await API.getStats();
    if (stats !=null) {
      await Shared.setStats(stats);
    }
    var shared = await Shared.getStats();

    return shared;
    }

  final double borderSize=2;
  @override
  Widget build(BuildContext context) {
    var W = MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.left -
        MediaQuery.of(context).padding.right;

    return Scaffold(
      body: SafeArea(
        child: Column(
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
                    child: Align(alignment: Alignment.center,
                      child: Text(
                        "statistics".tr(),
                        style: STYLES.text["pageTitle"],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Container(
                  padding: EdgeInsets.only(top: 50),
                  child: FutureBuilder<Map<String,int>>(
                    future: updateStats(),
                    builder: (BuildContext context, AsyncSnapshot<Map<String,int>> snapshot) {
                      if(snapshot.hasError){
                        print(snapshot.error);
                        return Container();
                      }
                      if (snapshot.hasData) {
                        return Container( color: Colors.white, padding: EdgeInsets.only(bottom: borderSize) ,
                          child: Column(
                            children: snapshot.data.keys
                                .map((_) => Container( margin: EdgeInsets.only(top: borderSize),
                                          padding: EdgeInsets.symmetric(vertical: 10), // line size
                                          color: STYLES.palette["primary"],
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [Padding(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Text(_.tr(), style: STYLES.text["title"],),
                                        ), Padding(
                                          padding: const EdgeInsets.only(right: 20),
                                          child: Text(snapshot.data[_].toString(), style: STYLES.text["title"] ,),
                                        ) ],
                                      ),
                                    ))
                                .toList(),
                            mainAxisSize: MainAxisSize.min,
                          ),
                        );
                      }
                      return Container(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          backgroundColor: STYLES.palette["primary"],
                          strokeWidth: 4,
                        ),
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
