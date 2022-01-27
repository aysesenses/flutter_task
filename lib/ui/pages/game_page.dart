import 'dart:async';
import 'dart:math';

import 'package:firebase/constants/constant.dart';
import 'package:firebase/ui/pages/rating_page.dart';
import 'package:firebase/ui/widgets/alert_dialog_widget.dart';
import 'package:firebase/utils/calculate_score.dart';
import 'package:firebase/utils/random_utils.dart';
import 'package:flutter/material.dart';
import '../widgets/build_number_widget.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  int _counter = 30;
  Timer? _timer;
  int _score = 0;
  Color _color = Colors.green;

  List<int> disableButtons = [];

  static List numberList = <int>[];
  static List changeList() => List.generate(6, (index) => Random().nextInt(10));
  static List colorList = Util.colorList;

  void _updateList() {
    _updateButtonColor();
    numberList = changeList();
  }

  static int target() {
    int target = 0;
    List list = Util.targetRandom();
    int num = 2;
    while (num >= 0) {
      int index = list[num];
      target = numberList[index] + target;
      num--;
    }
    return target;
  }

  @override
  void initState() {
    super.initState();
    _counter = 30;
    _score = 0;
    _updateList();
    _updateTarget();
    _updateButtonColor();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _timer!.cancel();
          alertDialog(context, _score);
        }
      });
    });
  }

  Color _buttonColorRed() {
    if (CalculateScore.buttonColorRed) {
      _color = Colors.red;
    }
    return _color;
  }

  void _updateScore() {
    setState(() {
      _score = CalculateScore.score;
      if (_score < 0) {
        _score = 0;
        CalculateScore.endGame = true;
        alertDialog(context, _score);
        _timer!.cancel();
      }
    });
  }

  void _countineGame() {
    _startTimer();
  }

  _exitGame() async {
    _timer!.cancel();
    return _buildExitGameShowAlertDiaolog(_countineGame);
  }

  void _updateTarget() {
    setState(() {
      if (CalculateScore.score < 0) {
        CalculateScore.score = 0;
      } else {
        CalculateScore.changeTarget();
      }
    });
  }

  void _updateButtonColor() {
    setState(() {
      colorList = Util.changeColorList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _exitGame();
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: _buildTimer(_counter),
                  ),
                  Expanded(
                    child: _buildScore(_score),
                  ),
                ],
              ),
              Expanded(
                flex: 1,
                child: _buildTarget(),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        child: GridView.builder(
                          padding: const EdgeInsets.all(16),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.1,
                                  mainAxisSpacing: 10.0,
                                  crossAxisSpacing: 10.0,
                                  mainAxisExtent: 120),
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            return BuildNumButton(
                              buttonColorDisable: _buttonColorRed(),
                              color: colorList[index],
                              number: numberList[index],
                              isDisable: disableButtons.contains(index),
                              callback: () {
                                disableButtons.add(index);

                                CalculateScore.sumNumbers(numberList[index]);
                                CalculateScore.calculateScore();
                                _updateScore();
                                if (CalculateScore.answer) {
                                  if (!CalculateScore.endGame) {
                                    disableButtons.clear();
                                    _updateList();
                                    _updateButtonColor();
                                  }
                                  setState(() {});
                                  _updateTarget();
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildExitGameShowAlertDiaolog(Function countineGame) {
    return showDialog(
      useSafeArea: true,
      barrierColor: Colors.indigo.withOpacity(0.5),
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('Do you want to exit game?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const RatingPage()),
              ((route) => false),
            ),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Cancel');
              countineGame();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  _buildTarget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: targetBackgroundColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "Target",
            style: targetTextStyle,
          ),
          Text(
            CalculateScore.numberTarget.toString(),
            style: targetNumberTextStyle,
          ),
        ],
      ),
    );
  }

  _buildTimer(int counter) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: scoreBackgroundColor,
      ),
      child: Text(
        "Timer: $counter",
        textAlign: TextAlign.center,
        style: timerTextStyle,
      ),
    );
  }

  _buildScore(int score) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: scoreBackgroundColor,
      ),
      child: Text(
        "Score: ${score.toString()}",
        maxLines: 1,
        textAlign: TextAlign.center,
        style: scoreTextStyle,
      ),
    );
  }
}
