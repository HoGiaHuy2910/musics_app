import 'package:flutter/material.dart';
import '../../controllers/playlist_controller.dart';
import '../../controllers/audio_controller.dart';

class PlaylistPage extends StatelessWidget {
  const PlaylistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final playlist = PlaylistController.instance;
    final audio = AudioController.instance;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // drag indicator
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),

          const Text(
            'Danh sách phát',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: ValueListenableBuilder(
              valueListenable: playlist.playlist,
              builder: (_, songs, __) {
                if (songs.isEmpty) {
                  return const Center(
                    child: Text(
                      'Chưa có bài nào trong danh sách',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    final isPlaying =
                        audio.currentSong.value?.audioNetwork ==
                            song.audioNetwork;

                    return ListTile(
                      leading: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              song.image,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                          ),
                          if (isPlaying)
                            const Icon(Icons.equalizer,
                                color: Colors.green),
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
                      trailing: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          playlist.remove(song);
                        },
                      ),
                      onTap: () {
                        playlist.playFromHere(song);
                      },
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
