import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/watchlist_service.dart';
import '../models/medicine_model.dart';
import '../services/ai_service.dart';
import '../widgets/alternative_tile.dart';
import '../services/stock_service.dart';

class WatchlistScreen extends StatefulWidget {
  @override
  _WatchlistScreenState createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Watchlist")),
      body: StreamBuilder<QuerySnapshot>(
        stream: WatchlistService.getWatchlist(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          var watchlistDocs = snapshot.data!.docs;
          if (watchlistDocs.isEmpty) return Center(child: Text("No medicines in watchlist"));

          return ListView.builder(
            itemCount: watchlistDocs.length,
            itemBuilder: (context, index) {
              var doc = watchlistDocs[index];
              String medicineId = doc.id;

              return StreamBuilder<DocumentSnapshot>(
                stream: StockService.getMedicineStock(medicineId),
                builder: (context, medSnapshot) {
                  if (!medSnapshot.hasData) return Container();
                  var data = medSnapshot.data!.data() as Map<String, dynamic>;
                  final med = Medicine.fromMap(medSnapshot.data!.id, data);

                  // Check low stock for first brand
                  final firstBrand = med.brands.isNotEmpty ? med.brands[0] : null;
                  bool lowStock = firstBrand != null && (firstBrand['stock'] ?? 0) < 5;

                  if (lowStock) {
                    // Trigger notification
                    // Make sure NotificationService.init() is called in main.dart
                    // NotificationService.sendLowStockNotification(med.name);
                  }

                  return ListTile(
                    title: Text(med.name),
                    subtitle: firstBrand != null
                        ? Text("Brand: ${firstBrand['brandName']} | Stock: ${firstBrand['stock']}")
                        : null,
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => WatchlistService.removeFromWatchlist(med.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
