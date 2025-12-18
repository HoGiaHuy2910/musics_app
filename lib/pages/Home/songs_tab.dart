import 'package:flutter/material.dart';
import '../../data/mock_songs.dart';
import '../../controllers/audio_controller.dart';
import '../../controllers/playlist_controller.dart';
import '../now_playing_page.dart';
import '../widgets/song_more_sheet.dart';

class SongsTab extends StatelessWidget {
  const SongsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final playlist = PlaylistController.instance;

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 90),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];

        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              song.image,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(song.title),
          subtitle: Text(song.artist),

          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ❤️ FAVORITE
              ValueListenableBuilder(
                valueListenable: playlist.favorites,
                builder: (_, __, ___) {
                  final isFav = playlist.isFavorite(song);
                  return IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.grey,
                      size: 20,
                    ),
                    onPressed: () =>
                        playlist.toggleFavorite(song),
                  );
                },
              ),

              // ⋮ MORE
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  showSongMoreSheet(context, song);
                },
              ),
            ],
          ),

          onTap: () {
            AudioController.instance.playSong(song);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NowPlayingPage(song: song),
              ),
            );
          },
        );
      },
    );
  }
}
