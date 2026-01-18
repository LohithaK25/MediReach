import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationService {
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> reserveMedicine({
    required String userId,
    required String medicineId,
    required String brandName,
    required int quantity,
    required String pharmacyId,
  }) async {
    // Create reservation
    await _firestore.collection('reservations').add({
      'userId': userId,
      'medicineId': medicineId,
      'brandName': brandName,
      'quantity': quantity,
      'pharmacyId': pharmacyId,
      'status': 'reserved',
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Update stock
    final medDoc = await _firestore.collection('medicines').doc(medicineId).get();
    if (medDoc.exists) {
      var data = medDoc.data()!;
      var brands = List.from(data['brands']);
      for (var b in brands) {
        if (b['brandName'] == brandName) {
          b['stock'] = (b['stock'] ?? 0) - quantity;
        }
      }
      await _firestore.collection('medicines').doc(medicineId).update({'brands': brands});
    }
  }

  static Stream<QuerySnapshot> getUserReservations(String userId) {
    return _firestore
        .collection('reservations')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
