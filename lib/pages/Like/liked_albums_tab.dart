import 'package:flutter/material.dart';

class LikedAlbumsTab extends StatelessWidget {
  const LikedAlbumsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Liked Albums',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }
}
