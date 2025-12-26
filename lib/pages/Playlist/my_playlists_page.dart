import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyPlaylistsPage extends StatelessWidget {
  const MyPlaylistsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No user')),
      );
    }

    final playlistRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('playlists')
        .orderBy('createdAt', descending: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My playlists',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: playlistRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Bạn chưa có playlist nào',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 90),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return ListTile(
                leading: const Icon(Icons.queue_music),
                title: Text(
                  data['name'] ?? 'Untitled',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${(data['songIds'] as List?)?.length ?? 0} bài hát',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Chi tiết playlist sẽ làm sau'),
                    ),
                  );
                },
              );
            },
          );
        },
      ),

      // ===== CREATE PLAYLIST BUTTON =====
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showCreateDialog(context);
        },
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    final ctrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Create playlist'),
          content: TextField(
            controller: ctrl,
            decoration: const InputDecoration(
              labelText: 'Playlist name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser!;
                final name = ctrl.text.trim();
                if (name.isEmpty) return;

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .collection('playlists')
                    .add({
                  'name': name,
                  'songIds': [],
                  'createdAt': FieldValue.serverTimestamp(),
                });

                Navigator.pop(context);
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
}
