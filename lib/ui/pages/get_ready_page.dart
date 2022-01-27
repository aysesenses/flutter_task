import 'dart:async';

import 'package:firebase/constants/constant.dart';
import 'package:firebase/utils/random_utils.dart';
import 'package:flutter/material.dart';
import 'game_page.dart';

class GetReadyPage extends StatefulWidget {
  const GetReadyPage({Key? key}) : super(key: key);

  @override
  State<GetReadyPage> createState() => _GetReadyPageState();
}

class _GetReadyPageState extends State<GetReadyPage> {
  int _counter = 3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    //_counter = 3;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _timer!.cancel();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const GamePage()));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _counter.toString(),
                style: TextStyle(
                  fontSize: 60,
                  color: Util.randomColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Get Ready",
                style: getReadyTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
