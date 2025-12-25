import 'package:flutter/material.dart';
import 'liked_songs_tab.dart';
import 'liked_albums_tab.dart';

class LikePage extends StatelessWidget {
  const LikePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
        body: const TabBarView(
          children: [
            LikedSongsTab(),
            LikedAlbumsTab(),
          ],
        ),
      ),
    );
  }
}
