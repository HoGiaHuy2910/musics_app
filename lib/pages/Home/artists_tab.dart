import 'package:flutter/material.dart';
import '../../models/song.dart';
import '../../controllers/playlist_controller.dart';
import '../ArtistDetail/artist_detail_page.dart';

class ArtistsTab extends StatelessWidget {
  final List<Song> songs;

  const ArtistsTab({
    super.key,
    required this.songs,
  });

  @override
  Widget build(BuildContext context) {
    final playlist = PlaylistController.instance;

    // Group theo artistId
    final Map<String, List<Song>> map = {};
    for (final s in songs) {
      map.putIfAbsent(s.artist, () => []);
      map[s.artist]!.add(s);
    }

    final artistGroups = map.entries.toList()
      ..sort(
            (a, b) => a.value.first.artist.compareTo(b.value.first.artist),
      );

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 90),
      itemCount: artistGroups.length,
      itemBuilder: (context, index) {
        final entry = artistGroups[index];
        final artistId = entry.key;
        final list = entry.value;

        final artistName = list.first.artist;
        final artistAvatar = list.first.artistImage;

        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Image.network(
              artistAvatar,
              width: 54,
              height: 54,
              fit: BoxFit.cover,
            ),
          ),

          // ===== TITLE: NAME + FOLLOW =====
          title: Row(
            children: [
              // Artist name
              Expanded(
                child: Text(
                  artistName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Follow text
              ValueListenableBuilder(
                valueListenable: playlist.followingArtists,
                builder: (_, __, ___) {
                  final isFollowing =
                  playlist.isFollowingArtist(artistId);

                  return InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () {
                      playlist.toggleFollowArtist(artistId);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: isFollowing
                              ? Colors.grey
                              : Colors.grey,
                          width: 1.5,
                        ),
                        color: isFollowing
                            ? Colors.amberAccent.withOpacity(0.1)
                            : Colors.transparent,
                      ),
                      child: Text(
                        isFollowing ? 'Following' : 'Follow',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isFollowing
                              ? Colors.amber
                              : Colors.grey,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          subtitle: Text('${list.length} bài hát'),

          // ===== GIỮ ICON MŨI TÊN CŨ =====
          trailing: const Icon(Icons.chevron_right),

          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ArtistDetailPage(
                  artistId: artistId,
                  artistName: artistName,
                  artistImageUrl: artistAvatar,
                  songs: list,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
