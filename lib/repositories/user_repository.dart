import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final _db = FirebaseFirestore.instance;

  Future<void> createUserIfNotExists(User user) async {
    final ref = _db.collection('users').doc(user.uid);
    final snap = await ref.get();

    if (!snap.exists) {
      await ref.set({
        'email': user.email,
        'accImage': 'https://i.pravatar.cc/300?u=${user.uid}', // 👈 DEFAULT
        'createdAt': FieldValue.serverTimestamp(),
        'favoriteSongs': [],
        'favoriteAlbums': [],
        'followingArtists': [],
      });
    }
  }
}
