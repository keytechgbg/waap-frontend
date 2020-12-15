import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:waap/STYLES.dart';
import 'package:easy_localization/easy_localization.dart';

class TimePickerDialog extends StatefulWidget {
  TimePickerDialog({this.text, this.callback});

  String text;
  Function callback;

  @override
  TimePickerDialogState createState() => TimePickerDialogState();
}

class TimePickerDialogState extends State<TimePickerDialog> {
  int d = 0, h = 0, m = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: STYLES.palette["primary"],
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(

          child: Column( mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(widget.text, style: STYLES.text["pageTitle"],),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 30,
                          child: NumberPicker.integer(
                              initialValue: d,
                              minValue: 0,
                              maxValue: 9,
                              onChanged: (num) {
                                setState(() {
                                  d = num;
                                });
                              }),
                        ),Text(
                          "d",
                          style: STYLES.text["title"],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 30,
                          child: NumberPicker.integer(
                              initialValue: h,
                              minValue: 0,
                              maxValue: 23,
                              onChanged: (num) {
                                setState(() {
                                  h = num;
                                });
                              }),
                        ),Text(
                          "h",
                          style: STYLES.text["title"],
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        SizedBox(
                          width: 30,
                          child: NumberPicker.integer(
                              initialValue: m,
                              minValue: 0,
                              maxValue: 59,
                              onChanged: (num) {
                                setState(() {
                                  m = num;
                                });
                              }),
                        ),Text(
                          "m",
                          style: STYLES.text["title"],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              FlatButton(
                color: STYLES.palette["primary"],
                  onPressed: () {
                    widget.callback(Duration(days: d, hours: h, minutes: m));
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "set".tr(),
                    style: STYLES.text["title"],
                  ))
            ],
          ),
        ));
  }
}
