import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/model/user.dart';
import 'package:firebase/ui/widgets/users_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'get_ready_page.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({Key? key}) : super(key: key);

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  String? name;
  String? userID;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final TextEditingController _myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    readSharedPrefs();
  }

  @override
  void dispose() {
    _myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            const Expanded(flex: 1, child: Text("best score")),
            const Expanded(flex: 1, child: Text("your score")),
            Expanded(
                flex: 3,
                child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.indigo.shade300,
                        borderRadius: BorderRadius.circular(4)),
                    child: UserInformation())),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GetReadyPage()),
          ),
          icon: const Icon(
            Icons.play_arrow_rounded,
            size: 36,
          ),
          label: const Text(
            'PLAY',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  _showDialog(
      BuildContext context, TextEditingController textController) async {
    await showDialog<String>(
      context: context,
      builder: (context) => SystemPadding(
        child: AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: textController,
                  autofocus: true,
                  decoration: const InputDecoration(
                      labelText: 'Full Name',
                      hintText: 'eg. John Smith',
                      labelStyle: TextStyle(fontSize: 24)),
                ),
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
                child: const Text('SAVE'),
                onPressed: () {
                  writeSharedPrefs();
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }

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
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  void writeSharedPrefs() async {
    final _name = _myController.text;
    final preferences = await SharedPreferences.getInstance();
    preferences.setString("userName", _name);
    addUser(name: _name);
  }

  void readSharedPrefs() async {
    final preferences = await SharedPreferences.getInstance();
    name = preferences.getString("userName") ??
        _showDialog(context, _myController);
    userID = preferences.getString("userID");
    print(name);
    print(userID);
    setState(() {});
  }
}

class SystemPadding extends StatelessWidget {
  final Widget child;
  const SystemPadding({required this.child});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return AnimatedContainer(
        padding: mediaQuery.viewPadding,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
