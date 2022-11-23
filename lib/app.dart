import 'package:codyroby_game/home/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CodyRobyGameApp extends StatelessWidget {
  const CodyRobyGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CodyRoby Game',
      theme: _buildTheme(Brightness.dark),
      home: const HomeScreen(),
    );
  }

  ThemeData _buildTheme(brightness) {
    var baseTheme = ThemeData(
      brightness: brightness,
      backgroundColor: Colors.black,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: AppBarTheme(backgroundColor: Colors.black),
      textTheme: TextTheme(),
    );
    return baseTheme.copyWith(
      textTheme: GoogleFonts.permanentMarkerTextTheme(baseTheme.textTheme),
    );
  }
}
