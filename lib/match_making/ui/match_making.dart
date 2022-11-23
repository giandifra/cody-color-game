import 'package:codyroby_game/match_making/ui/match_listing.dart';
import 'package:flutter/material.dart';

class MatchMakingScreen extends StatefulWidget {
  const MatchMakingScreen({Key? key}) : super(key: key);

  @override
  State<MatchMakingScreen> createState() => _MatchMakingScreenState();
}

class _MatchMakingScreenState extends State<MatchMakingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sessioni'),),
      body: MatchListing(),
    );
  }
}
