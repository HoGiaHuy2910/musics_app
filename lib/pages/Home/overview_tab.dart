import 'package:flutter/material.dart';
import '../../data/mock_songs.dart';
import '../../controllers/audio_controller.dart';
import '../../controllers/playlist_controller.dart';
import '../now_playing_page.dart';
import '../widgets/song_more_sheet.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    final playlist = PlaylistController.instance;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== Popular This Week =====
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Popular This Week',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];

                return Container(
                  width: 180,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          song.image,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.6),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 80,
                        child: Text(
                          song.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // ===== BUTTON BAR =====
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // ▶️ PLAY
                              InkWell(
                                onTap: () {
                                  AudioController.instance.playSong(song);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          NowPlayingPage(song: song),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow,
                                    color: Colors.black,
                                    size: 24,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 24),

                              const Icon(Icons.download,
                                  color: Colors.white, size: 20),

                              const SizedBox(width: 12),

                              // ❤️ FAVORITE
                              ValueListenableBuilder(
                                valueListenable:
                                playlist.favorites,
                                builder: (_, __, ___) {
                                  final isFav =
                                  playlist.isFavorite(song);
                                  return InkWell(
                                    onTap: () =>
                                        playlist.toggleFavorite(song),
                                    child: Icon(
                                      isFav
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isFav
                                          ? Colors.redAccent
                                          : Colors.white,
                                      size: 20,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // ===== Top Songs =====
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Top Songs',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          ListView.builder(
            itemCount: songs.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final song = songs[index];

              return ListTile(
                leading: Stack(
                  alignment: Alignment.center,
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
                    const Icon(Icons.play_arrow,
                        size: 20, color: Colors.white),
                  ],
                ),
                title: Text(song.title),
                subtitle: Text(song.artist),

                // ❤️ + ⋮
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: playlist.favorites,
                      builder: (_, __, ___) {
                        final isFav =
                        playlist.isFavorite(song);
                        return IconButton(
                          icon: Icon(
                            isFav
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color:
                            isFav ? Colors.red : Colors.grey,
                            size: 20,
                          ),
                          onPressed: () =>
                              playlist.toggleFavorite(song),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        showSongMoreSheet(context, song);
                      },
                    ),
                  ],
                ),

                onTap: () {
                  AudioController.instance.playSong(song);
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
        ],
      ),
    );
  }
}
