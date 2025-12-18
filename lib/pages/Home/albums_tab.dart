import 'package:flutter/material.dart';

class AlbumsTab extends StatelessWidget {
  const AlbumsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Albums',
        style: TextStyle(fontSize: 20, color: Colors.grey),
      ),
    );
  }
}
