import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  final String Songid;
  final String title;
  final String artist;
  final String artistImage;
  final String albumId;
  final String albumTitle;
  final String Songimage;
  final String audioNetwork;

  Song({
    required this.Songid,
    required this.title,
    required this.artist,
    required this.artistImage,
    required this.albumId,
    required this.albumTitle,
    required this.Songimage,
    required this.audioNetwork,
  });

  factory Song.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Song(
      Songid: doc.id,
      title: data['title'],
      artist: data['artist'],
      artistImage: data['artistImage'],
      albumId: data['albumId'],
      albumTitle: data['albumTitle'],
      Songimage: data['songImage'],
      audioNetwork: data['audioUrl'],
    );
  }
}
