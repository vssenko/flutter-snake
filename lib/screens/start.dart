import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/routes.dart';

class _MenuButton extends StatelessWidget {
  final VoidCallback? handler;
  final String? name;
  const _MenuButton({Key? key, this.handler, this.name}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(fixedSize: const Size(170, 35)),
            onPressed: handler,
            child: Text(name as String)));
  }
}

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onNewGameClick() {
      Navigator.pushNamed(context, Routes.game);
    }

    void _onLeaderboardClick() {
      Navigator.pushNamed(context, Routes.leaderboard);
    }

    return Container(
      color: Colors.blue[50],
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 250),
      child: Column(
        children: [
          _MenuButton(
            name: 'New Game',
            handler: _onNewGameClick,
          ),
          _MenuButton(
            name: 'Leadership',
            handler: _onLeaderboardClick,
          )
        ],
      ),
    );
  }
}
