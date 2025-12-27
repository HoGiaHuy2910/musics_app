import 'package:flutter/material.dart';
import '../../models/song.dart';
import '../../repositories/song_repository.dart';

import 'liked_songs_tab.dart';
import 'liked_albums_tab.dart';

class LikePage extends StatelessWidget {
  const LikePage({super.key});

  @override
  Widget build(BuildContext context) {
    final SongRepository songRepository = SongRepository();

    return StreamBuilder<List<Song>>(
      stream: songRepository.getSongs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('No favorite data')),
          );
        }

        final songs = snapshot.data!;

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Favorite',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              bottom: const TabBar(
                isScrollable: true,
                indicatorColor: Colors.amber,
                indicatorWeight: 3,
                labelColor: Colors.amber,
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 18,
                ),
                tabs: [
                  Tab(text: 'Songs'),
                  Tab(text: 'Albums'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                LikedSongsTab(songs: songs),
                LikedAlbumsTab(songs: songs),
              ],
            ),
          ),
        );
      },
    );
  }
}
