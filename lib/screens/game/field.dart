import 'dart:math';
import 'package:flutter/material.dart';
import './game_engine.dart';

var baitColor = Colors.red[500];
var snakeBorderColor = Colors.green[700];
var snakeHeadColor = Colors.green[900];
var snakeBodyColor = Colors.green[500];

var lightSquareColor = Colors.blue[50];
var darkSquareColor = Colors.blue[100];

class SquareSize {
  double width;
  double height;
  late double minSize;
  SquareSize({required this.width, required this.height}) {
    minSize = min(width, height);
  }
}

class Field extends StatelessWidget {
  final SnakeGameEngine gameEngine;
  final SquareSize squareSize;
  const Field({Key? key, required this.gameEngine, required this.squareSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var rows = <Widget>[];

    var index = 0;
    for (var row = 0; row < gameEngine.ySize; row++) {
      var rowWidgets = <Widget>[];
      index++;
      for (var column = 0; column < gameEngine.xSize; column++) {
        index++;
        rowWidgets.add(_buildSquare(
            content: gameEngine.getSquareContent(x: column, y: row),
            light: index % 2 == 0));
      }

      rows.add(Row(children: rowWidgets));
    }

    return Column(
      children: rows,
    );
  }

  Widget _buildSquare({required SquareContent content, required bool light}) {
    Widget widgetContent = const SizedBox.shrink();
    if (content == SquareContent.bait) {
      widgetContent = _Bait(size: squareSize);
    } else if (content == SquareContent.snakeBody) {
      widgetContent = _SnakeBody(size: squareSize);
    } else if (content == SquareContent.snakeHead) {
      widgetContent = _SnakeHead(size: squareSize);
    }

    return Container(
      color: light ? lightSquareColor : darkSquareColor,
      height: squareSize.height,
      width: squareSize.width,
      child: widgetContent,
    );
  }
}

class _Bait extends StatelessWidget {
  final SquareSize size;
  const _Bait({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.minSize,
      height: size.minSize,
      decoration: BoxDecoration(
        color: baitColor,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _SnakeHead extends StatelessWidget {
  final SquareSize size;
  const _SnakeHead({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
          color: snakeHeadColor,
          border: Border.all(color: snakeBorderColor!, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
    );
  }
}

class _SnakeBody extends StatelessWidget {
  final SquareSize size;
  const _SnakeBody({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
          color: snakeBodyColor,
          border: Border.all(color: snakeBorderColor!, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
    );
  }
}
