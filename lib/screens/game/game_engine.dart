import 'dart:math';

enum SquareContent { empty, snakeHead, snakeBody, bait }

enum GameMove { up, down, left, right }

enum GameState { notStarted, playing, ended }

class Position {
  final int x;
  final int y;
  const Position({required this.x, required this.y});
}

class SnakeGameEngine {
  late List<List<SquareContent>> _field;
  Position? _baitPosition;
  late List<Position> _snake;

  late GameState gameState;
  late int score;

  int xSize;
  int ySize;

  SnakeGameEngine({required this.xSize, required this.ySize}) {
    gameState = GameState.notStarted;
    resetField();
  }

  void resetField() {
    score = 0;
    _baitPosition = null;
    _snake = <Position>[];

    _field = [];
    for (var y = 0; y < ySize; y++) {
      _field.add(List.filled(xSize, SquareContent.empty));
    }
  }

  void _reflectPositionsInField(
      List<Position> positions, SquareContent content) {
    positions.forEach((element) {
      _field[element.y][element.x] = content;
    });
  }

  void _reflectSnakeInField() {
    _reflectPositionsInField([_snake[0]], SquareContent.snakeHead);
    _reflectPositionsInField(_snake.sublist(1), SquareContent.snakeBody);
  }

  void _initializeSnake() {
    var middleRow = (ySize / 2).round();
    var middleColumn = (xSize / 2).round();

    _snake.addAll([
      Position(x: middleColumn + 1, y: middleRow),
      Position(x: middleColumn, y: middleRow),
      Position(x: middleColumn - 1, y: middleRow)
    ]);

    _reflectSnakeInField();
  }

  void _createBait() {
    var random = Random();
    var freeSquares = [];
    for (var y = 0; y < _field.length; y++) {
      for (var x = 0; x < _field[y].length; x++) {
        if (_field[y][x] == SquareContent.empty) {
          freeSquares.add(Position(x: x, y: y));
        }
      }
    }

    if (freeSquares.isEmpty) {
      gameState = GameState.ended;
      return;
    }

    if (_baitPosition != null &&
        getSquareContent(x: _baitPosition!.x, y: _baitPosition!.y) ==
            SquareContent.bait) {
      _reflectPositionsInField([_baitPosition!], SquareContent.empty);
    }

    var randomPlace = freeSquares[random.nextInt(freeSquares.length - 1)];
    _baitPosition = randomPlace;
    _reflectPositionsInField([_baitPosition!], SquareContent.bait);
  }

  void initializeGame() {
    resetField();
    _initializeSnake();
    _createBait();

    gameState = GameState.playing;
  }

  SquareContent getSquareContent({required int x, required int y}) {
    return _field[y][x];
  }

  void makeMove(GameMove gameMove) {
    if (gameState == GameState.ended) {
      return;
    }

    var currentSnakePosition = [..._snake];

    var neck = _snake[0];
    var move = _getMove(gameMove);
    var newHead = Position(x: neck.x + move.xChange, y: neck.y + move.yChange);

    if (_isOutOfBorder(newHead)) {
      gameState = GameState.ended;
      return;
    }

    var newHeadPlaceContent = getSquareContent(x: newHead.x, y: newHead.y);
    var isOnBait = newHeadPlaceContent == SquareContent.bait;

    if (newHeadPlaceContent == SquareContent.snakeBody) {
      gameState = GameState.ended;
      return;
    }

    if (!isOnBait) {
      _snake.removeLast();
    }

    _snake = [newHead, ..._snake];

    _reflectPositionsInField(currentSnakePosition, SquareContent.empty);
    _reflectSnakeInField();

    if (isOnBait) {
      score++;
      _createBait();
    }
  }

  bool _isOutOfBorder(Position position) {
    return position.x < 0 ||
        position.x >= xSize ||
        position.y < 0 ||
        position.y >= ySize;
  }
}

class Move {
  int xChange;
  int yChange;
  Move({required this.xChange, required this.yChange});
}

Move _getMove(GameMove gameMove) {
  if (gameMove == GameMove.up) {
    return Move(xChange: 0, yChange: -1);
  } else if (gameMove == GameMove.left) {
    return Move(xChange: -1, yChange: 0);
  } else if (gameMove == GameMove.right) {
    return Move(xChange: 1, yChange: 0);
  } else if (gameMove == GameMove.down) {
    return Move(xChange: 0, yChange: 1);
  }

  throw Error();
}
