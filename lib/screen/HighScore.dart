import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HighScore extends StatefulWidget {
  @override
  _HighScoreState createState() => _HighScoreState();
}

class _HighScoreState extends State<HighScore> {
  List<List<String>> topScores = [];

  @override
  void initState() {
    super.initState();
    _loadHighScores();
  }

  Future<void> _loadHighScores() async {
    print("Loading high scores...");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? scoreData = prefs.getStringList('highScore');

    if (scoreData == null || scoreData.isEmpty) {
      print("No high scores found.");
      return; 
    }

    print("High scores loaded: $scoreData");

    topScores = scoreData.map((data) {
      List<String> splitData = data.split(',');
      print("Processing score: $splitData");
      return [splitData[0], splitData[1]]; // [username, score]
    }).toList();

    // Sort scores in descending order using integer comparison
    topScores.sort((a, b) => int.parse(b[1]).compareTo(int.parse(a[1])));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top 3 High Scores'),
      ),
      body: Center(
        child: Column(
          children: List.generate(
            3, // Only display top 3 scores
            (index) {
              if (index < topScores.length) {
                return _buildScoreCard(index + 1, topScores[index][0], topScores[index][1]);
              } else {
                return SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }

  // Create score card with rank, username, and score
  Widget _buildScoreCard(int rank, String username, String score) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            '$rank',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(username),
        trailing: Text(
          score,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
