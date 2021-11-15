import 'package:flutter/material.dart';
import './game_engine.dart';
import './field.dart';
import './menu_bar.dart';
import './field_settings.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() {
    return _GameScreenState();
  }
}

class _GameScreenState extends State<GameScreen> {
  FieldSettings? fieldSettings;
  SnakeGameEngine? gameEngine;

  @override
  Widget build(BuildContext context) {
    if (fieldSettings == null || gameEngine == null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        if (fieldSettings == null || gameEngine == null) {
          setState(() {
            var newSettings = calculateFieldsettings(context);
            fieldSettings = newSettings;
            var newGameEngine = SnakeGameEngine(
                xSize: newSettings.widthSquares,
                ySize: newSettings.heightSquares);
            newGameEngine.initializeGame();
            gameEngine = newGameEngine;
          });
        }
      });
      return Container();
    }

    var squareSize = fieldSettings?.squareSize;

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: menuBarContainerHeight,
            child: MenuBar(
              gameEngine: gameEngine!,
            ),
          ),
          Field(
            gameEngine: gameEngine!,
            squareSize: squareSize!,
          )
        ],
      ),
    );
  }
}
