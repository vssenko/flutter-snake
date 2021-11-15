import 'dart:math';
import 'package:flutter/material.dart';
import './field.dart';
import '../../utils/dimensions.dart';

const shortFringeSquares = 12;
const menuBarContainerHeight = 50.0;

class FieldSettings {
  SquareSize squareSize;
  double height;
  double width;
  int widthSquares;
  int heightSquares;

  FieldSettings(
      {required this.squareSize,
      required this.height,
      required this.width,
      required this.widthSquares,
      required this.heightSquares});
}

FieldSettings calculateFieldsettings(BuildContext context) {
  var fieldWidth = Dimentions.getWidth(context);
  var fieldHeight = Dimentions.getHeight(context) - menuBarContainerHeight;

  var shortFringle = min(fieldWidth, fieldHeight);

  late double squareWidth;
  late double squareHeight;
  late int widthSquares;
  late int heightSquares;

  if (shortFringle == fieldWidth) {
    squareWidth = fieldWidth / shortFringeSquares;
    widthSquares = shortFringeSquares;
    heightSquares = (fieldHeight / squareWidth).round();
    squareHeight = fieldHeight / heightSquares;
  } else {
    squareHeight = fieldHeight / shortFringeSquares;
    heightSquares = shortFringeSquares;
    widthSquares = (fieldWidth / squareHeight).round();
    squareWidth = fieldWidth / widthSquares;
  }

  return FieldSettings(
      height: fieldHeight,
      width: fieldWidth,
      widthSquares: widthSquares,
      heightSquares: heightSquares,
      squareSize: SquareSize(width: squareWidth, height: squareHeight));
}
