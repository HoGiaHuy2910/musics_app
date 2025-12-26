import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/song.dart';

class SongRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// 🔥 HÀM GỐC – đang được dùng ở các nơi khác
  Stream<List<Song>> getSongs() {
    return _db.collection('songs').snapshots().map(
          (snapshot) {
        return snapshot.docs
            .map((doc) => Song.fromFirestore(doc))
            .toList();
      },
    );
  }

  /// 🔁 ALIAS – dùng cho Following Page (KHÔNG lặp logic)
  Stream<List<Song>> allSongsStream() {
    return getSongs();
  }
}
