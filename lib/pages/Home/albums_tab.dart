import 'package:flutter/material.dart';
import '../../data/mock_songs.dart';
import '../../models/song.dart';
import '../../controllers/playlist_controller.dart';
import 'album_detail_page.dart';

class AlbumsTab extends StatelessWidget {
  const AlbumsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final playlist = PlaylistController.instance;

    // 🔥 Group songs theo albumId
    final Map<String, List<Song>> albums = {};

    for (final song in songs) {
      albums.putIfAbsent(song.albumId, () => []);
      albums[song.albumId]!.add(song);
    }

    final albumList = albums.values.toList();

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: albumList.length,
      itemBuilder: (context, index) {
        final albumSongs = albumList[index];
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== ALBUM COVER + ❤️ =====
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      // 🖼 COVER
                      Positioned.fill(
                        child: Image.network(
                          album.image,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // ❤️ FAVORITE ALBUM
                      Positioned(
                        top: 8,
                        right: 8,
                        child: ValueListenableBuilder(
                          valueListenable: playlist.favoriteAlbums,
                          builder: (_, __, ___) {
                            final isFav = playlist
                                .isFavoriteAlbum(album.albumId);

                            return GestureDetector(
                              onTap: () {
                                playlist.toggleFavoriteAlbum(
                                  album.albumId,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.45),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isFav
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFav
                                      ? Colors.amberAccent
                                      : Colors.white,
                                  size: 18,
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

              const SizedBox(height: 8),

              // 🎵 ALBUM TITLE
              Text(
                album.albumTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),

              // 👤 ARTIST
              Text(
                album.artist,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
