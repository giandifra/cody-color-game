import 'package:codyroby_game/home/create_game_session_dialog.dart';
import 'package:codyroby_game/home/create_user_dialog.dart';
import 'package:codyroby_game/home/generic_button.dart';
import 'package:codyroby_game/match_making/ui/match_making.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to CodyColor Game',
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    ?.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 64),
              if (gameUser == null)
                GenericButton(
                  color: Colors.pink,
                  onTap: () async {
                    final user = await showDialog(
                      context: context,
                      builder: (c) {
                        return const Dialog(
                          child: CreateUserDialog(),
                        );
                      },
                    );
                    if (user != null) {
                      setState(() {});
                    }
                  },
                  text: 'Registrati',
                )
              else
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        gameUser!.name,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline4?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                      Text(
                        gameUser!.userId,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ],
                  ),
                ),
              GenericButton(
                color: Colors.yellow,
                enabled: gameUser != null,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (c) {
                      return const Dialog(
                        child: CreateGameSessionDialog(),
                      );
                    },
                  );
                },
                text: 'Crea una partita',
              ),
              GenericButton(
                onTap: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (c) {
                        return const MatchMakingScreen();
                      },
                    ),
                  );
                },
                text: 'Trova partita',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
