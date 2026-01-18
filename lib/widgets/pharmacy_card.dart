import 'package:flutter/material.dart';
import '../models/pharmacy_model.dart';
import '../models/medicine_model.dart';
import '../services/medicine_service.dart';
import 'medicine_card.dart';

class PharmacyCard extends StatelessWidget {
  final Pharmacy pharmacy;

  PharmacyCard({required this.pharmacy});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      elevation: 3,
      child: ExpansionTile(
        title: Text(pharmacy.name),
        subtitle: Text(pharmacy.address),
        children: [
          StreamBuilder<List<Medicine>>(
            stream: MedicineService.getMedicinesByPharmacy(pharmacy.id),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              var medicines = snapshot.data!;
              return Column(
                children: medicines.map((m) => MedicineCard(medicine: m)).toList(),
              );
            },
          )
        ],
      ),
    );
  }
}
