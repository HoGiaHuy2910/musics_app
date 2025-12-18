import 'package:flutter/material.dart';

class LikedArtistsTab extends StatelessWidget {
  const LikedArtistsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Liked Artists',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }
}
