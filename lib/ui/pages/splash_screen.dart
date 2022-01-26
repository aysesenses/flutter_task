import 'dart:async';

import 'package:firebase/constants/constant.dart';
import 'package:firebase/ui/pages/rating_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../../firebase/firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Constant.backgroundColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.indigo,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _timer();
  }

  void _timer() {
    Timer(
      const Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const RatingPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        backgroundColor: Colors.indigo,
        body: Center(
          child: Text(
            "NUMBERS",
            style: TextStyle(
                color: Colors.white, fontSize: 56, fontWeight: FontWeight.w900),
          ),
        ),
      ),
    );
  }
}
