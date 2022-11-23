import 'package:codyroby_game/firestore_ref.dart';
import 'package:codyroby_game/game/models/game_status.dart';
import 'package:codyroby_game/game/ui/game.dart';
import 'package:codyroby_game/main.dart';
import 'package:codyroby_game/match_making/models/game_session.dart';
import 'package:flutter/material.dart';

class SessionTile extends StatelessWidget {
  // final Function() onTap;
  final GameSession session;
  final String gameId;

  const SessionTile(
      {Key? key,
      // required this.onTap,
      required this.session,
      required this.gameId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () async {
          final amISignedIn = gameUser != null;
          if (!amISignedIn) {
            return;
          }

          final amIOwner = gameUser!.userId == session.p1.userId;
          final amIPlayerTwo = gameUser!.userId == session.p2?.userId;
          final isPlayerTwoFree = session.p2 == null;
          final canTap =
              amISignedIn && (amIOwner || isPlayerTwoFree || amIPlayerTwo);

          if (!canTap) {
            return;
          }
          final navigator = Navigator.of(context);

          if (!amIOwner && isPlayerTwoFree) {
            await FirestoreRef.gameSessionsCollection.doc(gameId).update({
              Player.p2.name: gameUser!.toJson(),
            });
          }

          navigator.push(
            MaterialPageRoute(
              builder: (context) {
                return GameScreen(
                  gameId: gameId,
                  gameName: session.name,
                );
              },
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.yellow, width: 2)),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      session.name,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 32),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        session.p1.name,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(color: Colors.green),
                      ),
                      const Icon(
                        Icons.flash_on,
                        color: Colors.yellow,
                      ),
                      Text(
                        session.p2?.name ?? '-',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
