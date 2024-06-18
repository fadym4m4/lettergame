import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lettersgame/models/LettersModel.dart';

import 'LettersRepository.dart';
import 'models/WordsModel.dart';

class HomePage extends StatefulWidget {
  LettersModel? dataShow;
  HomePage({super.key,this.dataShow});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<LettersModel> lettersFuture;
  int _start = 0;
  Timer? _timer;
  int _score = 0;
  String currentWord = '';
  List<WordsModle> allData = [
    WordsModle(words: 'APPLE'),
    WordsModle(words: 'GRAPES'),
    WordsModle(words: 'LEMON'),
    WordsModle(words: 'BANANA'),
    WordsModle(words: 'ORANGE'),
    WordsModle(words: 'MANGO'),
  ];
  List<String> formedWords = [];

  @override
  void initState() {
    super.initState();
    lettersFuture = LettersRepository().fetchLetters();
    startTimer();
  }
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _start++;
      });
    });
  }


  void _LetterTap(String letter) {
    setState(() {
      currentWord += letter;
    });
  }



  void _checkWord() {
    if (allData.any((word) => word.words == currentWord)) {
      if (!formedWords.contains(currentWord)) {
        setState(() {
          formedWords.add(currentWord);
          _score++;
          currentWord = '';
        });
        if (_score == 6) {
          _showWinDialog();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You have already formed the word: $currentWord')),
        );
        setState(() {
          currentWord = '';
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Incorrect word: $currentWord')),
      );
      setState(() {
        currentWord = '';
      });
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You Win!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text('Letter Game'),
      ),
      backgroundColor: Colors.blueAccent,
        body:Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Time: $_start seconds',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    Text(
                      'Score: $_score',
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Current Word: $currentWord',
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: _checkWord,
              style: ElevatedButton.styleFrom(
              primary: Colors.green, // Button background color
              onPrimary: Colors.white, // Button text color
                 ),
               child: Text('Check Word'),
                  ),


        Expanded(
          flex: 3,
          child: FutureBuilder<LettersModel?>(
          future: lettersFuture,
            builder: (context, snapshot) {
              final letters = snapshot.data!.letters!;
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 9,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: letters.length,
                  itemBuilder: (context, index) {
                    final letter = letters[index] ?? '';
                    return GestureDetector(
                      onTap: () => _LetterTap(letter),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          letters[index],
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                    ),
                      );
                  },
                );
              }
          ),

        ),
              // SizedBox(
              //   height: 40,
              // ),
              Expanded(
                flex: 1,
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,  // More items per row
                      crossAxisSpacing: 5,  // Reduced spacing
                      mainAxisSpacing: 5),

                    itemCount: allData.length,
                    itemBuilder: (context, index) {
                      final word = allData[index].words ?? '';
                      return GestureDetector(
                        onTap: () => _checkWord(),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: formedWords.contains(word) ? Colors.green : Colors.black54,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            word,
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                      ),
                        );
                    }
                ),
              ),
      ]
     )
    );
  }
}
