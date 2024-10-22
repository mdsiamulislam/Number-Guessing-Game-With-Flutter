import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Black & White Number Guessing Game',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Number Guessing Game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  String result = "Start guessing!";
  int attemptsLeft = 5;
  final TextEditingController _controller = TextEditingController();
  int randomNumber = Random().nextInt(100) + 1;

  late AnimationController _animationController;
  late Animation<Color?> _colorTween;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _colorTween = ColorTween(begin: Colors.black, end: Colors.grey[800]).animate(_animationController);
  }

  void _checkNumber() {
    setState(() {
      int guessedNumber = int.tryParse(_controller.text) ?? 0;

      if (guessedNumber != randomNumber) {
        if (guessedNumber < randomNumber) {
          result = "Too low!";
        } else {
          result = "Too high!";
        }
        attemptsLeft--;

        if (attemptsLeft == 0) {
          result = "You lost! The number was $randomNumber.";
          _showResetDialog();
        }
      } else {
        result = "Congratulations! You guessed it right.";
        _animationController.forward(); // Triggers the color animation
        _showResetDialog();
      }
    });
  }

  void _resetGame() {
    setState(() {
      randomNumber = Random().nextInt(100) + 1;
      attemptsLeft = 5;
      result = "Start guessing!";
      _controller.clear();
      _animationController.reset();
    });
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text("Game Over", style: TextStyle(color: Colors.white)),
          content: Text(result, style: const TextStyle(color: Colors.white)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: const Text("Play Again", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
      ),
      body: AnimatedBuilder(
        animation: _colorTween,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              color: _colorTween.value ?? Colors.black,
            ),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Attempts Left: $attemptsLeft',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  result,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: result == "Congratulations! You guessed it right."
                        ? Colors.greenAccent // Green for success
                        : Colors.white70,
                    shadows: [const Shadow(color: Colors.black54, blurRadius: 4)],
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Enter your guess",
                      labelStyle: const TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white70),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.greenAccent),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _checkNumber,
                  icon: const Icon(Icons.play_arrow, color: Colors.black),
                  label: const Text(
                    "Guess",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
