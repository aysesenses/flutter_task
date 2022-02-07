import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase/constants/constant.dart';
import 'package:firebase/services/shared_pref_services.dart';
import 'package:firebase/ui/widgets/users_widget.dart';
import 'package:flutter/material.dart';

import 'get_ready_page.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({Key? key}) : super(key: key);

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  String? name;
  static String? userID;
  int? userBestScore;
  final _service = SharedPreferenceService();

  final TextEditingController _myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _readData();
  }

  @override
  void dispose() {
    _myController.dispose();
    super.dispose();
  }

  void _readData() async {
    userID = await _service.readSharedPrefs();
    setState(() {
      if (userID == null) {
        _showDialog(context, _myController);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userID)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return const Center(
                child: Text(
                  "LET's GET PLAY GAME",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              );
            }

            return Column(
              children: <Widget>[
                SizedBox(
                  height: size.height * 0.2,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: size.height * 0.2 - 27,
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(24),
                              bottomRight: Radius.circular(24),
                            )),
                        child: yourBestScore(snapshot.data?["score"]),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: howToPlay(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4)),
                      child: const UserInformation()),
                ),
                const SizedBox(height: 60),
              ],
            );
          },
        ),
        floatingActionButton: floatingActionButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Column yourBestScore(int? score) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: const Icon(
            Icons.emoji_flags_rounded,
            size: 56.0,
            color: Colors.white,
          ),
          title: const Text('Your Best Score',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              )),
          subtitle: Text(
            score != null ? score.toString() : '0',
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          child: DottedLine(
            direction: Axis.horizontal,
            lineLength: double.infinity,
            dashLength: 8.0,
            dashColor: Colors.white,
            dashGapLength: 8.0,
            lineThickness: 0.5,
          ),
        ),
      ],
    );
  }

  GestureDetector howToPlay() {
    return GestureDetector(
      onTap: () => () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 10),
              blurRadius: 50,
              color: kPrimaryColor.withOpacity(0.5),
            ),
          ],
        ),
        child: Row(
          children: const [
            Icon(Icons.help_outline_rounded),
            SizedBox(width: 16),
            Text(
              "HOW TO PLAY",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  FloatingActionButton floatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: kPrimaryColor,
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
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: kPrimaryColor,
      centerTitle: true,
      titleTextStyle: const TextStyle(fontSize: 36),
      title: const Text("NUMBERS"),
      elevation: 0,
    );
  }

  _showDialog(
      BuildContext context, TextEditingController textController) async {
    await showDialog<String>(
      barrierDismissible: false,
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
                  _service.writeSharedPrefs(_myController.text);
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }
}

class SystemPadding extends StatelessWidget {
  final Widget child;
  const SystemPadding({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return AnimatedContainer(
        padding: mediaQuery.viewPadding,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
