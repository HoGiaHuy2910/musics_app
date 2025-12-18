import 'package:flutter/material.dart';
import '../controllers/playlist_controller.dart';
import '../controllers/audio_controller.dart';

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
          // 🔽 drag indicator
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
                return ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    final isPlaying =
                        audio.currentSong.value?.audioAsset ==
                            song.audioAsset;

                    return Dismissible(
                      key: ValueKey(song.audioAsset),
                      direction: DismissDirection.horizontal,
                      onDismissed: (_) {
                        playlist.remove(song);
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      secondaryBackground: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        decoration: BoxDecoration(
                          color: isPlaying
                              ? Colors.green.withOpacity(0.08)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              song.image,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            song.title,
                            style: TextStyle(
                              fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal,
                              color: isPlaying ? Colors.amber : Colors.black,
                            ),
                          ),
                          subtitle: Text(song.artist),
                          trailing: isPlaying
                              ? const Icon(Icons.graphic_eq, color: Colors.amberAccent)
                              : null,
                          onTap: () {
                            playlist.playFromHere(song);
                          },
                        ),
                      ),
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
