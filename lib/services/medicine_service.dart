import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/medicine_model.dart';

class MedicineService {
  static Stream<List<Medicine>> getMedicinesByPharmacy(String pharmacyId) {
    return FirebaseFirestore.instance
        .collection('medicines')
        .where('pharmacyId', isEqualTo: pharmacyId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Medicine.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }
}
