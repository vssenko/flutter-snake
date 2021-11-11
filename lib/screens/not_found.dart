import 'package:flutter/material.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[50],
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 50),
      child: const Text('Not found'),
    );
  }
}
