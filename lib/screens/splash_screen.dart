import 'package:flutter/material.dart';
import '../config/firebase_config.dart';
import 'location_permission_screen.dart';
import '../widgets/loading_widget.dart';
import '../services/notification_service.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  void initializeApp() async {
    await FirebaseConfig.initializeFirebase();
    await NotificationService.initFCM(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LocationPermissionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LoadingWidget(message: "Initializing MediReach..."));
  }
}
