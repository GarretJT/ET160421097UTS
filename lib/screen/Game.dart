import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Result.dart';

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  int level = 1;
  int gridRows = 3;
  int gridCols = 3;
  int squaresToRemember = 3;
  List<int> pattern = [];
  List<bool> guessedPattern = [];
  bool isGameActive = false;
  Timer? timer;
  int timeRemaining = 30;
  int score = 0; 

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    if (level > 5) {
      saveHighScore();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Result(score: score)),
      );
      return;
    }

    isGameActive = true;
    pattern = [];
    squaresToRemember = level + 2;
    guessedPattern = List.filled(gridRows * gridCols, false);
    generatePattern();
    showPattern();
  }

  void generatePattern() {
    Random random = Random();
    while (pattern.length < squaresToRemember) {
      int newSquare = random.nextInt(gridRows * gridCols);
      if (!pattern.contains(newSquare)) {
        pattern.add(newSquare);
      }
    }
  }

  void showPattern() {
    for (int i = 0; i < pattern.length; i++) {
      Future.delayed(Duration(seconds: 2 * i), () {
        if (isGameActive) {
          setState(() {
            guessedPattern[pattern[i]] = true;
          });
        }
      });
    }

    Future.delayed(Duration(seconds: 2 * pattern.length), () {
      if (isGameActive) {
        setState(() {
          guessedPattern = List.filled(gridRows * gridCols, false);
        });
        startTimer();
      }
    });
  }

  void startTimer() {
    timer?.cancel();
    timeRemaining = 30; 
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        timeRemaining--;
      });
      if (timeRemaining <= 0) {
        timer.cancel();
        gameOver();
      }
    });
  }

  void gameOver() {
    isGameActive = false;
    timer?.cancel();
    saveHighScore();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Game Over!"),
          content: Text("Time's up or incorrect guess!"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Result(score: score)),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void guessSquare(int index) {
    if (!isGameActive) return;

    if (pattern.contains(index)) {
      guessedPattern[index] = true;
      // Check if all squares guessed
      if (guessedPattern.where((element) => element).length == squaresToRemember) {
        score += 10;
        level++;

        if (level > 5) {
          saveHighScore(); 
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Result(score: score)),
          );
          return;
        }

        gridRows = 3;
        gridCols = 3 + level - 1;
        squaresToRemember = level + 2;
        setState(() {
          guessedPattern = List.filled(gridRows * gridCols, false);
          pattern.clear();
        });
        generatePattern();
        showPattern();
        startTimer();
      }
    } else {
      gameOver();
    }
  }

  Future<void> saveHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? 'Guest';

    List<String> currentHighScores = prefs.getStringList('highScore') ?? [];

    String newScoreEntry = '$username,$score';

    currentHighScores.add(newScoreEntry);

    currentHighScores.sort((a, b) {
      return int.parse(b.split(',')[1]).compareTo(int.parse(a.split(',')[1]));
    });

    if (currentHighScores.length > 5) {
      currentHighScores = currentHighScores.sublist(0, 5);
    }

    await prefs.setStringList('highScore', currentHighScores);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Pattern Game - Level $level'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Time Remaining: $timeRemaining',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          Center(
            child: Container(
              width: 300,
              height: 300,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridCols,
                  childAspectRatio: 1.0,
                ),
                itemCount: gridRows * gridCols,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => guessSquare(index),
                    child: Container(
                      margin: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: guessedPattern[index]
                            ? Colors.blue
                            : Colors.white,
                        border: Border.all(color: Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
