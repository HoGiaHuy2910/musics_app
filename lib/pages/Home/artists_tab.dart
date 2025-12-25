import 'package:flutter/material.dart';
import '../../models/song.dart';
import '../ArtistDetail/artist_detail_page.dart';

class ArtistsTab extends StatelessWidget {
  final List<Song> songs;

  const ArtistsTab({
    super.key,
    required this.songs,
  });

  @override
  Widget build(BuildContext context) {
    // Group theo artistId
    final Map<String, List<Song>> map = {};

    for (final s in songs) {
      map.putIfAbsent(s.artist, () => []);
      map[s.artist]!.add(s);
    }

    final artistGroups = map.entries.toList()
      ..sort((a, b) => a.value.first.artist.compareTo(b.value.first.artist));

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 90),
      itemCount: artistGroups.length,
      itemBuilder: (context, index) {
        final entry = artistGroups[index];
        final artistId = entry.key;
        final list = entry.value;

        final artistName = list.first.artist;
        final artistAvatar = list.first.artistImage; // tạm lấy cover bài đầu

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
          title: Text(
            artistName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('${list.length} bài hát'),
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
