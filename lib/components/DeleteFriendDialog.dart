import 'package:flutter/material.dart';
import 'package:waap/STYLES.dart';
import 'package:waap/services/api.dart';
import 'package:easy_localization/easy_localization.dart';

class DeleteFriendDialog extends StatelessWidget {
  DeleteFriendDialog(this.username, this.callback);

  Function callback;

  String username;


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
               "remove_dialog".tr().replaceAll("*", "$username"), style: STYLES.text["title"],),
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
                        await API.deleteFriend(username);
                        callback();
                        Navigator.pop(context, "hi");
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
