import 'package:flutter/material.dart';
import '../models/medicine_model.dart';
import '../services/auth_service.dart';
import '../services/reservation_service.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReservationScreen extends StatefulWidget {
  final Medicine medicine;
  final String brandName;
  final String pharmacyId;
  final int availableStock;

  const ReservationScreen({
    Key? key,
    required this.medicine,
    required this.brandName,
    required this.pharmacyId,
    required this.availableStock,
  }) : super(key: key);

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  int quantity = 1;
  bool loading = false;
  String? error;

  void reserve() async {
    User? user = AuthService.currentUser;

    // If not logged in, navigate to login screen first
    if (user == null) {
      final loggedIn = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );

      if (loggedIn != true) return; // User did not log in
      user = AuthService.currentUser;
      if (user == null) {
        setState(() => error = "Login required to reserve.");
        return;
      }
    }

    if (quantity > widget.availableStock) {
      setState(() => error = "Cannot reserve more than available stock.");
      return;
    }

    setState(() {
      loading = true;
      error = null;
    });

    try {
      await ReservationService.reserveMedicine(
        userId: user.uid,
        medicineId: widget.medicine.id,
        brandName: widget.brandName,
        quantity: quantity,
        pharmacyId: widget.pharmacyId,
      );

      Navigator.pop(context, true); // Reservation successful
    } catch (e) {
      setState(() => error = e.toString());
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reserve ${widget.medicine.name}")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Brand: ${widget.brandName}"),
            Text("Available Quantity: ${widget.availableStock}"),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text("Quantity: "),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (quantity > 1) setState(() => quantity--);
                  },
                ),
                Text("$quantity"),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (quantity < widget.availableStock) setState(() => quantity++);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            loading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: reserve,
                    child: const Text("Reserve"),
                  ),
          ],
        ),
      ),
    );
  }
}
