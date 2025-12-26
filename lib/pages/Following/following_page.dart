import 'package:flutter/material.dart';
import '../../controllers/playlist_controller.dart';
import '../../controllers/audio_controller.dart';
import '../../models/song.dart';
import '../../repositories/song_repository.dart';
import '../Play/now_playing_page.dart';
import '../AlbumDetail/album_detail_page.dart';

class FollowingPage extends StatefulWidget {
  const FollowingPage({super.key});

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  bool _match(String source, String keyword) {
    return source.toLowerCase().contains(keyword);
  }

  @override
  Widget build(BuildContext context) {
    final playlist = PlaylistController.instance;
    final audio = AudioController.instance;
    final songRepo = SongRepository();

    final keyword = _searchCtrl.text.trim().toLowerCase();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Following',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
      ),
      body: Column(
        children: [
          // ===== SEARCH BAR =====
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search artist, song, album',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                isDense: true,
              ),
            ),
          ),

          // ===== CONTENT =====
          Expanded(
            child: ValueListenableBuilder<Set<String>>(
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
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final allSongs = snapshot.data!;

                    // 🔥 GROUP + FILTER
                    final Map<String, List<Song>> artistMap = {};

                    for (final s in allSongs) {
                      if (!followingArtists.contains(s.artist)) continue;

                      // FILTER KEYWORD
                      final matchArtist =
                      _match(s.artist, keyword);
                      final matchSong =
                      _match(s.title, keyword);
                      final matchAlbum =
                      _match(s.albumTitle, keyword);

                      if (keyword.isNotEmpty &&
                          !(matchArtist ||
                              matchSong ||
                              matchAlbum)) {
                        continue;
                      }

                      artistMap.putIfAbsent(s.artist, () => []);
                      artistMap[s.artist]!.add(s);
                    }

                    if (artistMap.isEmpty) {
                      return const Center(
                        child: Text(
                          'Không tìm thấy kết quả',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    return ListView(
                      padding: const EdgeInsets.only(bottom: 90),
                      children: artistMap.entries.map((entry) {
                        final artistName = entry.key;
                        final artistSongs = entry.value;

                        // GROUP ALBUM
                        final Map<String, List<Song>> albumMap = {};
                        for (final s in artistSongs) {
                          albumMap.putIfAbsent(s.albumId, () => []);
                          albumMap[s.albumId]!.add(s);
                        }

                        final albums = albumMap.values.toList();

                        return Padding(
                          padding:
                          const EdgeInsets.only(bottom: 32),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              // ARTIST
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                                child: Row(
                                  children: [
                                    // ===== AVATAR =====
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(999),
                                      child: Image.network(
                                        artistSongs.first.artistImage,
                                        width: 48,
                                        height: 48,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    // ===== NAME + COUNT =====
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            artistName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${artistSongs.length} bài hát',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // ===== FOLLOW BUTTON =====
                                    ValueListenableBuilder(
                                      valueListenable: playlist.followingArtists,
                                      builder: (_, __, ___) {
                                        final isFollowing =
                                        playlist.isFollowingArtist(artistName);

                                        return InkWell(
                                          borderRadius: BorderRadius.circular(999),
                                          onTap: () {
                                            playlist.toggleFollowArtist(artistName);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(999),
                                              border: Border.all(
                                                color: isFollowing
                                                    ? Colors.grey
                                                    : Colors.grey,
                                                width: 1.5,
                                              ),
                                              color: isFollowing
                                                  ? Colors.amberAccent.withOpacity(0.1)
                                                  : Colors.transparent,
                                            ),
                                            child: Text(
                                              isFollowing ? 'Following' : 'Follow',
                                              style: TextStyle(
                                                fontSize: 14, // 🔥 to hơn
                                                fontWeight: FontWeight.bold,
                                                color: isFollowing
                                                    ? Colors.amber
                                                    : Colors.grey,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              // SONGS LABEL
                              const Padding(
                                padding:
                                EdgeInsets.fromLTRB(
                                    16, 4, 16, 8),
                                child: Text(
                                  'Songs',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                    FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),

                              // SONG LIST
                              SizedBox(
                                height: 160,
                                child: ListView.builder(
                                  scrollDirection:
                                  Axis.horizontal,
                                  itemCount:
                                  artistSongs.length,
                                  itemBuilder:
                                      (context, index) {
                                    final song =
                                    artistSongs[index];
                                    return GestureDetector(
                                      onTap: () {
                                        audio.playSong(song);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                NowPlayingPage(
                                                    song: song),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 120,
                                        margin:
                                        const EdgeInsets
                                            .symmetric(
                                            horizontal:
                                            12),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  12),
                                              child:
                                              Image.network(
                                                song
                                                    .Songimage,
                                                width: 120,
                                                height:
                                                120,
                                                fit: BoxFit
                                                    .cover,
                                              ),
                                            ),
                                            const SizedBox(
                                                height: 6),
                                            Text(
                                              song.title,
                                              maxLines: 1,
                                              overflow:
                                              TextOverflow
                                                  .ellipsis,
                                              style:
                                              const TextStyle(
                                                fontWeight:
                                                FontWeight
                                                    .bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              // ALBUMS
                              if (albums.isNotEmpty) ...[
                                const Padding(
                                  padding:
                                  EdgeInsets.fromLTRB(
                                      16, 12, 16, 8),
                                  child: Text(
                                    'Albums',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                      FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 180,
                                  child:
                                  ListView.builder(
                                    scrollDirection:
                                    Axis.horizontal,
                                    itemCount:
                                    albums.length,
                                    itemBuilder:
                                        (context, index) {
                                      final albumSongs =
                                      albums[index];
                                      final album =
                                          albumSongs
                                              .first;
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  AlbumDetailPage(
                                                    albumTitle:
                                                    album
                                                        .albumTitle,
                                                    songs:
                                                    albumSongs,
                                                  ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: 140,
                                          margin:
                                          const EdgeInsets
                                              .symmetric(
                                              horizontal:
                                              12),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    14),
                                                child:
                                                Image.network(
                                                  album
                                                      .Songimage,
                                                  width:
                                                  140,
                                                  height:
                                                  140,
                                                  fit:
                                                  BoxFit
                                                      .cover,
                                                ),
                                              ),
                                              const SizedBox(
                                                  height:
                                                  6),
                                              Text(
                                                album
                                                    .albumTitle,
                                                maxLines:
                                                1,
                                                overflow:
                                                TextOverflow
                                                    .ellipsis,
                                                style:
                                                const TextStyle(
                                                  fontWeight:
                                                  FontWeight
                                                      .bold,
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
          ),
        ],
      ),
    );
  }
}
