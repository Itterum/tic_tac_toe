import 'package:flutter/material.dart';

Items? winner;

enum Items { X, O, none }

class ItemProperties {
  final IconData icon;
  final Color bgColor;
  final Color brColor;

  ItemProperties({
    required this.icon,
    required this.bgColor,
    required this.brColor,
  });
}

Map<Items, ItemProperties> itemMap = {
  Items.X: ItemProperties(
    icon: Icons.clear,
    bgColor: Colors.green.shade300,
    brColor: Colors.green.shade300,
  ),
  Items.O: ItemProperties(
    icon: Icons.circle_outlined,
    bgColor: Colors.red.shade300,
    brColor: Colors.red.shade300,
  ),
};

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

class GameField extends StatefulWidget {
  final VoidCallback resetGame;

  const GameField({Key? key, required this.resetGame}) : super(key: key);

  @override
  State<GameField> createState() => _GameFieldState();
}

class _GameFieldState extends State<GameField> {
  Items? getWinner() {
    // Горизонтальные комбинации
    for (int i = 0; i < gameField.length; i++) {
      if (gameField[i][0] == gameField[i][1] &&
          gameField[i][1] == gameField[i][2] &&
          gameField[i][0].isNotEmpty) {
        return gameField[i][0] == 'X' ? Items.X : Items.O;
      }
    }

    // Вертикальные комбинации
    for (int j = 0; j < gameField[0].length; j++) {
      if (gameField[0][j] == gameField[1][j] &&
          gameField[1][j] == gameField[2][j] &&
          gameField[0][j].isNotEmpty) {
        return gameField[0][j] == 'X' ? Items.X : Items.O;
      }
    }

    // Диагональные комбинации
    if ((gameField[0][0] == gameField[1][1] &&
            gameField[1][1] == gameField[2][2] &&
            gameField[0][0].isNotEmpty) ||
        (gameField[0][2] == gameField[1][1] &&
            gameField[1][1] == gameField[2][0] &&
            gameField[0][2].isNotEmpty)) {
      return gameField[1][1] == 'X' ? Items.X : Items.O;
    }

    // Ничья
    if (!gameField.any((row) => row.any((cell) => cell.isEmpty))) {
      return Items.none;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (winner != null)
          Text(
            winner == Items.none
                ? 'Draw'
                : winner != Items.none
                    ? 'Winner: ${winner == Items.X ? 'X' : 'O'}'
                    : 'Good luck',
            style: const TextStyle(
                color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
        if (winner == null)
          const Text(
            'Good luck',
            style: TextStyle(
                color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
        const SizedBox(
          height: 30,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: gameField.length,
            itemBuilder: (BuildContext context, int i) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int j = 0; j < gameField[i].length; j++)
                    GestureDetector(
                      onTap: () {
                        if (gameField[i][j] == '' && winner == null) {
                          setState(() {
                            if (gameField[i][j] == '' && getWinner() == null) {
                              if (currentPlayer == Items.X) {
                                gameField[i][j] = 'X';
                                cellColors[i][j] = itemMap[Items.X]!.bgColor;
                                currentPlayer = Items.O;
                              } else if (currentPlayer == Items.O) {
                                gameField[i][j] = 'O';
                                cellColors[i][j] = itemMap[Items.O]!.bgColor;
                                currentPlayer = Items.X;
                              }
                            }

                            winner = getWinner(); // Добавить эту строку
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: cellColors[i][j],
                            border: Border.all(color: cellColors[i][j]),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Icon(
                              gameField[i][j] == 'X'
                                  ? itemMap[Items.X]?.icon
                                  : gameField[i][j] == 'O'
                                      ? itemMap[Items.O]?.icon
                                      : null,
                              size: 64,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
