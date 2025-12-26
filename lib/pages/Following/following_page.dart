import 'package:flutter/material.dart';
import '../../controllers/playlist_controller.dart';
import '../../controllers/audio_controller.dart';
import '../../models/song.dart';
import '../../repositories/song_repository.dart';
import '../Play/now_playing_page.dart';
import '../AlbumDetail/album_detail_page.dart';

class FollowingPage extends StatelessWidget {
  const FollowingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final playlist = PlaylistController.instance;
    final audio = AudioController.instance;
    final songRepo = SongRepository();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Following',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28, // 🔥 to hơn
          ),
        ),
      ),
      body: ValueListenableBuilder<Set<String>>(
        valueListenable: playlist.followingArtists,
        builder: (context, followingArtists, _) {
          if (followingArtists.isEmpty) {
            return const Center(
              child: Text(
                'Bạn chưa theo dõi nghệ sĩ nào',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return StreamBuilder<List<Song>>(
            stream: songRepo.allSongsStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final allSongs = snapshot.data!;

              // 🔥 GROUP SONG THEO ARTIST ĐÃ FOLLOW
              final Map<String, List<Song>> artistMap = {};

              for (final s in allSongs) {
                if (followingArtists.contains(s.artist)) {
                  artistMap.putIfAbsent(s.artist, () => []);
                  artistMap[s.artist]!.add(s);
                }
              }

              if (artistMap.isEmpty) {
                return const Center(
                  child: Text('Chưa có bài hát từ nghệ sĩ đã theo dõi'),
                );
              }

              return ListView(
                padding: const EdgeInsets.only(bottom: 90),
                children: artistMap.entries.map((entry) {
                  final artistName = entry.key;
                  final artistSongs = entry.value;

                  // Group album
                  final Map<String, List<Song>> albumMap = {};
                  for (final s in artistSongs) {
                    albumMap.putIfAbsent(s.albumId, () => []);
                    albumMap[s.albumId]!.add(s);
                  }

                  final albums = albumMap.values.toList();

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ===== ARTIST HEADER (TO HƠN) =====
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Text(
                            artistName,
                            style: const TextStyle(
                              fontSize: 22, // 🔥 to rõ
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // ===== SONGS TITLE =====
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 4, 16, 8),
                          child: Text(
                            'Songs',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),

                        // ===== TOP SONGS =====
                        SizedBox(
                          height: 160,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: artistSongs.length,
                            itemBuilder: (context, index) {
                              final song = artistSongs[index];
                              return GestureDetector(
                                onTap: () {
                                  audio.playSong(song);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          NowPlayingPage(song: song),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 120,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(12),
                                        child: Image.network(
                                          song.Songimage,
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        song.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // ===== ALBUMS =====
                        if (albums.isNotEmpty) ...[
                          const Padding(
                            padding:
                            EdgeInsets.fromLTRB(16, 12, 16, 8),
                            child: Text(
                              'Albums',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 180,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: albums.length,
                              itemBuilder: (context, index) {
                                final albumSongs = albums[index];
                                final album = albumSongs.first;

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AlbumDetailPage(
                                          albumTitle: album.albumTitle,
                                          songs: albumSongs,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 140,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(14),
                                          child: Image.network(
                                            album.Songimage,
                                            width: 140,
                                            height: 140,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          album.albumTitle,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
