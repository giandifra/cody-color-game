import 'package:codyroby_game/home/generic_button.dart';
import 'package:codyroby_game/main.dart';
import 'package:codyroby_game/match_making/models/game_user.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CreateUserDialog extends StatefulWidget {
  const CreateUserDialog({Key? key}) : super(key: key);

  @override
  State<CreateUserDialog> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<CreateUserDialog> {
  final userNameController = TextEditingController();

  @override
  void dispose() {
    userNameController.dispose();
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
          const Text('Nuova utente'),
          const SizedBox(height: 16),
          TextField(
            controller: userNameController,
            decoration: const InputDecoration(hintText: 'Digita il tuo nome'),
          ),
          const SizedBox(height: 24),
          GenericButton(
            color: Colors.pink,
            onTap: () async {
              try {
                final username = userNameController.text.trim();

                gameUser = GameUser(
                  name: username,
                  userId: const Uuid().v1(),
                );

                Navigator.of(context).pop(gameUser);
              } catch (ex) {
                print(ex);
              }
            },
            text: 'Registrati',
          ),
        ],
      ),
    );
  }
}
