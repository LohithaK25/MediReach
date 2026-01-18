import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

class WatchlistService {
  static final _firestore = FirebaseFirestore.instance;

  // Add medicine to watchlist
  static Future<void> addToWatchlist(String medicineId) async {
    final user = AuthService.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('watchlist')
        .doc(medicineId)
        .set({'addedAt': FieldValue.serverTimestamp()});
  }

  // Remove from watchlist
  static Future<void> removeFromWatchlist(String medicineId) async {
    final user = AuthService.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('watchlist')
        .doc(medicineId)
        .delete();
  }

  // Stream watchlist medicines
  static Stream<QuerySnapshot> getWatchlist() {
    final user = AuthService.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('watchlist')
        .snapshots();
  }
}
