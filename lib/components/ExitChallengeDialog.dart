import 'package:flutter/material.dart';
import 'package:waap/STYLES.dart';
import 'package:waap/models/Challenge.dart';
import 'package:waap/services/api.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:waap/services/db.dart';

class ExitChallengeDialog extends StatelessWidget {
  ExitChallengeDialog(this.challenge, this.callback);

  Function callback;

  Challenge challenge;


  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: STYLES.palette["primary"],
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child : Container( padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "exit_challenge_dialog".tr().replaceAll("*", "${challenge.theme}"), style: STYLES.text["title"],),
            SizedBox(height: 40,),
            Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:[
                FlatButton(
                    child: Text("no".tr(), style: STYLES.text["title"],),
                    onPressed: () {
                      Navigator.pop(context);
                    })
                ,
                FlatButton(
                    child: Text("yes".tr(), style: STYLES.text["title"],),
                    onPressed: () async{
                      try{
                        await API.deleteChallenge(challenge.id);
                        await DBHelper().deleteChallenge(challenge.id);
                        callback();
                        Navigator.pop(context, 1);
                      } catch(e){
                        print(e);
                      }
                    })

              ], )
          ],
        ),
      ),
    );
  }
}
