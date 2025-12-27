import 'package:flutter/material.dart';
import '/controllers/audio_controller.dart';
import '../Play/now_playing_page.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = AudioController.instance;
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder(
      valueListenable: audio.currentSong,
      builder: (context, song, _) {
        if (song == null) return const SizedBox();

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NowPlayingPage(song: song),
              ),
            );
          },
          child: Container(
            height: 72,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isDark ? Colors.black : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              border: Border(
                top: BorderSide(
                  color: isDark
                      ? Colors.grey.shade800
                      : Colors.grey.shade300,
                  width: 3,
                ),
              ),
            ),
            child: Column(
              children: [
                // ================= PROGRESS BAR =================
                ValueListenableBuilder<Duration>(
                  valueListenable: audio.position,
                  builder: (context, position, _) {
                    return ValueListenableBuilder<Duration>(
                      valueListenable: audio.duration,
                      builder: (context, duration, _) {
                        final max =
                        duration.inMilliseconds.toDouble();
                        final value = max == 0
                            ? 0.0
                            : position.inMilliseconds / max;

                        return ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: value.clamp(0.0, 1.0),

                            // 👇 NỀN XÁM (THEO MODE)
                            backgroundColor: isDark
                                ? Colors.grey.shade700
                                : Colors.grey.shade400,

                            // 👇 THANH CHẠY VÀNG (CỐ ĐỊNH)
                            valueColor:
                            const AlwaysStoppedAnimation(
                              Colors.amberAccent,
                            ),

                            minHeight: 5,
                          ),
                        );
                      },
                    );
                  },
                ),

                // ================= INFO + CONTROL =================
                Expanded(
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          song.Songimage,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              song.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              song.artist,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isDark
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ▶️ PLAY / PAUSE
                      StreamBuilder<bool>(
                        stream: audio.player.playingStream,
                        builder: (context, snapshot) {
                          final playing =
                              snapshot.data ?? false;
                          return IconButton(
                            icon: Icon(
                              playing
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 30,
                              color: isDark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            onPressed: audio.togglePlay,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
