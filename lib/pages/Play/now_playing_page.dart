import 'package:flutter/material.dart';
import '../../models/song.dart';
import '../../controllers/audio_controller.dart';
import 'playlist_page.dart';

class NowPlayingPage extends StatefulWidget {
  final Song song;

  const NowPlayingPage({super.key, required this.song});

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> {
  final controller = AudioController.instance;

  @override
  void initState() {
    super.initState();
    controller.playSong(widget.song);
  }

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final player = controller.player;

    return Scaffold(
      appBar: AppBar(title: const Text('Now Playing')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // ===== IMAGE =====
        ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.network( widget.song.Songimage,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
        ),

            const SizedBox(height: 24),

            // ===== TITLE =====
            Text(
              widget.song.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.song.artist,
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 24),

            // ===== SLIDER + TIME =====
            StreamBuilder<Duration>(
              stream: player.positionStream,
              builder: (context, snapshot) {
                final pos = snapshot.data ?? Duration.zero;
                final dur = player.duration ?? Duration.zero;

                return Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        activeTrackColor: Colors.amberAccent, // 🟡 thanh chạy
                        inactiveTrackColor: Colors.grey.shade400, // ⚪ nền xám
                        thumbColor: Colors.amberAccent, // 🟡 nút kéo
                        overlayColor: Colors.amberAccent.withOpacity(0.25),
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 8,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 16,
                        ),
                      ),
                      child: Slider(
                        value: pos.inSeconds.toDouble().clamp(
                          0,
                          dur.inSeconds.toDouble().clamp(1, double.infinity),
                        ),
                        max: dur.inSeconds
                            .toDouble()
                            .clamp(1, double.infinity),
                        onChanged: (v) {
                          player.seek(Duration(seconds: v.toInt()));
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _format(pos),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          _format(dur),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 4),

            // ===== CONTROLS =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 📄 PLAYLIST
                IconButton(
                  icon: const Icon(Icons.queue_music),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const PlaylistPage(),
                    );
                  },
                ),

                // ⏪ BACK 10s
                IconButton(
                  iconSize: 36,
                  icon: const Icon(Icons.replay_10),
                  onPressed: controller.seekBackward,
                ),

                // ▶️ / ⏸️ PLAY / PAUSE
                StreamBuilder<bool>(
                  stream: player.playingStream,
                  builder: (_, snap) {
                    final playing = snap.data ?? false;
                    return IconButton(
                      iconSize: 72, // ✅ giữ nguyên
                      icon: Icon(
                        playing
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                      ),
                      onPressed: controller.togglePlay,
                    );
                  },
                ),

                // ⏩ FORWARD 10s
                IconButton(
                  iconSize: 36,
                  icon: const Icon(Icons.forward_10),
                  onPressed: controller.seekForward,
                ),

                // 🔁 REPEAT
                ValueListenableBuilder<bool>(
                  valueListenable: controller.isRepeatOne,
                  builder: (_, repeat, __) {
                    return IconButton(
                      icon: Icon(
                        repeat ? Icons.repeat_one : Icons.repeat,
                        color: repeat ? Colors.black : Colors.grey,
                      ),
                      onPressed: controller.toggleRepeat,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
