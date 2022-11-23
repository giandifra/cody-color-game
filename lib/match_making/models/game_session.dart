import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codyroby_game/match_making/models/game_user.dart';

class GameSession {
  final DateTime createdAt;
  final String name;
  final GameUser p1;
  final GameUser? p2;

  GameSession({
    required this.createdAt,
    required this.name,
    required this.p1,
    this.p2,
  });

  GameSession.fromJson(Map<String, Object?> json)
      : this(
          createdAt: (json['createdAt']! as Timestamp).toDate(),
          name: json['name'] as String,
          p1: GameUser.fromJson(json['p1'] as Map<String, dynamic>),
          p2: json['p2'] != null
              ? GameUser.fromJson(json['p2'] as Map<String, dynamic>)
              : null,
        );

  Map<String, Object?> toJson() {
    return {
      'createdAt': createdAt,
      'name': name,
      'p1': p1.toJson(),
      'p2': p2?.toJson(),
    };
  }
}
