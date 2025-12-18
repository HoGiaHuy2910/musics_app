import 'package:flutter/material.dart';

class LikedSongsTab extends StatelessWidget {
  const LikedSongsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Liked Songs',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }
}
