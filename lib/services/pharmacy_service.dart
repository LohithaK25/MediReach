import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pharmacy_model.dart';
import 'dart:math';

class PharmacyService {
  static Stream<List<Pharmacy>> getNearbyPharmacies(double userLat, double userLng, double radiusKm) {
    return FirebaseFirestore.instance.collection('pharmacies').snapshots().map((snapshot) {
      List<Pharmacy> list = snapshot.docs.map((doc) => Pharmacy.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList();

      // Filter by distance
      list = list.where((p) {
        double distance = calculateDistance(userLat, userLng, p.lat, p.lng);
        return distance <= radiusKm;
      }).toList();

      // Sort by distance
      list.sort((a, b) {
        double da = calculateDistance(userLat, userLng, a.lat, a.lng);
        double db = calculateDistance(userLat, userLng, b.lat, b.lng);
        return da.compareTo(db);
      });

      return list;
    });
  }

  static double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    var p = 0.017453292519943295; // pi/180
    var a = 0.5 - cos((lat2 - lat1) * p)/2 + 
            cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lng2 - lng1) * p))/2;
    return 12742 * asin(sqrt(a)); // 2*R*asin...
  }
}
