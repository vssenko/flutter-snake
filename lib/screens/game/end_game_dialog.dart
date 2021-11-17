import 'package:flutter/material.dart';
import '../../services/leaderboard.dart';

const defaultUser = 'Snaker';

class GameDialogResultData {
  final String username;
  GameDialogResultData({required this.username});
}

typedef GameDialogResultHandler = Function(GameDialogResultData);

class EndGameDialog extends StatefulWidget {
  final int score;
  final GameDialogResultHandler? onStartGameClick;
  final GameDialogResultHandler? onCloseClick;

  const EndGameDialog(
      {Key? key, required this.score, this.onStartGameClick, this.onCloseClick})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EndGameDialogState(
      score: score,
      onStartGameClick: onStartGameClick,
      onCloseClick: onCloseClick,
    );
  }
}

class _EndGameDialogState extends State<EndGameDialog> {
  String? _username;
  final int score;
  final GameDialogResultHandler? onStartGameClick;
  final GameDialogResultHandler? onCloseClick;
  late final LeaderBoardService _leaderBoardService;

  _EndGameDialogState(
      {required this.score, this.onStartGameClick, this.onCloseClick}) {
    _leaderBoardService = LeaderBoardService();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      if (_username == null) {
        var username = await _leaderBoardService.getLastPlayerName();
        setState(() {
          _username = username;
        });
      }
    });

    var txtController = TextEditingController(text: _username);

    return SingleChildScrollView(
      child: ListBody(
        children: [
          const Text('Thanks for playing this masterpiece!'),
          Text('Your score is $score!'),
          TextField(
            controller: txtController,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                child: const Text('New game'),
                onPressed: () {
                  if (onStartGameClick != null) {
                    onStartGameClick!(
                        GameDialogResultData(username: txtController.text));
                  }
                },
              ),
              ElevatedButton(
                child: const Text('Main menu'),
                onPressed: () {
                  if (onCloseClick != null) {
                    onCloseClick!(
                        GameDialogResultData(username: txtController.text));
                  }
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
