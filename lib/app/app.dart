import 'package:flutter/material.dart';
import '../screens/start.dart';
import './navigation.dart' as navigation;

class SnakeApp extends StatelessWidget {
  const SnakeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: StartScreen(),
      onUnknownRoute: navigation.unknownRouteHandler,
      onGenerateRoute: navigation.genericRouteHandler,
    );
  }
}
