import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codyroby_game/app.dart';
import 'package:codyroby_game/firebase_options.dart';
import 'package:codyroby_game/match_making/models/game_user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

GameUser? gameUser;

// fvm flutter build web --web-renderer canvaskit
// firebase deploy --only hosting
// firebase deploy --only functions:userSignUp-requestGroupCard
// firebase hosting:channel:deploy preview_name
// fvm flutter build apk
// firebase emulators:start --import=./emulator_backup --export-on-exit
// lsof -i tcp:8082

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: false,
  );
  runApp(const CodyRobyGameApp());
}
