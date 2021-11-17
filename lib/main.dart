import 'package:flutter/material.dart' as flutter;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './app/app.dart';

void main() async {
  await Hive.initFlutter();
  flutter.runApp(const SnakeApp());
}
