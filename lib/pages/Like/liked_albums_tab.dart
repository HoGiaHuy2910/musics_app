import 'package:flutter/material.dart';
import '../../controllers/playlist_controller.dart';
import '../../data/mock_songs.dart';
import '../Home/album_detail_page.dart';

class LikedAlbumsTab extends StatelessWidget {
  const LikedAlbumsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final playlist = PlaylistController.instance;

    return ValueListenableBuilder<Set<String>>(
      valueListenable: playlist.favoriteAlbums,
      builder: (_, favAlbumIds, __) {
        if (favAlbumIds.isEmpty) {
          return const Center(
            child: Text(
              'Chưa có album yêu thích',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        // 🔥 GROUP SONGS THEO ALBUM
        final albums = <String, List>{};

        for (final song in songs) {
          if (favAlbumIds.contains(song.albumId)) {
            albums.putIfAbsent(song.albumId, () => []).add(song);
          }
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 90),
          itemCount: albums.length,
          itemBuilder: (context, index) {
            final albumId = albums.keys.elementAt(index);
            final albumSongs = albums[albumId]!;
            final albumTitle = albumSongs.first.albumTitle;
            final albumImage = albumSongs.first.image;

            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  albumImage,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(albumTitle),
              subtitle: Text('${albumSongs.length} bài hát'),
              trailing: IconButton(
                icon: const Icon(Icons.favorite, color: Colors.amberAccent),
                onPressed: () {
                  playlist.toggleFavoriteAlbum(albumId);
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AlbumDetailPage(
                      albumTitle: albumTitle,
                      songs: List.from(albumSongs),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
