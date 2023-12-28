import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mathgametutorial/util/my_button.dart';
import 'package:mathgametutorial/util/result_message.dart';

enum MathOperation { Addition, Subtraction, Multiplication, Division }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
  ];

  int numberA = 1;
  int numberB = 1;
  MathOperation operation = MathOperation.Addition;

  String userAnswer = '';

  var randomNumber = Random();

  int timerDurationInSeconds = 15 * 60; // 15 minutes
  late Timer timer;

  @override
  void initState() {
    super.initState();

    // Start the timer when the page is first loaded
    startTimer();

    // Initialize the first question
    generateNewQuestion();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (timerDurationInSeconds > 0) {
          timerDurationInSeconds--;
        } else {
          // Timer expired, handle accordingly
          timer.cancel();
          handleTimerExpiration();
        }
      });
    });
  }

  void handleTimerExpiration() {
    // Handle what should happen when the timer expires
    // For example, show a message or go to the next question
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
    // Reset the timer when any button is pressed
    resetTimer();
  }

  void checkResult() {
    int correctAnswer;

    switch (operation) {
      case MathOperation.Addition:
        correctAnswer = numberA + numberB;
        break;
      case MathOperation.Subtraction:
        correctAnswer = numberA - numberB;
        break;
      case MathOperation.Multiplication:
        correctAnswer = numberA * numberB;
        break;
      case MathOperation.Division:
        correctAnswer = numberA ~/ numberB;
        break;
    }

    if (correctAnswer == int.parse(userAnswer)) {
      showDialog(
        context: context,
        builder: (context) {
          return ResultMessage(
            message: 'Correct!',
            onTap: goToNextQuestion,
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
      generateNewQuestion();
    });

    // Reset the timer for the next question
    resetTimer();
  }

  void goBackToQuestion() {
    Navigator.of(context).pop();

    // Reset the timer when going back to the question
    resetTimer();
  }

  void generateNewQuestion() {
    numberA = randomNumber.nextInt(10);
    numberB = randomNumber.nextInt(10);

    // Randomly choose an operation
    operation =
        MathOperation.values[randomNumber.nextInt(MathOperation.values.length)];
  }

  void resetTimer() {
    // Reset the timer duration
    setState(() {
      timer.cancel(); // Cancel the existing timer
      timerDurationInSeconds = 15 * 60; // Reset to 15 minutes
      startTimer(); // Start a new timer
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
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
                'Math Game',
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
                        '${numberA.toString()} ${getOperationSymbol()} ${numberB.toString()} = ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      Container(
                        height: 70, // Increased the height for larger size
                        width: 140, // Increased the width for larger size
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

  String getOperationSymbol() {
    switch (operation) {
      case MathOperation.Addition:
        return '+';
      case MathOperation.Subtraction:
        return '-';
      case MathOperation.Multiplication:
        return 'x';
      case MathOperation.Division:
        return '/';
    }
  }

  String formatTimer(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
