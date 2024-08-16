import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seen/constanc.dart';
import 'package:seen/screens/home/page/home.dart';
import 'package:seen/screens/welcome_page.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});
  static String id = 'Splash';

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      _opacity = 1.0;
      setState(() {});
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacementNamed(
          context,
          Home.id,
        );
      } else {
        Navigator.pushReplacementNamed(
          context,
          WelcomePage.id,
        );
      }
    });
  }

  double _opacity = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.5,
            colors: [Color(0xFFcb0ae8), Color(0xFF3c00ff)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 600,
              height: 240,
              child: Image.asset('assets/icons/logo_without_background.png'),
            ),
            AnimatedOpacity(
              duration: const Duration(seconds: 1),
              opacity: _opacity,
              child: Text(
                'من غير ما حد يفهم',
                style: TextStyle(color: Constanc.kColorWhite, fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
