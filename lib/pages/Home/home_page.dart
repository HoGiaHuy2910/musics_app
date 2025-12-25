import 'package:flutter/material.dart';
import '../../models/song.dart';
import '../../repositories/song_repository.dart';

import 'overview_tab.dart';
import 'songs_tab.dart';
import 'albums_tab.dart';
import 'artists_tab.dart';
import '../Like/liked_songs_tab.dart';
import '../Like/liked_albums_tab.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
            body: Center(child: Text('No songs found')),
          );
        }

        final songs = snapshot.data!;

        return DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Discover',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // 🔍 NÚT SEARCH Ở GÓC PHẢI
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    debugPrint('Search clicked');
                  },
                ),
              ],

              bottom: const TabBar(
                isScrollable: true,
                indicatorColor: Colors.amber,
                indicatorWeight: 3,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 16,
                ),
                tabs: [
                  Tab(text: 'Overview'),
                  Tab(text: 'Songs'),
                  Tab(text: 'Albums'),
                  Tab(text: 'Artists'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                OverviewTab(songs: songs),
                SongsTab(songs: songs),
                AlbumsTab(songs: songs),
                ArtistsTab(songs: songs),
              ],
            ),
          ),
        );
      },
    );
  }
}
