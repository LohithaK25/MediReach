import 'package:flutter/material.dart';
import '../models/medicine_model.dart';
import '../services/ai_service.dart';
import '../widgets/alternative_tile.dart';
import 'reservation_screen.dart';

class MedicineDetailsScreen extends StatefulWidget {
  final Medicine medicine;
  final double latitude;
  final double longitude;

  const MedicineDetailsScreen({Key? key, required this.medicine, required this.latitude, required this.longitude}) : super(key: key);

  @override
  _MedicineDetailsScreenState createState() => _MedicineDetailsScreenState();
}

class _MedicineDetailsScreenState extends State<MedicineDetailsScreen> {
  late Medicine med;
  List<Medicine> alternatives = [];
  bool loadingAlternatives = true;

  @override
  void initState() {
    super.initState();
    med = widget.medicine;
    fetchAlternatives();
  }

  void fetchAlternatives() async {
    try {
      alternatives = await AIService.getEnhancedAlternatives(med, userLat: widget.latitude, userLng: widget.longitude);
    } catch (e) {
      print("Error fetching alternatives: $e");
    } finally {
      setState(() => loadingAlternatives = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(med.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Composition: ${med.composition}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            const Text("Available Brands:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

            ...med.brands.map((b) {
              final brandName = b['brandName'] ?? "Unknown";
              final stock = b['stock'] ?? 0;
              final pharmacyId = b['pharmacyId'] ?? "";

              return Card(
                child: ListTile(
                  title: Text(brandName),
                  subtitle: Text("Price: ₹${b['price']} | Stock: $stock"),
                  trailing: ElevatedButton(
                    onPressed: stock > 0
                        ? () async {
                            final success = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ReservationScreen(
                                  medicine: med,
                                  brandName: brandName,
                                  pharmacyId: pharmacyId,
                                  availableStock: stock,
                                ),
                              ),
                            );

                            if (success == true) {
                              //Show confirmation
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("$brandName reserved successfully!")),
                              );
                            }
                          }
                        : null,
                    child: const Text("Reserve"),
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 20),
            const Text("Alternative Brands (Same Composition):", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            loadingAlternatives
                ? const Center(child: CircularProgressIndicator())
                : alternatives.isEmpty
                    ? const Text("No alternatives available.")
                    : Column(
                        children: alternatives
                            .map((altMed) => AlternativeTile(
                                  medicine: altMed,
                                  latitude: widget.latitude,
                                  longitude: widget.longitude,
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => MedicineDetailsScreen(
                                          medicine: altMed,
                                          latitude: widget.latitude,
                                          longitude: widget.longitude,
                                        ),
                                      ),
                                    );
                                  },
                                ))
                            .toList(),
                      ),
          ],
        ),
      ),
    );
  }
}
