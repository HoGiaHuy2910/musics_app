import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/song.dart';
import '../../repositories/song_repository.dart';
import '../../repositories/playlist_repository.dart';
import '../../controllers/audio_controller.dart';
import '../../controllers/playlist_controller.dart';
import '../Play/now_playing_page.dart';

class PlaylistDetailPage extends StatelessWidget {
  final String playlistId;
  final String playlistName;

  const PlaylistDetailPage({
    super.key,
    required this.playlistId,
    required this.playlistName,
  });

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final songRepo = SongRepository();
    final playlistRepo = PlaylistRepository();
    final audio = AudioController.instance;
    final playlistController = PlaylistController.instance;

    final playlistDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('playlists')
        .doc(playlistId);

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: playlistDoc.snapshots(),
        builder: (context, playlistSnap) {
          if (!playlistSnap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = playlistSnap.data!.data() as Map<String, dynamic>;
          final List songIds = data['songs'] ?? [];

          return StreamBuilder<List<Song>>(
            stream: songRepo.getSongs(),
            builder: (context, songSnap) {
              if (!songSnap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final allSongs = songSnap.data!;
              final playlistSongs =
              allSongs.where((s) => songIds.contains(s.Songid)).toList();

              return CustomScrollView(
                slivers: [
                  // ===== HEADER =====
                  SliverAppBar(
                    expandedHeight: 220,
                    pinned: true,
                    backgroundColor: Colors.black,
                    iconTheme: const IconThemeData(color: Colors.white),
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        playlistName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          playlistSongs.isNotEmpty
                              ? Image.network(
                            playlistSongs.first.Songimage,
                            fit: BoxFit.cover,
                          )
                              : Container(color: Colors.grey.shade800),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.85),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ===== PLAY BUTTONS =====
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amberAccent,
                                foregroundColor: Colors.black,
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              icon: const Icon(Icons.play_arrow),
                              label: const Text(
                                'Play all',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              onPressed: playlistSongs.isEmpty
                                  ? null
                                  : () {
                                playlistController.playlist.value =
                                    playlistSongs;
                                audio.playSong(
                                    playlistSongs.first);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        NowPlayingPage(
                                          song: playlistSongs.first,
                                        ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.amber,
                                side: const BorderSide(
                                  color: Colors.amber,
                                  width: 1.5,
                                ),
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              icon: const Icon(Icons.shuffle),
                              label: const Text(
                                'Shuffle',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              onPressed: playlistSongs.isEmpty
                                  ? null
                                  : () {
                                final list = [...playlistSongs]
                                  ..shuffle();
                                playlistController.playlist.value = list;
                                audio.playSong(list.first);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        NowPlayingPage(
                                          song: list.first,
                                        ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ===== EMPTY STATE =====
                  if (playlistSongs.isEmpty)
                    const SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.queue_music,
                                size: 64, color: Colors.grey),
                            SizedBox(height: 12),
                            Text(
                              'Playlist chưa có bài hát nào',
                              style:
                              TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // ===== SONG LIST =====
                  if (playlistSongs.isNotEmpty)
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final song = playlistSongs[index];
                          final isPlaying =
                              audio.currentSong.value?.Songid ==
                                  song.Songid;

                          return ListTile(
                            leading: Stack(
                              alignment: Alignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    song.Songimage,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                if (isPlaying)
                                  const Icon(Icons.equalizer,
                                      color: Colors.amberAccent, size: 26),
                              ],
                            ),
                            title: Text(
                              song.title,
                              style: TextStyle(
                                fontWeight: isPlaying
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            subtitle: Text(song.artist),

                            trailing: PopupMenuButton<String>(
                              onSelected: (value) async {
                                if (value == 'remove') {
                                  await playlistRepo
                                      .removeSongFromPlaylist(
                                    playlistId: playlistId,
                                    songId: song.Songid,
                                  );
                                }
                              },
                              itemBuilder: (_) =>
                              const [
                                PopupMenuItem(
                                  value: 'remove',
                                  child: Text('Remove from playlist'),
                                ),
                              ],
                            ),

                            onTap: () {
                              playlistController.ensureInPlaylist(song);
                              audio.playSong(song);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      NowPlayingPage(song: song),
                                ),
                              );
                            },
                          );
                        },
                        childCount: playlistSongs.length,
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}