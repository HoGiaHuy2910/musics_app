import 'package:flutter/material.dart';
import '../../models/song.dart';
import '../../controllers/audio_controller.dart';
import '../../controllers/playlist_controller.dart';
import '../now_playing_page.dart';
import '../widgets/song_more_sheet.dart';

class AlbumDetailPage extends StatelessWidget {
  final String albumTitle;
  final List<Song> songs;

  const AlbumDetailPage({
    super.key,
    required this.albumTitle,
    required this.songs,
  });

  @override
  Widget build(BuildContext context) {
    final audio = AudioController.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text(albumTitle),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 90),
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          final isPlaying =
              audio.currentSong.value?.Songid == song.Songid;

          return ListTile(
            leading: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    song.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                if (isPlaying)
                  const Icon(
                    Icons.equalizer,
                    color: Colors.green,
                  ),
              ],
            ),
            title: Text(
              song.title,
              style: TextStyle(
                fontWeight:
                isPlaying ? FontWeight.bold : FontWeight.normal,
              ),
            ),
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
                        color: isFav ? Colors.amberAccent : Colors.grey,
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
              audio.playSong(song);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NowPlayingPage(song: song),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
