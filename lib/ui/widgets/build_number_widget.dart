import 'package:firebase/constants/constant.dart';
import 'package:flutter/material.dart';

class BuildNumButton extends StatelessWidget {
  final int number;
  final Color color;
  final Color buttonColorDisable;
  final VoidCallback callback;
  final bool isDisable;

 const  BuildNumButton({
    Key? key,
    required this.number,
    required this.color,
    required this.buttonColorDisable,
    required this.callback,
    required this.isDisable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: isDisable
              ? MaterialStateProperty.all(
                  buttonColorDisable) //button color green
              : MaterialStateProperty.all(color),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Colors.white, width: 3),
            ),
          ),
        ),
        onPressed: isDisable ? null : callback,
        child: Text(
          number.toString(),
          style: numButtonTextStyle,
        ),
      ),
    );
  }
}
