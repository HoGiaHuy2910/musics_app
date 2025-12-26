import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PlaylistRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 🔑 GET UID (an toàn)
  String get _uid {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    return user.uid;
  }

  /// =========================
  /// 📌 CREATE PLAYLIST
  /// =========================
  Future<void> createPlaylist(String name) async {
    final ref = _db
        .collection('users')
        .doc(_uid)
        .collection('playlists')
        .doc();

    await ref.set({
      'name': name,
      'createdAt': FieldValue.serverTimestamp(),
      'songs': <String>[],
    });
  }

  /// =========================
  /// 📌 GET PLAYLISTS STREAM
  /// =========================
  Stream<QuerySnapshot> playlistsStream() {
    return _db
        .collection('users')
        .doc(_uid)
        .collection('playlists')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// =========================
  /// 📌 ADD SONG TO PLAYLIST
  /// =========================
  Future<void> addSongToPlaylist({
    required String playlistId,
    required String songId,
  }) async {
    await _db
        .collection('users')
        .doc(_uid)
        .collection('playlists')
        .doc(playlistId)
        .update({
      'songs': FieldValue.arrayUnion([songId]),
    });
  }

  /// =========================
  /// 📌 REMOVE SONG FROM PLAYLIST
  /// =========================
  Future<void> removeSongFromPlaylist({
    required String playlistId,
    required String songId,
  }) async {
    await _db
        .collection('users')
        .doc(_uid)
        .collection('playlists')
        .doc(playlistId)
        .update({
      'songs': FieldValue.arrayRemove([songId]),
    });
  }

  /// =========================
  /// 📌 DELETE PLAYLIST
  /// =========================
  Future<void> deletePlaylist(String playlistId) async {
    await _db
        .collection('users')
        .doc(_uid)
        .collection('playlists')
        .doc(playlistId)
        .delete();
  }

  /// =========================
  /// 📌 RENAME PLAYLIST
  /// =========================
  Future<void> renamePlaylist({
    required String playlistId,
    required String newName,
  }) async {
    await _db
        .collection('users')
        .doc(_uid)
        .collection('playlists')
        .doc(playlistId)
        .update({
      'name': newName,
    });
  }
}
