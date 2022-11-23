import 'package:codyroby_game/game/models/player_position.dart';
import 'package:flutter/material.dart';

class RedRoby extends StatelessWidget {
  final RobyRotation rotation;

  const RedRoby({Key? key, required this.rotation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: rotation.index,
      child: Image.asset('assets/red_roby.png'),
    );
  }
}

class GreenRoby extends StatelessWidget {
  final RobyRotation rotation;

  const GreenRoby({Key? key, required this.rotation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: rotation.index,
      child: Image.asset('assets/green_roby.png'),
    );
  }
}
