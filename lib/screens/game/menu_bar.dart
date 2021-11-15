import 'package:flutter/material.dart';
import './game_engine.dart';

var textColor = Colors.blue[900];

class MenuBar extends StatelessWidget {
  final SnakeGameEngine gameEngine;
  const MenuBar({Key? key, required this.gameEngine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Row(
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 53),
              child: Text(
                'Score: ${gameEngine.score}',
                style: TextStyle(color: textColor, fontSize: 24),
              ),
            )
          ],
        ));
  }
}
