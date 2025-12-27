import 'dart:math';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../models/song.dart';
import '../../controllers/audio_controller.dart';
import '../../controllers/playlist_controller.dart';
import '../Play/now_playing_page.dart';


class AlbumDetailPage extends StatefulWidget {
  final String albumTitle;
  final List<Song> songs;

  const AlbumDetailPage({
    super.key,
    required this.albumTitle,
    required this.songs,
  });

  @override
  State<AlbumDetailPage> createState() => _AlbumDetailPageState();
}

class _AlbumDetailPageState extends State<AlbumDetailPage> {
  late List<Song> _displaySongs;

  // cache duration theo từng bài
  final Map<String, Duration> _durations = {};
  Duration? _totalDuration;
  bool _loadingDuration = true;

  // player chỉ để “probe” duration (không phát)
  final AudioPlayer _probePlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _displaySongs = [...widget.songs];
    _loadDurations();
  }

  @override
  void dispose() {
    _probePlayer.dispose();
    super.dispose();
  }

  Future<void> _loadDurations() async {
    setState(() {
      _loadingDuration = true;
    });

    Duration total = Duration.zero;

    // Load lần lượt để tránh tốn tài nguyên
    for (final s in widget.songs) {
      try {
        // setUrl sẽ lấy metadata (thường có duration)
        await _probePlayer.setUrl(s.audioNetwork);
        final d = _probePlayer.duration ?? Duration.zero;

        _durations[s.audioNetwork] = d;
        total += d;
      } catch (_) {
        _durations[s.audioNetwork] = Duration.zero;
      }
    }

    if (!mounted) return;

    setState(() {
      _totalDuration = total;
      _loadingDuration = false;
    });
  }

  String _formatTotal(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }

  void _playAlbumInOrder() {
    final playlist = PlaylistController.instance;
    final audio = AudioController.instance;

    // reset hiển thị về đúng thứ tự album
    setState(() {
      _displaySongs = [...widget.songs];
    });

    // set playlist + play
    playlist.playlist.value = [...widget.songs];
    final first = widget.songs.first;
    audio.playSong(first);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NowPlayingPage(song: first),
      ),
    );
  }

  void _shuffleAndPlay() {
    final playlist = PlaylistController.instance;
    final audio = AudioController.instance;

    final shuffled = [...widget.songs]..shuffle();

    playlist.playlist.value = shuffled;
    audio.playSong(shuffled.first);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NowPlayingPage(song: shuffled.first),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final audio = AudioController.instance;
    final playlist = PlaylistController.instance;

    final album = widget.songs.first;

    final infoText = _loadingDuration
        ? '${album.artist} • ${widget.songs.length} bài • ...'
        : '${album.artist} • ${widget.songs.length} bài • ${_formatTotal(_totalDuration ?? Duration.zero)}';

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          // =====================
          // HEADER
          // =====================
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    album.Songimage,
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  widget.albumTitle,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),

                Text(
                  infoText,
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    // ❤️ FAVORITE ALBUM (đồng bộ AlbumsTab)
                    ValueListenableBuilder(
                      valueListenable: playlist.favoriteAlbums,
                      builder: (_, __, ___) {
                        final isFav =
                        playlist.isFavoriteAlbum(album.albumId);

                        return IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.amberAccent : Colors.grey,
                          ),
                          onPressed: () {
                            playlist.toggleFavoriteAlbum(album.albumId);
                          },
                        );
                      },
                    ),

                    const SizedBox(width: 8),

                    // 🔀 SHUFFLE
                    OutlinedButton.icon(
                      icon: const Icon(Icons.shuffle, color: Colors.amber),
                      label: const Text(
                        'Xáo trộn',
                        style: TextStyle(color: Colors.amber),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                      ),
                      onPressed: _shuffleAndPlay,
                    ),

                    const SizedBox(width: 12),

                    // ▶️ PLAY
                    ElevatedButton.icon(
                      icon: const Icon(Icons.play_arrow, color: Colors.amber),
                      label: const Text(
                        'Phát',
                        style: TextStyle(color: Colors.amber),
                      ),
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                      ),
                      onPressed: _playAlbumInOrder,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // =====================
          // SONG LIST (có “thấy xáo”)
          // =====================
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 90),
              itemCount: _displaySongs.length,
              itemBuilder: (context, index) {
                final song = _displaySongs[index];
                final isPlaying =
                    audio.currentSong.value?.audioNetwork == song.audioNetwork;

                // duration từng bài (nếu đã load)
                final d = _durations[song.audioNetwork];
                final durText = (d == null || d == Duration.zero)
                    ? ''
                    : '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';

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
                        const Icon(
                          Icons.equalizer,
                          color: Colors.amber,
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
                  // hiển thị duration bên phải (nếu có)
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (durText.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            durText,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      IconButton(
                        icon: const Icon(Icons.playlist_add),
                        onPressed: () {
                          playlist.add(song);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    // bạn đang muốn: tap bài thì phát bài đó (playlist logic bạn tự giữ)
                    playlist.playFromHere(song);
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
