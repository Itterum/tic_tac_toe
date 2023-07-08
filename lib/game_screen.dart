import 'package:flutter/material.dart';
import 'game_field.dart';
import 'item_properties.dart';

Items? winner;

List<List<String>> gameField = [
  ['', '', ''],
  ['', '', ''],
  ['', '', ''],
];

List<List<Color>> cellColors = [
  [Colors.white, Colors.white, Colors.white],
  [Colors.white, Colors.white, Colors.white],
  [Colors.white, Colors.white, Colors.white],
];

Items currentPlayer = Items.X; // Текущий игрок

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('tic-tac-toe'.toUpperCase()),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Center(
          child: GameField(
            resetGame: resetGame,
          ),
        ),
      ),
      backgroundColor: Colors.green.shade200,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          resetGame();
        },
        tooltip: 'Restart game',
        child: const Icon(Icons.restart_alt_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void resetGame() {
    setState(() {
      gameField = [
        ['', '', ''],
        ['', '', ''],
        ['', '', ''],
      ];
      cellColors = [
        [Colors.white, Colors.white, Colors.white],
        [Colors.white, Colors.white, Colors.white],
        [Colors.white, Colors.white, Colors.white],
      ];
      currentPlayer = Items.X;
      winner = null; // Добавьте эту строку
    });
  }
}
