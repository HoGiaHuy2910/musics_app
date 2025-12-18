import 'package:flutter/material.dart';

class ArtistsTab extends StatelessWidget {
  const ArtistsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Artists',
        style: TextStyle(fontSize: 20, color: Colors.grey),
      ),
    );
  }
}
