import 'package:flutter/material.dart';

import '../utils/routes.dart';

import '../screens/start.dart';
import '../screens/game.dart';
import '../screens/leaderboard.dart';
import '../screens/not_found.dart';

typedef BuilderCallBack = Widget Function(BuildContext);

var _routeBuilders = {
  Routes.home: (BuildContext context) => const StartScreen(),
  Routes.leaderboard: (BuildContext context) => const LeaderboardScreen(),
  Routes.game: (BuildContext context) => const GameScreen()
};

Route<dynamic> unknownRouteHandler(RouteSettings settings) {
  return MaterialPageRoute(builder: (context) => const NotFoundScreen());
}

Route<dynamic> genericRouteHandler(RouteSettings settings) {
  var routeBuilder = _routeBuilders[settings.name];
  routeBuilder ??= (BuildContext context) => const NotFoundScreen();
  return MaterialPageRoute(
    settings: settings,
    builder: routeBuilder,
  );
}
