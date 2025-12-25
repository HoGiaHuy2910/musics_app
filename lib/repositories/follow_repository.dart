import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FollowRepository {
  final _db = FirebaseFirestore.instance;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  DocumentReference get _ref =>
      _db.collection('users').doc(_uid);

  /// Stream danh sách artistId đã follow
  Stream<Set<String>> followingArtistsStream() {
    return _ref.snapshots().map((doc) {
      final data = doc.data() as Map<String, dynamic>? ?? {};
      return Set<String>.from(data['followingArtists'] ?? []);
    });
  }

  /// Toggle follow / unfollow
  Future<void> toggleFollowArtist(String artistId) async {
    await _db.runTransaction((tx) async {
      final snap = await tx.get(_ref);
      final data = snap.data() as Map<String, dynamic>? ?? {};
      final List<String> list =
      List<String>.from(data['followingArtists'] ?? []);

      if (list.contains(artistId)) {
        list.remove(artistId);
      } else {
        list.add(artistId);
      }

      tx.update(_ref, {'followingArtists': list});
    });
  }
}
