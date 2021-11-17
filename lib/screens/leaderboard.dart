import 'package:flutter/material.dart';
import '../services/leaderboard.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LeaderboardScreenState();
  }
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<Leader>? _leaders;
  late final LeaderBoardService _leaderBoardService;
  _LeaderboardScreenState() {
    _leaderBoardService = LeaderBoardService();
  }

  _reloadLeaders() async {
    var reloadedLeaders = await _leaderBoardService.getLeaders();
    setState(() {
      _leaders = reloadedLeaders;
    });
  }

  @override
  void initState() {
    super.initState();
    _reloadLeaders();
  }

  @override
  Widget build(BuildContext context) {
    if (_leaders == null) {
      return Container();
    }

    var leaderTiles = _leaders!
        .map((l) => _LeaderRow(
              leader: l,
            ))
        .toList();

    return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.only(top: 50),
                child: Text(
                  'Leaderboard',
                  style: TextStyle(color: Colors.blue[600], fontSize: 22),
                )),
            if (leaderTiles.length > 0)
              Container(
                margin: const EdgeInsets.all(50),
                child: SingleChildScrollView(
                    child: Column(
                  children: leaderTiles,
                )),
              )
          ],
        ));
  }
}

class _LeaderRow extends StatelessWidget {
  final Leader leader;
  const _LeaderRow({Key? key, required this.leader}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var rowTextStyle = TextStyle(fontSize: 14, color: Colors.blue[500]);

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        leader.name,
        style: rowTextStyle,
      ),
      Text(leader.score.toString(), style: rowTextStyle)
    ]);
  }
}
