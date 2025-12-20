import 'package:flutter/material.dart';
import '/controllers/audio_controller.dart';
import '../now_playing_page.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = AudioController.instance;

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
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              border: Border(
                top: BorderSide(
                  color: Colors.black, // 👈 viền phân cách
                  width: 2,
                ),
              ),
            ),
            child: Column(
              children: [
                // 🔊 MINI PROGRESS BAR
                ValueListenableBuilder<Duration>(
                  valueListenable: audio.position,
                  builder: (context, position, _) {
                    return ValueListenableBuilder<Duration>(
                      valueListenable: audio.duration,
                      builder: (context, duration, _) {
                        final max = duration.inMilliseconds;
                        final value = max == 0
                            ? 0.0
                            : position.inMilliseconds / max;

                        return LinearProgressIndicator(
                          value: value.clamp(0.0, 1.0),
                          backgroundColor: Colors.grey.shade400,
                          valueColor: const AlwaysStoppedAnimation(
                            Colors.amberAccent,
                          ),
                          minHeight: 5,
                        );
                      },
                    );
                  },
                ),

                // 🎵 INFO + PLAY / PAUSE
                Expanded(
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          song.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song.title,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              song.artist,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      StreamBuilder<bool>(
                        stream: audio.player.playingStream,
                        builder: (context, snapshot) {
                          final playing = snapshot.data ?? false;
                          return IconButton(
                            icon: Icon(
                              playing
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.black,
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
