import 'package:codyroby_game/game/models/player_position.dart';
import 'package:flutter/material.dart';

class GameActionCard extends StatelessWidget {
  final Function()? onTap;
  final CellColor cellColor;

  const GameActionCard({Key? key, this.onTap, required this.cellColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          color: cellColor.color,
        ),
      ),
    );
  }
}