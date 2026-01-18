import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const MediReachApp());
}

class MediReachApp extends StatelessWidget {
  const MediReachApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediReach',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: SplashScreen(),
      routes: {
        '/login': (_) => LoginScreen(),
        '/profile': (_) => const ProfileScreen(),
        // ReservationScreen is pushed dynamically with arguments
      },
    );
  }
}
