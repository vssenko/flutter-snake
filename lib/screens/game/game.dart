import 'dart:async';
import 'package:flutter/material.dart';
import './game_engine.dart';
import './field.dart';
import './menu_bar.dart';
import './field_settings.dart';
import './end_game_dialog.dart';
import '../../services/leaderboard.dart';
import '../../utils/routes.dart';

const gameTick = Duration(milliseconds: 350);

const swipeSensivity = 15;

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() {
    return _GameScreenState();
  }
}

class _GameScreenState extends State<GameScreen> {
  late LeaderBoardService _leaderBoardService;
  FieldSettings? _fieldSettings;
  SnakeGameEngine? _gameEngine;
  GameMove _currentDirection = GameMove.right;
  Timer? _gameTickTimer;

  _GameScreenState() {
    _leaderBoardService = LeaderBoardService();
  }

  void _startNewGame() {
    setState(() {
      _fieldSettings = null;
      _gameEngine = null;
      _currentDirection = GameMove.right;
      // Add listeners to this class
      _gameTickTimer = Timer.periodic(gameTick, (timer) {
        if (_gameEngine == null) {
          return;
        }

        setState(() {
          _gameEngine!.makeMove(_currentDirection);
          if (_gameEngine!.gameState == GameState.ended) {
            _gameTickTimer!.cancel();
            _showEndGameDialog();
          }
        });
      });
    });
  }

  @override
  initState() {
    super.initState();

    _startNewGame();
  }

  _saveResultInLeaderboard(GameDialogResultData data) {
    if (_gameEngine!.score > 0) {
      _leaderBoardService.addLeader(
          name: data.username, score: _gameEngine!.score);
    }
  }

  Future<void> _showEndGameDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text('Your score is ${_gameEngine?.score}'),
            content: EndGameDialog(
              score: _gameEngine!.score,
              onStartGameClick: (GameDialogResultData data) {
                _saveResultInLeaderboard(data);
                _startNewGame();
                Navigator.of(context).pop();
              },
              onCloseClick: (GameDialogResultData data) {
                _saveResultInLeaderboard(data);
                Navigator.pushNamed(context, Routes.home);
              },
            ));
      },
    );
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (details.delta.dx.abs() < swipeSensivity &&
        details.delta.dy.abs() < swipeSensivity) {
      return;
    }

    setState(() {
      if (details.delta.dx.abs() > details.delta.dy.abs()) {
        if (details.delta.dx > 0 && _currentDirection != GameMove.left) {
          _currentDirection = GameMove.right;
        } else if (_currentDirection != GameMove.right) {
          _currentDirection = GameMove.left;
        }
      } else {
        if (details.delta.dy > 0 && _currentDirection != GameMove.up) {
          _currentDirection = GameMove.down;
        } else if (_currentDirection != GameMove.down) {
          _currentDirection = GameMove.up;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_fieldSettings == null || _gameEngine == null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        if (_fieldSettings == null || _gameEngine == null) {
          setState(() {
            var newSettings = calculateFieldsettings(context);
            _fieldSettings = newSettings;
            var newGameEngine = SnakeGameEngine(
                xSize: newSettings.widthSquares,
                ySize: newSettings.heightSquares);
            newGameEngine.initializeGame();
            _gameEngine = newGameEngine;
          });
        }
      });
      return Container();
    }

    var squareSize = _fieldSettings?.squareSize;

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: menuBarContainerHeight,
            child: MenuBar(
              gameEngine: _gameEngine!,
            ),
          ),
          GestureDetector(
            onPanUpdate: _onPanUpdate,
            child: Field(
              gameEngine: _gameEngine!,
              squareSize: squareSize!,
            ),
          )
        ],
      ),
    );
  }
}
