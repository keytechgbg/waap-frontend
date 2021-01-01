import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/scheduler.dart';
import 'package:waap/STYLES.dart';
import 'package:easy_localization/easy_localization.dart';

class Congratulations extends StatelessWidget {

  Congratulations(this.photo);
  File photo;
  Timer t;

  ConfettiController _controller= ConfettiController(duration: const Duration(seconds: sec));
  static const sec=5;

  @override
  Widget build(BuildContext context) {

    var W = MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.left -
        MediaQuery.of(context).padding.right;

    var H = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    SchedulerBinding.instance.addPostFrameCallback((_){_controller.play();});

    t=Timer(Duration(seconds: sec),()=>Navigator.pop(context) );
    return Scaffold(body: SafeArea(child: Center(child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 80, bottom: 30),
          child: Text("congratulations".tr(), style: STYLES.text["pageTitle"],),
        ),
        Expanded(
          child: Stack(
            children: [
              Center(child: Image.file(photo, fit: BoxFit.contain)),
              Align(alignment: Alignment(0,-1), child: ConfettiWidget(blastDirectionality: BlastDirectionality.explosive,
                  numberOfParticles: 25,
                  canvas: Size(2000,2000),
                  shouldLoop:
                  true, // start again as soon as the animation is finished
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple
                  ],confettiController : _controller,),)
            ],
          ),
        ),
      ],
    )),),);
  }
}
