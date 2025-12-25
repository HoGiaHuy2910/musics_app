import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/song.dart';

class SongRepository {
  final _db = FirebaseFirestore.instance;

  Stream<List<Song>> getSongs() {
    return _db.collection('songs').snapshots().map(
          (snapshot) {
        return snapshot.docs
            .map((doc) => Song.fromFirestore(doc))
            .toList();
      },
    );
  }
}
