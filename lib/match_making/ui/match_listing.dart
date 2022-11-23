import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codyroby_game/firestore_ref.dart';
import 'package:codyroby_game/match_making/models/game_session.dart';
import 'package:codyroby_game/match_making/ui/session_tile.dart';
import 'package:flutter/material.dart';


class MatchListing extends StatelessWidget {
  MatchListing({Key? key}) : super(key: key);

  final stream = FirestoreRef.gameSessionsCollection
      .where('createdAt',
          isGreaterThan: DateTime.now().subtract(const Duration(hours: 1)))
      // .where('p2', isEqualTo: null)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<GameSession>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final list = snapshot.data?.docs ?? [];

        if (list.isEmpty) {
          return const Center(
            child: Text(
              'Non ci sono partite disponibili',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return ListView.builder(
          itemCount: list.length,
          padding: const EdgeInsets.all(16),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            final session = list[index].data();
            return SessionTile(
              session: session,
              gameId: list[index].id,
            );
            /*return Padding(
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
                  final canTap = amISignedIn &&
                      (amIOwner || isPlayerTwoFree || amIPlayerTwo);

                  if (!canTap) {
                    return;
                  }
                  final navigator = Navigator.of(context);

                  if (!amIOwner && isPlayerTwoFree) {
                    await FirestoreRef.gameSessionsCollection
                        .doc(list[index].id)
                        .update({
                      Player.p2.name: gameUser!.toJson(),
                    });
                  }

                  navigator.push(
                    MaterialPageRoute(
                      builder: (context) {
                        return GameScreen(
                          gameId: list[index].id,
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
            );*/
          },
        );
      },
    );
  }
}
