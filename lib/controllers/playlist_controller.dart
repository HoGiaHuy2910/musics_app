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

  /// 💿 FAVORITE ALBUMS
  final ValueNotifier<Set<String>> favoriteAlbums =
  ValueNotifier<Set<String>>({});

  // ======================
  // 🎵 PLAYLIST
  // ======================

  /// ✅ đảm bảo bài có trong playlist (dùng khi add từ menu ⋮)
  void ensureInPlaylist(Song song) {
    final list = playlist.value;
    if (!list.any((s) => s.audioNetwork == song.audioNetwork)) {
      playlist.value = [...list, song];
    }
  }

  /// ➕ ADD TO PLAYLIST (không trùng)
  void add(Song song) {
    ensureInPlaylist(song);
  }

  /// ▶️ PLAY FROM SONG (user chủ động chọn bài)
  /// - Nếu chưa có trong playlist → reset playlist từ bài này
  /// - Nếu có → cắt playlist từ bài này trở đi
  void playFrom(Song song) {
    final list = playlist.value;

    final index =
    list.indexWhere((s) => s.audioNetwork == song.audioNetwork);

    if (index == -1) {
      playlist.value = [song];
    } else {
      playlist.value = list.sublist(index);
    }
  }

  /// ▶️ PLAY NEXT (tự chuyển bài khi hết bài)
  void playNext() {
    final list = playlist.value;
    if (list.isEmpty) {
      AudioController.instance.stop();
      return;
    }

    final current = AudioController.instance.currentSong.value;

    // nếu chưa có current -> play bài đầu tiên
    if (current == null) {
      AudioController.instance.playSong(list.first);
      return;
    }

    final index = list.indexWhere(
          (s) => s.audioNetwork == current.audioNetwork,
    );

    // nếu không tìm thấy current -> play bài đầu tiên
    if (index == -1) {
      AudioController.instance.playSong(list.first);
      return;
    }

    // nếu còn bài kế tiếp
    if (index + 1 < list.length) {
      AudioController.instance.playSong(list[index + 1]);
    } else {
      // hết playlist -> stop
      AudioController.instance.stop();
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

    // nếu xoá bài đang phát -> chuyển bài tiếp theo / stop
    if (isCurrent) {
      playNext();
    }
  }

  /// ▶️ PLAY FROM HERE (tap bài trong playlist)
  void playFromHere(Song song) {
    final list = playlist.value;
    final index =
    list.indexWhere((s) => s.audioNetwork == song.audioNetwork);

    if (index == -1) return;

    AudioController.instance.playSong(song);
  }

  // ======================
  // ❤️ FAVORITES
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
  // 💿 FAVORITE ALBUMS
  // ======================

  void toggleFavoriteAlbum(String albumId) {
    final favs = favoriteAlbums.value;

    if (favs.contains(albumId)) {
      favs.remove(albumId);
    } else {
      favs.add(albumId);
    }

    favoriteAlbums.value = {...favs};
  }

  bool isFavoriteAlbum(String albumId) {
    return favoriteAlbums.value.contains(albumId);
  }
}
