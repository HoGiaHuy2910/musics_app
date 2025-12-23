import 'package:flutter/material.dart';
import '../../data/mock_songs.dart';
import '../../models/song.dart';
import 'album_detail_page.dart';

class AlbumsTab extends StatelessWidget {
  const AlbumsTab({super.key});

  @override
  Widget build(BuildContext context) {
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
              // 🖼 ALBUM COVER
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    album.image,
                    width: double.infinity,
                    fit: BoxFit.cover,
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
