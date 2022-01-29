import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/constants/constant.dart';
import 'package:firebase/ui/pages/game_page.dart';
import 'package:firebase/ui/pages/get_ready_page.dart';
import 'package:firebase/ui/pages/rating_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> updateScore(int score) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final preferences = await SharedPreferences.getInstance();
  final userID = preferences.getString("userID");

  DocumentSnapshot documentSnapshot =
      await _firestore.doc("users/$userID").get();
  Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
  final int oldScore = data["score"];

  if (score > oldScore) {
    return _firestore
        .doc("users/$userID")
        .update(
          {
            'score': score,
            'date': FieldValue.serverTimestamp(),
          },
        )
        .then((value) =>
            debugPrint("'full_name' & 'age' merged with existing data!"))
        .catchError((error) => debugPrint("Failed to merge data: $error"));
  }
}

alertDialog(BuildContext context, int score) {
  return showDialog<String>(
    useSafeArea: true,
    barrierColor: Colors.indigo.withOpacity(0.5),
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => AlertDialog(
      actions: <Widget>[
        const Padding(padding: EdgeInsets.all(12)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Score: ${score.toString()}",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              color: kPrimaryColor,
              iconSize: 36,
              onPressed: () {
                updateScore(score);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const RatingPage()),
                    (route) => false);
              },
              icon: Icon(Icons.home, color: kPrimaryColor),
            ),
            IconButton(
              color: kPrimaryColor,
              iconSize: 36,
              onPressed: () {
                updateScore(score);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const GetReadyPage()));
              },
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
      ],
    ),
  );
}
