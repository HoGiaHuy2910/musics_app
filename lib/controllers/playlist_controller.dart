import 'package:flutter/material.dart';
import '../models/song.dart';
import 'audio_controller.dart';

class PlaylistController {
  PlaylistController._();
  static final instance = PlaylistController._();

  /// 🎵 PLAYLIST (queue)
  final ValueNotifier<List<Song>> playlist =
  ValueNotifier<List<Song>>([]);

  /// ❤️ FAVORITES (songId)
  final ValueNotifier<Set<String>> favorites =
  ValueNotifier<Set<String>>({});

  /// 💿 FAVORITE ALBUMS
  final ValueNotifier<Set<String>> favoriteAlbums =
  ValueNotifier<Set<String>>({});

  // ======================
  // 🎵 PLAYLIST LOGIC
  // ======================

  /// ➕ ADD (không trùng)
  void add(Song song) {
    final list = playlist.value;
    if (!list.any((s) => s.audioNetwork == song.audioNetwork)) {
      playlist.value = [...list, song];
    }
  }

  /// ✅ ĐẢM BẢO BÀI ĐANG PHÁT CÓ TRONG PLAYLIST
  /// - Chỉ add nếu chưa có
  /// - KHÔNG reset, KHÔNG cắt, KHÔNG reorder
  void ensureInPlaylist(Song song) {
    add(song);
  }


  /// 🔁 Đưa bài được chọn lên đầu
  /// - bài đang ở đầu → xuống cuối
  /// - bài được chọn → lên đầu
  void playFromHere(Song song) {
    final list = [...playlist.value];
    final index =
    list.indexWhere((s) => s.audioNetwork == song.audioNetwork);

    if (index == -1) {
      // chưa có → add lên đầu
      playlist.value = [song, ...list];
      AudioController.instance.playSong(song);
      return;
    }

    final current = list.removeAt(index);

    if (list.isNotEmpty) {
      // bài đang đầu cũ → đẩy xuống cuối
      final oldHead = list.removeAt(0);
      list.add(oldHead);
    }

    playlist.value = [current, ...list];
    AudioController.instance.playSong(current);
  }

  /// ▶️ AUTO NEXT (khi hết bài)
  void playNext() {
    final list = [...playlist.value];
    if (list.length <= 1) return;

    final current = list.removeAt(0);
    list.add(current);

    playlist.value = list;
    AudioController.instance.playSong(list.first);
  }

  /// ❌ REMOVE
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

    if (isCurrent && list.isNotEmpty) {
      AudioController.instance.playSong(list.first);
    }

    if (list.isEmpty) {
      AudioController.instance.stop();
    }
  }

  // ======================
  // ❤️ FAVORITES SONG
  // ======================

  void toggleFavorite(Song song) {
    final favs = {...favorites.value};
    if (favs.contains(song.Songid)) {
      favs.remove(song.Songid);
    } else {
      favs.add(song.Songid);
    }
    favorites.value = favs;
  }

  bool isFavorite(Song song) {
    return favorites.value.contains(song.Songid);
  }

  // ======================
  // 💿 FAVORITE ALBUM
  // ======================

  void toggleFavoriteAlbum(String albumId) {
    final favs = {...favoriteAlbums.value};
    if (favs.contains(albumId)) {
      favs.remove(albumId);
    } else {
      favs.add(albumId);
    }
    favoriteAlbums.value = favs;
  }

  bool isFavoriteAlbum(String albumId) {
    return favoriteAlbums.value.contains(albumId);
  }
}
