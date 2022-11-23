import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codyroby_game/match_making/models/game_session.dart';
import 'package:codyroby_game/game/models/game_status.dart';

class FirestoreRef {
  static final CollectionReference<GameSession> gameSessionsCollection = FirebaseFirestore.instance
      .collection('gameSessions')
      .withConverter<GameSession>(
        fromFirestore: (snapshot, _) => GameSession.fromJson(snapshot.data()!),
        toFirestore: (session, _) => session.toJson(),
      );

  static DocumentReference<GameSession> gameSessionDoc(String gameId) => gameSessionsCollection.doc(gameId);

  static DocumentReference<GameStatus> gameSessionStatusDoc(String gameId) => FirebaseFirestore.instance
      .collection('gameStatus')
      .doc(gameId)
      .withConverter<GameStatus>(
        fromFirestore: (snapshot, _) => GameStatus.fromJson(snapshot.data()!),
        toFirestore: (session, _) => session.toJson(),
      );
}
