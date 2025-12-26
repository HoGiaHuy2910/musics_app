import 'package:flutter/material.dart';
import '../../models/song.dart';
import '../../repositories/song_repository.dart';

import 'overview_tab.dart';
import 'songs_tab.dart';
import 'albums_tab.dart';
import 'artists_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchCtrl = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  bool _match(String source, String keyword) {
    return source.toLowerCase().contains(keyword);
  }

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

        final allSongs = snapshot.data!;
        final keyword = _searchCtrl.text.trim().toLowerCase();

        // 🔍 FILTER SONGS
        final filteredSongs = !_isSearching || keyword.isEmpty
            ? allSongs
            : allSongs.where((s) {
          return _match(s.title, keyword) ||
              _match(s.artist, keyword) ||
              _match(s.albumTitle, keyword);
        }).toList();

        return DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              title: _isSearching
                  ? TextField(
                controller: _searchCtrl,
                autofocus: true,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'Search songs, artists, albums',
                  border: InputBorder.none,
                ),
              )
                  : const Text(
                'Discover',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              actions: [
                IconButton(
                  icon: Icon(_isSearching ? Icons.close : Icons.search),
                  onPressed: () {
                    setState(() {
                      if (_isSearching) {
                        _searchCtrl.clear();
                      }
                      _isSearching = !_isSearching;
                    });
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
                OverviewTab(songs: filteredSongs),
                SongsTab(songs: filteredSongs),
                AlbumsTab(songs: filteredSongs),
                ArtistsTab(songs: filteredSongs),
              ],
            ),
          ),
        );
      },
    );
  }
}
