import 'package:flutter/material.dart';
import 'package:waap/models/Challenge.dart';
import 'package:waap/pages/home/challenge_finished.dart';
import 'package:waap/pages/home/challenge_started.dart';
import 'package:waap/pages/home/challenge_voting.dart';



class ChallengeDetailPage extends StatelessWidget {

  ChallengeDetailPage(this.challenge) {}

  Challenge challenge;
  @override
  Widget build(BuildContext context) {


    switch(challenge.status){

      case Challenge.STARTED:
        return ChallengeStartedPage(challenge);

      case Challenge.VOTING:
        return ChallengeVotingPage(challenge);

      case Challenge.FINISHED:
        return ChallengeFinishedPage(challenge);

    }

  }
}
