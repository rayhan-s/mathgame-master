import 'package:flutter/material.dart';

import '../levels/easy.dart';
import '../levels/hard.dart';
import '../levels/medium.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int correctAnswersCount = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _buildLevelWidget(),
      ),
    );
  }

  Widget _buildLevelWidget() {
    if (correctAnswersCount < 10) {
      return EasyLevel(onAnswerCorrect: _onAnswerCorrect);
    } else if (correctAnswersCount < 20) {
      return MediumLevel(onAnswerCorrect: _onAnswerCorrect);
    } else {
      return HardLevel(onAnswerCorrect: _onAnswerCorrect);
    }
  }

  void _onAnswerCorrect() {
    setState(() {
      correctAnswersCount++;

      if (correctAnswersCount < 10) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  EasyLevel(onAnswerCorrect: _onAnswerCorrect)),
        );
      } else if (correctAnswersCount < 20) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MediumLevel(onAnswerCorrect: _onAnswerCorrect)),
        );
      } else if (correctAnswersCount < 30) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HardLevel(onAnswerCorrect: _onAnswerCorrect)),
        );
      } else {
        correctAnswersCount = 0;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  EasyLevel(onAnswerCorrect: _onAnswerCorrect)),
        );
      }
    });
  }
}
