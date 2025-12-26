import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../repositories/playlist_repository.dart';

class AddToPlaylistSheet extends StatelessWidget {
  final String songId;

  const AddToPlaylistSheet({super.key, required this.songId});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final repo = PlaylistRepository();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('playlists')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Text('Bạn chưa có playlist'),
          );
        }

        return ListView(
          shrinkWrap: true,
          children: snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;

            return ListTile(
              title: Text(data['name']),
              trailing: const Icon(Icons.add),
              onTap: () async {
                await repo.addSongToPlaylist(
                  playlistId: doc.id,
                  songId: songId,
                );
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }
}
