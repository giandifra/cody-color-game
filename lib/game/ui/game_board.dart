import 'package:codyroby_game/game/models/game_status.dart';
import 'package:codyroby_game/game/ui/roby.dart';
import 'package:codyroby_game/home/generic_button.dart';
import 'package:flutter/material.dart';

import '../../match_making/models/game_session.dart';

class GameBoard extends StatefulWidget {
  final GameSession session;
  final GameStatus status;
  final Player player;

  const GameBoard({
    Key? key,
    required this.status,
    required this.session,
    required this.player,
  }) : super(key: key);

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  final rows = 5;
  final columns = 5;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 25,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                  ),
                  itemBuilder: (c, index) {
                    final row = index % 5;
                    final column = index ~/ 5;
                    final color = widget.status.board.board[column][row].color;
                    return Container(
                      decoration: BoxDecoration(
                        color: color,
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      child: widget.status.p1?.x == row &&
                              widget.status.p1?.y == column
                          ? GreenRoby(rotation: widget.status.p1!.rotation)
                          : widget.status.p2?.x == row &&
                                  widget.status.p2?.y == column
                              ? RedRoby(rotation: widget.status.p2!.rotation)
                              : null,
                    );
                  },
                ),
                if (widget.session.p2 == null)
                  Center(
                    child: Container(
                      color: Colors.red.withOpacity(0.5),
                      constraints:
                          const BoxConstraints(maxWidth: 400, maxHeight: 200),
                      child: Text(
                        'In attesa del secondo giocatore',
                        style: Theme.of(context).textTheme.headline4,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else if (widget.status.winner != null)
                  Center(
                    child: Container(
                      color: Colors.blue.withOpacity(0.5),
                      constraints:
                          const BoxConstraints(maxWidth: 400, maxHeight: 200),
                      child: Text(
                        widget.status.winner == widget.player ? 'Hai vinto' : 'Hai perso',
                        style: Theme.of(context).textTheme.headline4,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else if (widget.player != widget.status.turn)
                  Center(
                    child: Container(
                      color: Colors.red.withOpacity(0.5),
                      constraints:
                          const BoxConstraints(maxWidth: 400, maxHeight: 200),
                      child: Text(
                        'È il turno del tuo avversario',
                        style: Theme.of(context).textTheme.headline4,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else if (widget.status.hasColorOnFront(
                    widget.player == Player.p1
                        ? widget.status.p1
                        : widget.status.p2))
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.green.withOpacity(0.5),
                      constraints:
                          const BoxConstraints(maxWidth: 400, maxHeight: 200),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.wind_power,
                            size: 40,
                          ),
                          Text(
                            'Hai un colore davanti',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          GenericButton(
                            autoSizeText: true,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(color: Colors.white),
                            text: 'Auto Move',
                            color: Colors.white,
                            onTap: () {
                              widget.status.autoMove();
                            },
                          )
                        ],
                      ),
                    ),
                  )
              ],
            );
          },
        ),
      ),
    );
  }
}
