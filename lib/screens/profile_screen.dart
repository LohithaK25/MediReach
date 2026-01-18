import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../services/reservation_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;

    // If user is not logged in
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Profile")),
        body: Center(
          child: ElevatedButton(
            child: const Text("Login to view profile"),
            onPressed: () async {
              final loggedIn = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );

              // After successful login, rebuild the profile page
              if (loggedIn == true) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              }
            },
          ),
        ),
      );
    }

    // User is logged in, show profile + reservations
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(user.displayName ?? "Name"),
            subtitle: Text(user.email ?? ""),
            trailing: IconButton(
              icon: const Icon(Icons.logout),
              tooltip: "Logout",
              onPressed: () async {
                await AuthService.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
            ),
          ),
          const Divider(),

          // Reservations header
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Your Reservations:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),

          // Expanded list of reservations
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: ReservationService.getUserReservations(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No reservations yet."));
                }

                final reservations = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: reservations.length,
                  itemBuilder: (context, index) {
                    final res = reservations[index].data() as Map<String, dynamic>;
                    final timestamp = res['timestamp'] as Timestamp?;
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        title: Text("${res['brandName']}"),
                        subtitle: Text("Quantity: ${res['quantity']} | Status: ${res['status']}"),
                        trailing: timestamp != null
                            ? Text(timestamp.toDate().toLocal().toString())
                            : null,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
