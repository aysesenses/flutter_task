import 'package:firebase/constants/constant.dart';
import 'package:firebase/utils/calculate_score.dart';
import 'package:flutter/material.dart';


class BuildNumButton extends StatefulWidget {
  final int number;
  final Color color;
  final Color buttonColorDisable;
  final Function callbackColor;
  final Function callbackList;
  final Function callbackScore;
  final Function callbackTarget;

  const BuildNumButton(
      {Key? key,
      required this.number,
      required this.callbackScore,
      required this.callbackList,
      required this.callbackTarget,
      required this.callbackColor,
      required this.color,
      required this.buttonColorDisable})
      : super(key: key);

  @override
  State<BuildNumButton> createState() => _BuildNumButtonState();
}

class _BuildNumButtonState extends State<BuildNumButton> {
  bool isButtonDisable = false;

  void _buttonFunction() {
    //isButtonDisable = true;
    CalculateScore.sumNumbers(widget.number);
    CalculateScore.calculateScore();
    widget.callbackScore();
    if (CalculateScore.answer == true) {
      if (!CalculateScore.endGame) {
        widget.callbackList();
        widget.callbackColor();
      }
       widget.callbackTarget();
      //isButtonDisable = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 120,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(widget.color),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Colors.white, width: 3),
            ),
          ),
        ),
        onPressed: isButtonDisable ? null : _buttonFunction,
        child: Text(
          widget.number.toString(),
          style: numButtonTextStyle,
        ),
      ),
    );
  }
}
