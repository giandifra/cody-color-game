import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codyroby_game/firestore_ref.dart';
import 'package:codyroby_game/game/models/player_position.dart';
import 'package:codyroby_game/game/ui/game_board.dart';
import 'package:codyroby_game/game/ui/game_button.dart';
import 'package:codyroby_game/game/ui/roby.dart';
import 'package:codyroby_game/home/generic_button.dart';
import 'package:codyroby_game/main.dart';
import 'package:codyroby_game/match_making/models/game_session.dart';
import 'package:codyroby_game/game/models/game_status.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  final String gameId;
  final String gameName;

  const GameScreen({
    Key? key,
    required this.gameId,
    required this.gameName,
  }) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.gameName),),
      body: StreamBuilder<DocumentSnapshot<GameSession>>(
        stream: FirestoreRef.gameSessionDoc(widget.gameId).snapshots(),
        builder: (BuildContext context, snapshot) {
          final session = snapshot.data?.data();
          if (snapshot.hasError || session == null) {
            return const Text('Si è verificato un errore');
          }

          final player = session.p1.userId == gameUser!.userId
              ? Player.p1
              : session.p2?.userId == gameUser!.userId
                  ? Player.p2
                  : null;

          return player == null
              ? Text(
                  'Non fai parte di questa partita',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      ?.copyWith(color: Colors.white),
                )
              : StreamBuilder<DocumentSnapshot<GameStatus>>(
                  stream: FirestoreRef.gameSessionStatusDoc(widget.gameId)
                      .snapshots(),
                  builder: (context, snap) {
                    final status = snap.data?.data();

                    if (status == null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final p1 = status.p1;
                    final p2 = status.p2;

                    final canPlay = session.p2 != null &&
                        status.turn == player &&
                        status.winner == null;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),
                        if (session.p2 != null) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(session.p1.name),
                                  const GreenRoby(
                                      rotation: RobyRotation.nord),
                                ],
                              ),
                              const SizedBox(width: 24),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(session.p2!.name),
                                  const RedRoby(rotation: RobyRotation.nord),
                                ],
                              )
                            ],
                          ),
                          Text(
                            'È il turno di ${status.turn == Player.p1 ? session.p1.name : session.p2?.name}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                        // GenericButton(
                        //   text: 'Reset',
                        //   onTap: () {
                        //     FirestoreRef.gameSessionStatusDoc(widget.gameId)
                        //         .update(GameStatus.initialGame(widget.gameId)
                        //             .toJson());
                        //   },
                        // ),
                        Flexible(
                          child: GameBoard(
                            status: status,
                            session: session,
                            player: player,
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ...CellColor.values.sublist(1).map(
                                    (e) => Flexible(
                                      child: GameActionCard(
                                        cellColor: e,
                                        onTap: canPlay
                                            ? () => status.move(e)
                                            : null,
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          p1.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          p2.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 24),
                      ],
                    );
                  },
                );
        },
      ),
    );
  }
}
