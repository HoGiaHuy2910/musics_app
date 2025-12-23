import 'package:flutter/material.dart';
import '../models/song.dart';
import 'audio_controller.dart';

class PlaylistController {
  PlaylistController._();
  static final instance = PlaylistController._();

  /// 🎵 PLAYLIST (queue hiện tại)
  final ValueNotifier<List<Song>> playlist =
  ValueNotifier<List<Song>>([]);

  /// ❤️ FAVORITES (lưu SongId)
  final ValueNotifier<Set<String>> favorites =
  ValueNotifier<Set<String>>({});

  /// ➕ ADD TO PLAYLIST (không trùng)
  void add(Song song) {
    final list = playlist.value;
    if (!list.any((s) => s.audioNetwork == song.audioNetwork)) {
      playlist.value = [...list, song];
    }
  }

  /// ▶️ PLAY FROM SONG (user chủ động chọn bài)
  /// - Nếu chưa có trong playlist → reset playlist từ bài này
  /// - Nếu có → cắt playlist từ bài này trở đi
  void playFrom(Song song) {
    final list = playlist.value;

    final index =
    list.indexWhere((s) => s.audioNetwork == song.audioNetwork);

    if (index == -1) {
      // chưa có → reset playlist
      playlist.value = [song];
    } else {
      // có → cắt từ bài này
      playlist.value = list.sublist(index);
    }
  }

  /// ❌ REMOVE SONG (vuốt xoá)
  void remove(Song song) {
    final list = [...playlist.value];
    final index =
    list.indexWhere((s) => s.audioNetwork == song.audioNetwork);

    if (index == -1) return;

    final isCurrent =
        AudioController.instance.currentSong.value?.audioNetwork ==
            song.audioNetwork;

    list.removeAt(index);
    playlist.value = list;

    // nếu xoá bài đang phát
    if (isCurrent) {
      if (list.isNotEmpty) {
        // ưu tiên bài kế tiếp
        final nextIndex =
        index < list.length ? index : list.length - 1;
        AudioController.instance.playSong(list[nextIndex]);
      } else {
        // hết playlist
        AudioController.instance.stop();
      }
    }
  }

  /// ▶️ PLAY FROM HERE (tap bài trong playlist)
  void playFromHere(Song song) {
    final list = playlist.value;
    final index =
    list.indexWhere((s) => s.audioNetwork == song.audioNetwork);

    if (index == -1) return;

    playlist.value = list.sublist(index);
    AudioController.instance.playSong(song);
  }

  // ======================
  // ❤️ FAVORITES
  // ======================

  /// ❤️ TOGGLE FAVORITE
  void toggleFavorite(Song song) {
    final favs = {...favorites.value};

    if (favs.contains(song.Songid)) {
      favs.remove(song.Songid);
    } else {
      favs.add(song.Songid);
    }

    favorites.value = favs;
  }

  /// ❤️ CHECK FAVORITE
  bool isFavorite(Song song) {
    return favorites.value.contains(song.Songid);
  }
}
