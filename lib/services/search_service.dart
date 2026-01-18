import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/medicine_model.dart';

class SearchService {
  static Future<List<Medicine>> searchMedicines(String query) async {
    String qLower = query.toLowerCase().trim();

    var snapshot = await FirebaseFirestore.instance.collection('medicines').get();
    List<Medicine> results = [];

    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      
      // Get name and convert to lowercase
      String name = (data['name'] ?? "").toString().toLowerCase().trim();
      
      // Get brands and join them
      String brandList = "";
      if (data['brands'] != null && data['brands'] is List) {
        brandList = (data['brands'] as List)
            .map((b) {
              if (b is Map && b.containsKey('brandName')) {
                return b['brandName'].toString();
              }
              return "";
            })
            .join(" ")
            .toLowerCase()
            .trim();
      }
      
      // Get composition
      String composition = (data['composition'] ?? "").toString().toLowerCase().trim();

      print("Checking: name='$name', brands='$brandList', composition='$composition' against query='$qLower'");

      if (name.contains(qLower) || brandList.contains(qLower) || composition.contains(qLower)) {
        print("Match found for: ${data['name']}");
        results.add(Medicine.fromMap(doc.id, data));
      }
    }

    print("Search results count: ${results.length}");
    return results;
  }
}
