import 'package:flutter/material.dart';
import '../models/medicine_model.dart';
import '../services/stock_service.dart';

class AlternativeTile extends StatelessWidget {
  final Medicine medicine;
  final double latitude;
  final double longitude;
  final VoidCallback onTap;

  AlternativeTile({required this.medicine, required this.latitude, required this.longitude, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: StockService.getMedicineStock(medicine.id),
      builder: (context, snapshot) {
        var data = snapshot.hasData ? (snapshot.data as dynamic).data() as Map<String, dynamic> : null;
        final brands = data != null ? List.from(data['brands']) : medicine.brands;
        final firstBrand = brands.isNotEmpty ? brands[0] : null;

        return Card(
          margin: EdgeInsets.symmetric(vertical: 6),
          color: Colors.green[50],
          child: ListTile(
            title: Text(medicine.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Composition: ${medicine.composition}"),
                if (firstBrand != null)
                  Text(
                      "Brand: ${firstBrand['brandName']} | Price: ₹${firstBrand['price']} | Stock: ${firstBrand['stock']}"),
              ],
            ),
            trailing: Icon(Icons.arrow_forward),
            onTap: onTap,
          ),
        );
      },
    );
  }
}
