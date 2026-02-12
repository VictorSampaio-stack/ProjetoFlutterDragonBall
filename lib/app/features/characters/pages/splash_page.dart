import 'package:dragon_ball_app/app/features/characters/pages/tabs_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  double progress = 0;

  @override
  void initState() {
    super.initState();
    startLoading();
  }

  void startLoading() {
    Timer.periodic(const Duration(milliseconds: 45), (timer) {
      setState(() {
        progress += 0.01;
      });

      if (progress >= 1) {
        timer.cancel();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TabsPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// IMAGEM DE FUNDO
          SizedBox.expand(
            child: Image.asset('assets/splash.png', fit: BoxFit.cover),
          ),

          /// BARRA DE PROGRESSO
          Positioned(
            bottom: 180,
            left: 40,
            right: 40,
            child: Column(
              children: [
                Text(
                  "${(progress * 100).toInt()}%",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 8),

                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 14,
                    backgroundColor: Colors.black54,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
