import 'package:flutter/material.dart';
import '../../controllers/playlist_controller.dart';
import '../../controllers/audio_controller.dart';

class PlaylistPage extends StatelessWidget {
  const PlaylistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final playlist = PlaylistController.instance;
    final audio = AudioController.instance;
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF121212) // dark nền queue
            : Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== DRAG INDICATOR =====
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.grey.shade700
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),

          // ===== TITLE =====
          Text(
            'Danh sách phát',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: ValueListenableBuilder(
              valueListenable: playlist.playlist,
              builder: (_, songs, __) {
                if (songs.isEmpty) {
                  return Center(
                    child: Text(
                      'Chưa có bài nào trong danh sách',
                      style: TextStyle(
                        color: isDark
                            ? Colors.grey.shade500
                            : Colors.grey,
                      ),
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

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        color: isPlaying
                            ? Colors.amber.withOpacity(
                          isDark ? 0.18 : 0.12,
                        )
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Opacity(
                                opacity: isPlaying ? 0.6 : 1.0,
                                child: Image.network(
                                  song.Songimage,
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            if (isPlaying)
                              const Icon(
                                Icons.equalizer,
                                color: Colors.amber,
                              ),
                          ],
                        ),

                        title: Text(
                          song.title,
                          style: TextStyle(
                            fontWeight: isPlaying
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isDark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          song.artist,
                          style: TextStyle(
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade700,
                          ),
                        ),

                        trailing: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade700,
                          ),
                          onPressed: () {
                            playlist.remove(song);
                          },
                        ),

                        onTap: () {
                          playlist.playFromHere(song);
                        },
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
