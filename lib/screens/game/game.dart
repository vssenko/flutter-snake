import 'dart:async';
import 'package:flutter/material.dart';
import './game_engine.dart';
import './field.dart';
import './menu_bar.dart';
import './field_settings.dart';

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
  FieldSettings? _fieldSettings;
  SnakeGameEngine? _gameEngine;
  GameMove _currentDirection = GameMove.right;
  Timer? _gameTickTimer;

  @override
  initState() {
    super.initState();

    _currentDirection = GameMove.right;
    // Add listeners to this class
    _gameTickTimer = Timer.periodic(gameTick, (timer) {
      if (_gameEngine == null) {
        return;
      }

      setState(() {
        _gameEngine!.makeMove(_currentDirection);
      });
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (details.delta.dx.abs() < swipeSensivity &&
        details.delta.dy.abs() < swipeSensivity) {
      return;
    }

    setState(() {
      if (details.delta.dx.abs() > details.delta.dy.abs()) {
        if (details.delta.dx > 0) {
          _currentDirection = GameMove.right;
        } else {
          _currentDirection = GameMove.left;
        }
      } else {
        if (details.delta.dy > 0) {
          _currentDirection = GameMove.down;
        } else {
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
