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
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/song.dart';
//
// class SongRepository {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//
//   /// 🔥 STREAM TOÀN BỘ SONG TỪ FIRESTORE
//   Stream<List<Song>> allSongsStream() {
//     return _db.collection('songs').snapshots().map(
//           (snapshot) {
//         return snapshot.docs.map((doc) {
//           final data = doc.data();
//
//           return Song(
//             Songid: doc.id,
//             title: data['title'] ?? '',
//             artist: data['artist'] ?? '',
//             artistImage: data['artistImage'] ?? '',
//             albumId: data['albumId'] ?? '',
//             albumTitle: data['albumTitle'] ?? '',
//             Songimage: data['Songimage'] ?? '',
//             audioNetwork: data['audioNetwork'] ?? '',
//           );
//         }).toList();
//       },
//     );
//   }
// }
