import 'package:cloud_firestore/cloud_firestore.dart';

class StockService {
  static Stream<DocumentSnapshot> getMedicineStock(String medicineId) {
    return FirebaseFirestore.instance
        .collection('medicines')
        .doc(medicineId)
        .snapshots();
  }

  static Stream<QuerySnapshot> getAllMedicines() {
    return FirebaseFirestore.instance.collection('medicines').snapshots();
  }
}
