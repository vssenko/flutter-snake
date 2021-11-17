import 'package:hive/hive.dart';
import 'dart:math' as math;

const defaultUserName = 'Snaker';

const _leadersBoxName = 'leaders';
const _leadersKey = 'leaders';
const _lastUserNameKey = 'username';

class Leader {
  String name;
  int score;

  Leader({required this.name, required this.score});

  String serialize() {
    return '$name:::$score';
  }

  static Leader deserialize(String s) {
    var splitted = s.split(':::');
    var score = int.parse(splitted.last);
    var name = splitted.sublist(0, splitted.length - 1).join(':::');
    return Leader(name: name, score: score);
  }
}

class LeaderBoardService {
  Future<Box> _openBox() {
    return Hive.openBox(_leadersBoxName);
  }

  Future<Leader> addLeader({required String name, required int score}) async {
    var box = await _openBox();
    var newLeader = Leader(name: name, score: score);
    var leaderList = await getLeaders();
    Leader? existingLeader;
    try {
      existingLeader =
          leaderList.firstWhere((element) => element.name == newLeader.name);
    } catch (e) {}

    if (existingLeader != null && existingLeader.score > newLeader.score) {
      existingLeader.score = score;
    } else {
      leaderList.add(newLeader);
    }

    leaderList.sort((a, b) => a.score - b.score);
    leaderList = leaderList.sublist(0, math.min(leaderList.length, 10));

    List<String> result = leaderList.map((e) => e.serialize()).toList();
    await box.put(_leadersKey, result);
    await box.put(_lastUserNameKey, name);
    return newLeader;
  }

  Future<String> getLastPlayerName() async {
    var box = await _openBox();
    return box.get(_lastUserNameKey, defaultValue: defaultUserName);
  }

  Future<List<Leader>> getLeaders() async {
    var box = await _openBox();
    List<String> currentList =
        box.get(_leadersKey, defaultValue: <String>[]) as List<String>;
    return currentList.map<Leader>((s) {
      return Leader.deserialize(s);
    }).toList();
  }
}
