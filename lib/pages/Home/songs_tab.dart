import 'package:flutter/material.dart';
import '../../controllers/audio_controller.dart';
import '../../controllers/playlist_controller.dart';
import '../Play/now_playing_page.dart';
import '../../models/song.dart';
import '../widgets/add_to_playlist_sheet.dart';
import '../ArtistDetail/artist_detail_page.dart';

class SongsTab extends StatelessWidget {
  final List<Song> songs;

  const SongsTab({
    super.key,
    required this.songs,
  });

  @override
  Widget build(BuildContext context) {
    final playlist = PlaylistController.instance;

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 90),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];

        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              song.Songimage,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),

          title: Text(song.title),
          subtitle: Text(song.artist),

          // ================= TRAILING ACTIONS =================
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ❤️ FAVORITE
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

              // ➕ ADD TO QUEUE
              IconButton(
                icon: const Icon(Icons.playlist_add),
                onPressed: () {
                  PlaylistController.instance.add(song);
                },
              ),

              // ⋮ MORE
              PopupMenuButton<_SongMenuAction>(
                icon: const Icon(Icons.more_vert),
                onSelected: (action) {
                  switch (action) {
                    case _SongMenuAction.addToMyPlaylist:
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (_) =>
                            AddToPlaylistSheet(songId: song.Songid),
                      );
                      break;

                    case _SongMenuAction.viewArtist:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ArtistDetailPage(
                            artistId: song.artist,
                            artistName: song.artist,
                            artistImageUrl: song.artistImage,
                            songs: songs
                                .where((s) => s.artist == song.artist)
                                .toList(),
                          ),
                        ),
                      );
                      break;
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: _SongMenuAction.addToMyPlaylist,
                    child: ListTile(
                      leading: Icon(Icons.library_add),
                      title: Text('Add to myplaylist'),
                    ),
                  ),
                  PopupMenuItem(
                    value: _SongMenuAction.viewArtist,
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text('View artist'),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // ================= PLAY SONG =================
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
    );
  }
}

/// ================= MENU ACTION =================
enum _SongMenuAction {
  addToMyPlaylist,
  viewArtist,
}
