import 'package:dragon_ball_app/app/controllers/character_controller.dart';
import 'package:dragon_ball_app/app/controllers/favorites_controller.dart';
import 'package:dragon_ball_app/app/features/characters/pages/tabs_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/features/characters/pages/home_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CharacterController()),
        ChangeNotifierProvider(create: (_) => FavoritesController()),
      ],
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
      home: const TabsPage(),
    );
  }
}
