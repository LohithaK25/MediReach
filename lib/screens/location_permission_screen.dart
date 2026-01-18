import 'package:flutter/material.dart';
import '../services/location_service.dart';
import 'home_screen.dart';
import '../widgets/loading_widget.dart';

class LocationPermissionScreen extends StatefulWidget {
  @override
  _LocationPermissionScreenState createState() => _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen> {
  bool loading = false;

  void requestLocation() async {
    setState(() => loading = true);
    var pos = await LocationService.getCurrentPosition();
    setState(() => loading = false);
    if (pos != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(latitude: pos.latitude, longitude: pos.longitude)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Location permission denied")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? LoadingWidget(message: "Fetching location...")
          : Center(
              child: ElevatedButton(
                onPressed: requestLocation,
                child: Text("Allow Location Access"),
              ),
            ),
    );
  }
}
