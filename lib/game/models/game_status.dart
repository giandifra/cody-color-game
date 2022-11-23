import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codyroby_game/firestore_ref.dart';
import 'package:codyroby_game/game/models/player_position.dart';

extension EnumTransform<T> on List {
  String? string<T>(T value) {
    if (value == null || (isEmpty)) return null;
    var occurence = singleWhere(
        (enumItem) => enumItem.toString() == value.toString(),
        orElse: () => null);
    if (occurence == null) return null;
    return occurence.toString().split('.').last;
  }

// T enumFromString<T extends Object>(String value) {
//   final T res = firstWhere(
//     (type) => type.name == value,
//     orElse: () => first,
//   );
//   return res;
// }
}

String? enumToString(Object? o) => o?.toString().split('.').last;

T enumFromString<T extends Object>(String key, List<T> values) => values
    .firstWhere((v) => key.toLowerCase() == enumToString(v)?.toLowerCase());

enum Player {
  p1,
  p2;

  Player get nextTurn => this == Player.p1 ? Player.p2 : Player.p1;
}

class GameStatus {
  final String gameId;
  final DateTime createdAt;
  final Board board;
  final PlayerPosition p1;
  final PlayerPosition p2;
  final Player turn;
  final Player? winner;

  GameStatus({
    required this.gameId,
    required this.createdAt,
    required this.board,
    required this.p1,
    required this.p2,
    required this.turn,
    this.winner,
  });

  GameStatus.initialGame(String gameId)
      : this(
          gameId: gameId,
          createdAt: DateTime.now(),
          board: Board.initial(),
          p1: PlayerPosition(x: 0, y: 0, rotation: RobyRotation.sud),
          p2: PlayerPosition(x: 4, y: 4, rotation: RobyRotation.nord),
          turn: Player.p1,
        );

  GameStatus.fromJson(Map<String, Object?> json)
      : this(
          gameId: json['gameId'] as String,
          createdAt: (json['createdAt']! as Timestamp).toDate(),
          board: Board.fromJson(json['board'] as Map<String, dynamic>),
          p1: PlayerPosition.fromJson(json['p1'] as Map<String, dynamic>),
          p2: PlayerPosition.fromJson(json['p2'] as Map<String, dynamic>),
          turn: enumFromString(json['turn'] as String, Player.values),
          winner: json['winner'] != null
              ? enumFromString(json['winner'] as String, Player.values)
              : null,
        );

  Map<String, Object?> toJson() {
    return {
      'gameId': gameId,
      'createdAt': createdAt,
      'board': board.toJson(),
      'p1': p1.toJson(),
      'p2': p2.toJson(),
      'turn': turn.name,
      'winner': winner?.name,
    };
  }

  move(CellColor color) {
    Player? winner;

    final player = turn == Player.p1 ? p1 : p2;
    final newPosition = player.nextPosition(color);
    final newBoard = board.applyColor(newPosition.x, newPosition.y, color);

    if (!newPosition.canMove()) {
      winner = turn.nextTurn;
    }

    FirestoreRef.gameSessionStatusDoc(gameId).update({
      turn.name: newPosition.toJson(),
      'board': newBoard.toJson(),
      'turn': turn.nextTurn.name,
      'winner': winner?.name,
    });
  }

  autoMove() async {
    var currentPosition = turn == Player.p1 ? p1 : p2;
    Player? winner;
    try {
      while (hasColorOnFront(currentPosition)) {
        final nextColoredPosition =
            currentPosition.nextPosition(CellColor.empty);
        final color =
            board.getColor(nextColoredPosition.x, nextColoredPosition.y);
        currentPosition = currentPosition.nextPosition(color);
        // await FirestoreRef.gameSessionStatusDoc(gameId).update({
        //   turn.name: nextPosition.toJson(),
        //   // 'turn': turn.nextTurn.name,
        // });
        // await Future.delayed(const Duration(seconds: 5));
      }
    } on EndGameException catch (ex) {
      print('terminate game');
      winner = turn.nextTurn;
    }
    await FirestoreRef.gameSessionStatusDoc(gameId).update({
      turn.name: currentPosition.toJson(),
      'turn': turn.nextTurn.name,
      'winner': winner?.name
    });
  }

  bool hasColorOnFront(PlayerPosition currentPosition) {
    // final player = p == Player.p1 ? p1 : p2;
    final newPosition = currentPosition.nextPosition(CellColor.empty);
    if (board.getColor(newPosition.x, newPosition.y) != CellColor.empty) {
      return true;
    }
    return false;
  }
}

class Board {
  final List<List<CellColor>> board;

  Board(this.board);

  factory Board.initial() {
    return Board(initialBoard);
  }

  Board.fromJson(Map<String, Object?> json)
      : this(List<Map<String, dynamic>>.from(json['board'] as List)
            .map<List<CellColor>>((e) => List<String>.from(e.values.first)
                .map<CellColor>((e) => cellColorFromString(e))
                .toList())
            .toList());

  Map<String, Object?> toJson() {
    return {
      'board': board
          .map((e) => <String, dynamic>{'row': e.map((e) => e.name).toList()})
          .toList()
    };
  }

  Board applyColor(int _x, int _y, CellColor color) {
    final list = <List<CellColor>>[];
    for (int y = 0; y < board.length; y++) {
      final tmp = <CellColor>[];
      for (int x = 0; x < board[y].length; x++) {
        if (_x == x && _y == y) {
          tmp.add(color);
        } else {
          tmp.add(board[y][x]);
        }
      }
      list.add(tmp);
    }
    return Board(list);
  }

  CellColor getColor(int x, int y) {
    return board[y][x];
  }

// Board.fromJson(Map<String, Object?> json)
//     : this(List<List<String>>.from(json['board'] as List)
//           .map<List<CellColor>>((e) => e
//               .map<CellColor>((e) => CellColor.values.enumFromString(e))
//               .toList())
//           .toList());
//
// Map<String, Object?> toJson() {
//   return {'board': board.map((e) => e.map((e) => e.value).toList()).toList()};
// }
}

const initialBoard = [
  [
    CellColor.grey,
    CellColor.empty,
    CellColor.empty,
    CellColor.empty,
    CellColor.empty,
  ],
  [
    CellColor.empty,
    CellColor.empty,
    CellColor.empty,
    CellColor.empty,
    CellColor.empty,
  ],
  [
    CellColor.empty,
    CellColor.empty,
    CellColor.empty,
    CellColor.empty,
    CellColor.empty,
  ],
  [
    CellColor.empty,
    CellColor.empty,
    CellColor.empty,
    CellColor.empty,
    CellColor.empty,
  ],
  [
    CellColor.empty,
    CellColor.empty,
    CellColor.empty,
    CellColor.empty,
    CellColor.grey,
  ],
];
