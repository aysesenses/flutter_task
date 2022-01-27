import 'package:firebase/ui/pages/game_page.dart';

class CalculateScore {
  static int result = 0;
  static int score = 0;
  static bool endGame = false;
  static bool answer = false;
  static bool buttonColorRed = false;
  static int numberTarget = GamePageState.target();

  static int changeTarget() {
    answer = false;
    buttonColorRed = false;
    result = 0;
    return numberTarget = GamePageState.target();
  }

  static void sumNumbers(int num) {
    result = result + num;
  }

  static int calculateScore() {
    if (result == numberTarget) {
      score = score + 1000;
      answer = true;
      endGame = false;
    } else if (result > numberTarget) {
      buttonColorRed = true;
      score = score - 1000;
      answer = true;
      endGame = false;
    } else {
      //answer = false;
    }
    return score;
  }
}
