import 'package:flutter/material.dart';
import '../models/medicine_model.dart';

class MedicineCard extends StatelessWidget {
  final Medicine medicine;

  MedicineCard({required this.medicine});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(medicine.name),
      subtitle: Text("Composition: ${medicine.composition}"),
      trailing: Text("Brands: ${medicine.brands.length}"),
    );
  }
}
