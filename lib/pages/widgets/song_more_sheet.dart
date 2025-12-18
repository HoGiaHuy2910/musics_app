import 'package:flutter/material.dart';
import '/models/song.dart';
import '/controllers/playlist_controller.dart';

void showSongMoreSheet(BuildContext context, Song song) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.playlist_add),
              title: const Text('Add to Playlist'),
              onTap: () {
                PlaylistController.instance.add(song);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Download (tạm thời)'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    },
  );
}
