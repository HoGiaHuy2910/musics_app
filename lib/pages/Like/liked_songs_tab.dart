import 'package:flutter/material.dart';
import '../../controllers/playlist_controller.dart';
import '../../controllers/audio_controller.dart';
import '../../data/mock_songs.dart';
import '../../models/song.dart';
import '../now_playing_page.dart';

class LikedSongsTab extends StatelessWidget {
  const LikedSongsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final playlistController = PlaylistController.instance;
    final audioController = AudioController.instance;

    return ValueListenableBuilder<Set<String>>(
      valueListenable: playlistController.favorites,
      builder: (context, favoriteIds, _) {
        // 🔥 LẤY TỪ TOÀN BỘ SONGS – KHÔNG PHẢI PLAYLIST
        final List<Song> likedSongs = songs
            .where((song) => favoriteIds.contains(song.Songid))
            .toList();

        if (likedSongs.isEmpty) {
          return const Center(
            child: Text(
              'Chưa có bài hát yêu thích',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 90),
          itemCount: likedSongs.length,
          itemBuilder: (context, index) {
            final song = likedSongs[index];
            final isPlaying =
                audioController.currentSong.value?.Songid == song.Songid;

            return Dismissible(
              key: ValueKey(song.Songid),
              direction: DismissDirection.endToStart,
              onDismissed: (_) {
                playlistController.toggleFavorite(song);
              },
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                color: Colors.red,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: ListTile(
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
                trailing: IconButton(
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.amberAccent,
                  ),
                  onPressed: () {
                    playlistController.toggleFavorite(song);
                  },
                ),
                onTap: () {
                  audioController.playSong(song);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NowPlayingPage(song: song),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
