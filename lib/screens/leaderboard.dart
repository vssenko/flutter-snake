import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[50],
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 50),
      child: const Text('Leader Board'),
    );
  }
}
