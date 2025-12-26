import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Playlist/playlist_detail_page.dart';

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
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: playlistRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // ===== EMPTY STATE =====
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.queue_music,
                      size: 72,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Chưa có playlist nào',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Tạo playlist để lưu những bài hát bạn yêu thích',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          // ===== PLAYLIST LIST =====
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final songCount =
                  (data['songs'] as List?)?.length ?? 0;

              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlaylistDetailPage(
                        playlistId: doc.id,
                        playlistName: data['name'],
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      // 🎵 ICON
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: Colors.amberAccent.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.queue_music,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(width: 14),

                      // 📄 INFO
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['name'] ?? 'Untitled',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$songCount bài hát',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      // ===== CREATE PLAYLIST FAB =====
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text(
          'New playlist',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          _showCreateDialog(context);
        },
      ),
    );
  }

  // ================= CREATE PLAYLIST DIALOG =================
  void _showCreateDialog(BuildContext context) {
    final ctrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            'Create playlist',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: ctrl,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Playlist name',
              border: OutlineInputBorder(),
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
                  'songs': [],
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
