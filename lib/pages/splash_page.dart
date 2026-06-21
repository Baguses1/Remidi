import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'main_navigation.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSession();
    });
  }

  _checkSession() async {
    try {
      final prefs = await SharedPreferences.getInstance().timeout(const Duration(seconds: 2));
      final bool? isLoggedIn = prefs.getBool('isLoggedIn');
      final User? user = FirebaseAuth.instance.currentUser;

      if (isLoggedIn == true && user != null) {
        _navigateTo(const MainNavigation());
      } else {
        _navigateTo(const LoginPage());
      }
    } catch (e) {
      // Jika Firebase/Chrome bermasalah, paksa langsung pindah ke LoginPage setelah 2 detik
      debugPrint("Firebase Web dinonaktifkan, dialihkan: $e");
      _navigateTo(const LoginPage());
    }
  }

  void _navigateTo(Widget page) {
    if (!mounted) return;
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.deepPurple, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rocket_launch_rounded, size: 80, color: Colors.white),
            SizedBox(height: 24),
            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
          ],
        ),
      ),
    );
  }
}