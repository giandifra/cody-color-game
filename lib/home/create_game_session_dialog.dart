import 'package:codyroby_game/firestore_ref.dart';
import 'package:codyroby_game/game/models/game_status.dart';
import 'package:codyroby_game/home/generic_button.dart';
import 'package:codyroby_game/main.dart';
import 'package:codyroby_game/match_making/models/game_session.dart';
import 'package:flutter/material.dart';

class CreateGameSessionDialog extends StatefulWidget {
  const CreateGameSessionDialog({Key? key}) : super(key: key);

  @override
  State<CreateGameSessionDialog> createState() =>
      _CreateGameSessionDialogState();
}

class _CreateGameSessionDialogState extends State<CreateGameSessionDialog> {
  final matchNameController = TextEditingController();

  @override
  void dispose() {
    matchNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(
        maxWidth: 500,
        maxHeight: 500,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Nuova partita',),
          const SizedBox(height: 16),
          TextField(
            controller: matchNameController,
            decoration:
                const InputDecoration(hintText: 'Digita il nome della partita'),
          ),
          const SizedBox(height: 24),
          Center(
            child: GenericButton(
              onTap: () async {
                try {
                  print('start creation ');
                  final name = matchNameController.text.trim();

                  final gameSession = GameSession(
                    createdAt: DateTime.now(),
                    name: name,
                    p1: gameUser!,
                  );

                  final docRef =
                      await FirestoreRef.gameSessionsCollection.add(gameSession);

                  print('game created ');
                  await FirestoreRef.gameSessionStatusDoc(docRef.id)
                      .set(GameStatus.initialGame(docRef.id));

                  print('setup complete');
                  Navigator.of(context).pop();
                } catch (ex) {
                  print(ex);
                }
              },
              text: 'CREA',
            ),
          ),
        ],
      ),
    );
  }
}
