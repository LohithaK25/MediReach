import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/medicine_model.dart';
import 'dart:math';

class AIService {
  // Enhanced AI Alternative Engine
  static Future<List<Medicine>> getEnhancedAlternatives(Medicine selectedMedicine, {double? userLat, double? userLng}) async {
    String targetComp = selectedMedicine.composition.toLowerCase();

    // Fetch all medicines
    var snapshot = await FirebaseFirestore.instance.collection('medicines').get();
    List<Medicine> candidates = [];

    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      String comp = (data['composition'] ?? "").toLowerCase();
      if (doc.id != selectedMedicine.id) {
        // If composition text matches or contains the active ingredient
        if (comp.contains(targetComp.split(" ")[0])) {
          candidates.add(Medicine.fromMap(doc.id, data));
        }
      }
    }

    // Rank alternatives: stock > price > distance
    candidates.sort((a, b) {
      int aStock = a.brands.isNotEmpty ? a.brands[0]['stock'] ?? 0 : 0;
      int bStock = b.brands.isNotEmpty ? b.brands[0]['stock'] ?? 0 : 0;

      int stockCompare = bStock.compareTo(aStock); // higher stock first
      if (stockCompare != 0) return stockCompare;

      double aPrice = a.brands.isNotEmpty ? a.brands[0]['price'] ?? double.infinity : double.infinity;
      double bPrice = b.brands.isNotEmpty ? b.brands[0]['price'] ?? double.infinity : double.infinity;

      int priceCompare = aPrice.compareTo(bPrice); // cheaper first
      if (priceCompare != 0) return priceCompare;

      if (userLat != null && userLng != null) {
        double aDist = _distance(userLat, userLng, a.brands[0]['lat'], a.brands[0]['lng']);
        double bDist = _distance(userLat, userLng, b.brands[0]['lat'], b.brands[0]['lng']);
        return aDist.compareTo(bDist);
      }

      return 0;
    });

    return candidates;
  }

  // Helper: calculate distance between two lat/lng points
  static double _distance(double lat1, double lng1, double lat2, double lng2) {
    const R = 6371; // km
    double dLat = _deg2rad(lat2 - lat1);
    double dLng = _deg2rad(lng2 - lng1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) * sin(dLng / 2) * sin(dLng / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  static double _deg2rad(double deg) => deg * (pi / 180);
}
