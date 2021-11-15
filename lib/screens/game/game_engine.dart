import 'dart:math';

enum SquareContent { empty, snakeHead, snakeBody, bait }

/*
  Field
  ----------→ x
  | * * * * * *
  | * * * * * *
  | * * * * * *
  | * * * * * *
  | * * * * * *
  ↓ * * * * * *
  y * * * * * *

*/

class SnakeGameEngine {
  // _field[3][5] - 3rd row, 5th column
  late List<List<SquareContent>> _field;
  int xSize;
  int ySize;
  late int score;

  SnakeGameEngine({required this.xSize, required this.ySize}) {
    resetField();
  }

  resetField() {
    score = 0;
    _field = [];
    for (var y = 0; y < ySize; y++) {
      _field.add(List.filled(xSize, SquareContent.empty));
    }
  }

  initializeSnake() {
    var middleRow = (ySize / 2).round();
    var middleColumn = (xSize / 2).round();
    _field[middleRow][middleColumn - 1] = SquareContent.snakeBody;
    _field[middleRow][middleColumn] = SquareContent.snakeBody;
    _field[middleRow][middleColumn + 1] = SquareContent.snakeHead;
  }

  createBait() {
    var _random = Random();

    var baitSettled = false;
    while (!baitSettled) {
      var randomRow = _random.nextInt(ySize);
      var randomColumn = _random.nextInt(xSize);
      if (_field[randomRow][randomColumn] == SquareContent.empty) {
        _field[randomRow][randomColumn] = SquareContent.bait;
        baitSettled = true;
      }
    }
  }

  initializeGame() {
    resetField();
    initializeSnake();
    createBait();
  }

  getSquareContent({required int x, required int y}) {
    return _field[y][x];
  }
}
