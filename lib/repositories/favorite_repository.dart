import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteRepository {
  final _db = FirebaseFirestore.instance;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  DocumentReference get _ref =>
      _db.collection('users').doc(_uid);

  // ===== SONGS =====
  Stream<Set<String>> favoriteSongsStream() {
    return _ref.snapshots().map((doc) {
      final data = doc.data() as Map<String, dynamic>? ?? {};
      return Set<String>.from(data['favoriteSongs'] ?? []);
    });
  }

  Future<void> toggleFavoriteSong(String songId) async {
    await _db.runTransaction((tx) async {
      final snap = await tx.get(_ref);
      final data = snap.data() as Map<String, dynamic>? ?? {};
      final List<String> favs =
      List<String>.from(data['favoriteSongs'] ?? []);

      if (favs.contains(songId)) {
        favs.remove(songId);
      } else {
        favs.add(songId);
      }

      tx.update(_ref, {'favoriteSongs': favs});
    });
  }

  // ===== ALBUMS =====
  Stream<Set<String>> favoriteAlbumsStream() {
    return _ref.snapshots().map((doc) {
      final data = doc.data() as Map<String, dynamic>? ?? {};
      return Set<String>.from(data['favoriteAlbums'] ?? []);
    });
  }

  Future<void> toggleFavoriteAlbum(String albumId) async {
    await _db.runTransaction((tx) async {
      final snap = await tx.get(_ref);
      final data = snap.data() as Map<String, dynamic>? ?? {};
      final List<String> favs =
      List<String>.from(data['favoriteAlbums'] ?? []);

      if (favs.contains(albumId)) {
        favs.remove(albumId);
      } else {
        favs.add(albumId);
      }

      tx.update(_ref, {'favoriteAlbums': favs});
    });
  }
}
