import 'package:flutter/material.dart';
import 'overview_tab.dart';
import 'songs_tab.dart';
import 'albums_tab.dart';
import 'artists_tab.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                // TODO: làm trang search sau
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
              fontSize: 15,
            ),
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Songs'),
              Tab(text: 'Albums'),
              Tab(text: 'Artists'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            OverviewTab(),
            SongsTab(),
            AlbumsTab(),
            ArtistsTab(),
          ],
        ),
      ),
    );
  }
}
