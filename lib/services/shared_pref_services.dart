import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';

class SharedPreferenceService {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser({required String name}) async {
    String userId = users.doc().id;
    final preferences = await SharedPreferences.getInstance();
    preferences.setString("userID", userId);

    final userRef = users.doc(userId).withConverter<User>(
          fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!),
          toFirestore: (users, _) => users.toJson(),
        );

    return userRef
        .set(User(id: userId, name: name, score: 0, date: Timestamp.now()))
        .then((value) => debugPrint("User Added"))
        .catchError((error) => debugPrint("Failed to add user: $error"));
  }

  void writeSharedPrefs(String name) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString("userName", name);
    addUser(name: name);
  }

  Future<String?> readSharedPrefs() async {
    final preferences = await SharedPreferences.getInstance();
    var _userID = preferences.getString("userID");
    return _userID;
  }
}
