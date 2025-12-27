import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../models/song.dart';
import '../../controllers/audio_controller.dart';
import '../../controllers/playlist_controller.dart';
import '../Play/now_playing_page.dart';

class ArtistDetailPage extends StatefulWidget {
  final String artistId;
  final String artistName;
  final String artistImageUrl;
  final List<Song> songs;

  const ArtistDetailPage({
    super.key,
    required this.artistId,
    required this.artistName,
    required this.artistImageUrl,
    required this.songs,
  });

  @override
  State<ArtistDetailPage> createState() => _ArtistDetailPageState();
}

class _ArtistDetailPageState extends State<ArtistDetailPage> {
  Duration? _totalDuration;
  bool _loadingDuration = true;

  @override
  void initState() {
    super.initState();
    _calcTotalDuration();
  }

  Future<void> _calcTotalDuration() async {
    // Probe duration từ URL mp3 (tốn thời gian nhưng đúng “demo online”)
    final probe = AudioPlayer();
    Duration sum = Duration.zero;

    try {
      for (final s in widget.songs) {
        try {
          await probe.setUrl(s.audioNetwork);
          final d = probe.duration;
          if (d != null) sum += d;
        } catch (_) {
          // ignore từng bài lỗi
        }
      }
    } finally {
      await probe.dispose();
    }

    if (!mounted) return;
    setState(() {
      _totalDuration = sum;
      _loadingDuration = false;
    });
  }

  String _formatTotal(Duration d) {
    final totalSeconds = d.inSeconds;
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }

  void _playAll({required bool shuffle}) {
    final audio = AudioController.instance;
    final playlist = PlaylistController.instance;

    final List<Song> list = [...widget.songs];
    if (shuffle) list.shuffle();

    // Set playlist = toàn bộ list
    playlist.playlist.value = list;

    // phát bài đầu
    audio.playSong(list.first);

    // mở now playing
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NowPlayingPage(song: list.first)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final audio = AudioController.instance;
    final playlist = PlaylistController.instance;

    return Scaffold(
      appBar: AppBar(title: Text(widget.artistName)),
      body: Column(
        children: [
          // ===== HEADER =====
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    widget.artistImageUrl,
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.artistName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${widget.songs.length} bài hát'
                            '${_loadingDuration ? ' • đang tính thời lượng…' : ''}'
                            '${(!_loadingDuration && _totalDuration != null) ? ' • ${_formatTotal(_totalDuration!)}' : ''}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 10),

                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _playAll(shuffle: false),
                              icon: const Icon(Icons.play_arrow, color: Colors.amber),
                              label: const Text(
                                'Play all',
                                style: TextStyle(color: Colors.amber),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _playAll(shuffle: true),
                              icon: const Icon(Icons.shuffle, color: Colors.amber),
                              label: const Text(
                                'Shuffle',
                                style: TextStyle(color: Colors.amber),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // ===== SONG LIST =====
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 90),
              itemCount: widget.songs.length,
              itemBuilder: (context, index) {
                final song = widget.songs[index];
                final isPlaying =
                    audio.currentSong.value?.Songid == song.Songid;

                return ListTile(
                  leading: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          song.Songimage,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (isPlaying)
                        const Icon(Icons.equalizer, color: Colors.amberAccent),
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
                      // ❤️ favorite song
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
                            onPressed: () => playlist.toggleFavorite(song),
                          );
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.playlist_add),
                        onPressed: () {
                          PlaylistController.instance.add(song);
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
          ),
        ],
      ),
    );
  }
}
