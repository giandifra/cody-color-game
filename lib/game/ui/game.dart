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

  const GameScreen({
    Key? key,
    required this.gameId,
  }) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // var p1 = PlayerPosition(x: 0, y: 0);
  // var p2 = PlayerPosition(x: 2, y: 2);

  // String? player;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   player = widget.gameSession.p1 == userId
  //       ? 'p1'
  //       : widget.gameSession.p2 == userId
  //           ? 'p2'
  //           : null;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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

                    // final playerPosition = player == Player.p1 ? p1 : p2;
                    final canPlay = session.p2 != null && status.turn == player;
                    return Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 32),
                        if (session.p2 != null) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(session.p1.name),
                                  GreenRoby(rotation: RobyRotation.nord),
                                ],
                              ),
                              const SizedBox(width: 24),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(session.p2!.name),
                                  RedRoby(rotation: RobyRotation.nord),
                                ],
                              )
                            ],
                          ),
                          Text(
                            'È il turno di ${status.turn == Player.p1 ? session.p1.name : session.p2?.name}',
                            style: TextStyle(
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
                              /*GameActionCard(
                                onTap: canPlay
                                    ? () {
                                        final newPosition = player
                                            .nextPosition(CellColor.yellow);
                                        final newBoard = status.board
                                            .applyColor(
                                                newPosition.x,
                                                newPosition.y,
                                                CellColor.yellow);
                                        FirestoreRef.gameSessionStatusDoc(
                                                widget.gameId)
                                            .update({
                                          playerTag: newPosition.toJson(),
                                          'board': newBoard.toJson(),
                                        });
                                      }
                                    : null,
                                asset: 'assets/turn_left.png',
                              ),
                              const SizedBox(width: 16),
                              GameActionCard(
                                onTap: canPlay
                                    ? () {
                                        final newPosition =
                                            player.nextPosition(CellColor.grey);
                                        final newBoard = status.board
                                            .applyColor(newPosition.x,
                                                newPosition.y, CellColor.grey);
                                        FirestoreRef.gameSessionStatusDoc(
                                                widget.gameId)
                                            .update({
                                          playerTag: newPosition.toJson(),
                                          'board': newBoard.toJson(),
                                        });
                                      }
                                    : null,
                                asset: 'assets/move_forward.png',
                              ),
                              const SizedBox(width: 16),
                              GameActionCard(
                                onTap: canPlay
                                    ? () {
                                        final newPosition =
                                            player.nextPosition(CellColor.red);
                                        final newBoard = status.board
                                            .applyColor(newPosition.x,
                                                newPosition.y, CellColor.red);
                                        FirestoreRef.gameSessionStatusDoc(
                                                widget.gameId)
                                            .update({
                                          playerTag: newPosition.toJson(),
                                          'board': newBoard.toJson(),
                                        });
                                      }
                                    : null,
                                asset: 'assets/turn_right.png',
                              ),*/
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
