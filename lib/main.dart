import 'package:dragon_ball_app/app/controllers/character_controller.dart';
import 'package:flutter/material.dart';
import 'app/features/characters/pages/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CharacterController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dragon Ball App',
      home: const HomePage(),
    );
  }
}
