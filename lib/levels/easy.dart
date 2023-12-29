import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mathgametutorial/util/appwrite_controller.dart';
import 'package:mathgametutorial/util/my_button.dart';
import 'package:mathgametutorial/util/result_message.dart';
import 'medium.dart';

class EasyLevel extends StatefulWidget {
  final VoidCallback onAnswerCorrect;

  const EasyLevel({Key? key, required this.onAnswerCorrect}) : super(key: key);

  @override
  State<EasyLevel> createState() => _EasyLevelState();
}

class _EasyLevelState extends State<EasyLevel> {
  List<String> numberPad = [
    '7',
    '8',
    '9',
    'C',
    '4',
    '5',
    '6',
    'DEL',
    '1',
    '2',
    '3',
    '=',
    '0',
    '-',
  ];

  int numberA = 1;
  int numberB = 1;
  MathOperation operation = MathOperation.Addition;

  late AppwriteController appwriteController;
  String userAnswer = '';
  var randomNumber = Random();

  int timerDurationInSeconds = 30;
  late Timer timer;

  @override
  void initState() {
    super.initState();

    startTimer();
    appwriteController = AppwriteController();

    generateNewQuestion();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (timerDurationInSeconds > 0) {
          timerDurationInSeconds--;
        } else {
          timer.cancel();
          handleTimerExpiration();
        }
      });
    });
  }

  void handleTimerExpiration() {
    showDialog(
      context: context,
      builder: (context) {
        return ResultMessage(
          message: 'Time\'s up! Try again',
          onTap: goBackToQuestion,
          icon: Icons.rotate_left,
        );
      },
    );
    resetTimer();
  }

  void buttonTapped(String button) {
    if (button == '=') {
      checkResult();
    } else if (button == 'C') {
      userAnswer = '';
    } else if (button == 'DEL') {
      if (userAnswer.isNotEmpty) {
        userAnswer = userAnswer.substring(0, userAnswer.length - 1);
      }
    } else if (userAnswer.length < 3) {
      userAnswer += button;
    }
    resetTimer();
  }

  void checkResult() {
    int correctAnswer = numberA + numberB;

    if (correctAnswer == int.parse(userAnswer)) {
      showDialog(
        context: context,
        builder: (context) {
          String documentId = DateTime.now().millisecondsSinceEpoch.toString();

          return ResultMessage(
            message: 'Correct!',
            onTap: () {
              appwriteController.sendUserAnswer(userAnswer, documentId);
              goToNextQuestion();
            },
            icon: Icons.arrow_forward,
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return ResultMessage(
            message: 'Sorry, try again',
            onTap: goBackToQuestion,
            icon: Icons.rotate_left,
          );
        },
      );
    }
  }

  void goToNextQuestion() {
    Navigator.of(context).pop();

    setState(() {
      userAnswer = '';
      widget.onAnswerCorrect();
    });

    resetTimer();
  }

  void goBackToQuestion() {
    Navigator.of(context).pop();

    resetTimer();
  }

  void generateNewQuestion() {
    numberA = randomNumber.nextInt(10);
    numberB = randomNumber.nextInt(10);
  }

  void resetTimer() {
    setState(() {
      timer.cancel();
      timerDurationInSeconds = 30;
      startTimer();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[300],
      body: Column(
        children: [
          Container(
            height: 160,
            color: Colors.deepPurple,
            child: Center(
              child: Text(
                'Math Game - Easy Level',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Time remaining: ${formatTimer(timerDurationInSeconds)}',
              style: TextStyle(color: Colors.white, fontSize: 36),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${numberA.toString()} + ${numberB.toString()} = ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      Container(
                        height: 70,
                        width: 140,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple[400],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            userAnswer,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                itemCount: numberPad.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  return MyButton(
                    child: numberPad[index],
                    onTap: () => buttonTapped(numberPad[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatTimer(int seconds) {
    int minutes = seconds ~/ 30;
    int remainingSeconds = seconds % 30;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
