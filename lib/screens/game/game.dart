import 'package:flutter/material.dart';
import './game_engine.dart';
import './field.dart';
import './menu_bar.dart';
import './field_settings.dart';

const shortFringeSquares = 20;
const menuBarContainerHeight = 50;

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
            gameEngine = SnakeGameEngine(
                xSize: newSettings.widthSquares,
                ySize: newSettings.heightSquares);
          });
        }
      });
      return Container();
    }

    var squareSize = fieldSettings?.squareSize;

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          MenuBar(
            gameEngine: gameEngine!,
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
