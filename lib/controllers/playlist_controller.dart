import 'package:flutter/material.dart';
import '../models/song.dart';
import '../controllers/audio_controller.dart';

class PlaylistController {
  PlaylistController._();
  static final instance = PlaylistController._();

  /// 🎵 PLAYLIST
  final ValueNotifier<List<Song>> playlist =
  ValueNotifier<List<Song>>([]);

  /// ❤️ FAVORITES
  final ValueNotifier<Set<String>> favorites =
  ValueNotifier<Set<String>>({});

  /// ➕ ADD
  void add(Song song) {
    if (!playlist.value.any((s) => s.audioNetwork == song.audioNetwork)) {
      playlist.value = [...playlist.value, song];
    }
  }

  /// PLAYFROM
  void playFrom(Song song) {
    final list = playlist.value;

    // nếu bài chưa có → reset playlist từ bài này
    if (!list.any((s) => s.audioNetwork == song.audioNetwork)) {
      playlist.value = [song];
      return;
    }

    // nếu có → cắt playlist từ bài này trở đi
    final index =
    list.indexWhere((s) => s.audioNetwork == song.audioNetwork);

    playlist.value = list.sublist(index);
  }

  /// ❌ REMOVE
  void remove(Song song) {
    final list = [...playlist.value];
    final index = list.indexWhere(
          (s) => s.audioNetwork == song.audioNetwork,
    );

    final isCurrent =
        AudioController.instance.currentSong.value?.audioNetwork ==
            song.audioNetwork;

    list.removeAt(index);
    playlist.value = list;

    if (isCurrent) {
      if (list.isNotEmpty) {
        // 👉 phát bài kế tiếp, hoặc bài trước nếu cuối list
        final nextIndex =
        index < list.length ? index : list.length - 1;
        AudioController.instance.playSong(list[nextIndex]);
      } else {
        // 👉 không còn bài nào
        AudioController.instance.stop();
      }
    }
  }
  void playFromHere(Song song) {
    final list = playlist.value;
    final index = list.indexWhere(
          (s) => s.audioNetwork == song.audioNetwork,
    );

    if (index == -1) return;

    playlist.value = list.sublist(index);
    AudioController.instance.playSong(song);
  }

// ❤️ TOGGLE FAVORITE
  void toggleFavorite(Song song) {
    final favs = favorites.value;

    if (favs.contains(song.Songid)) {
      favs.remove(song.Songid);
    } else {
      favs.add(song.Songid);
    }

    favorites.value = {...favs};
  }

  bool isFavorite(Song song) {
    return favorites.value.contains(song.Songid);
  }
}

