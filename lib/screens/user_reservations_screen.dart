import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../services/reservation_service.dart';
import 'login_screen.dart';

class UserReservationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;

    if (user == null) {
      return Center(
        child: ElevatedButton(
          child: const Text("Login to view reservations"),
          onPressed: () async {
            final loggedIn = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => LoginScreen()),
            );
            if (loggedIn == true) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => UserReservationsScreen()),
              );
            }
          },
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: ReservationService.getUserReservations(user.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final reservations = snapshot.data!.docs;
        if (reservations.isEmpty) return const Center(child: Text("No reservations yet."));

        return ListView.builder(
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            final res = reservations[index].data() as Map<String, dynamic>;
            return ListTile(
              title: Text("${res['brandName']}"),
              subtitle: Text("Quantity: ${res['quantity']} | Status: ${res['status']}"),
              trailing: Text(res['timestamp'] != null
                  ? (res['timestamp'] as Timestamp).toDate().toLocal().toString()
                  : ""),
            );
          },
        );
      },
    );
  }
}
