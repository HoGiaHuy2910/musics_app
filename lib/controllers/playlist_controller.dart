import 'package:flutter/material.dart';
import '../models/song.dart';
import 'audio_controller.dart';
import '../repositories/favorite_repository.dart';
import '../repositories/follow_repository.dart';

class PlaylistController {
  PlaylistController._() {
    _bindFavorites();
    _bindFollowingArtists();
  }

  static final instance = PlaylistController._();

  final _favoriteRepo = FavoriteRepository();
  final _followRepo = FollowRepository();

  /// 🎵 PLAYLIST (queue)
  final ValueNotifier<List<Song>> playlist =
  ValueNotifier<List<Song>>([]);

  /// ❤️ FAVORITES (songId) – SYNC FIRESTORE
  final ValueNotifier<Set<String>> favorites =
  ValueNotifier<Set<String>>({});

  /// 💿 FAVORITE ALBUMS – SYNC FIRESTORE
  final ValueNotifier<Set<String>> favoriteAlbums =
  ValueNotifier<Set<String>>({});

  /// ➕ FOLLOWING ARTISTS – SYNC FIRESTORE
  final ValueNotifier<Set<String>> followingArtists =
  ValueNotifier<Set<String>>({});

  // ======================
  // 🔥 FIRESTORE BINDING
  // ======================

  void _bindFavorites() {
    _favoriteRepo.favoriteSongsStream().listen((data) {
      favorites.value = data;
    });

    _favoriteRepo.favoriteAlbumsStream().listen((data) {
      favoriteAlbums.value = data;
    });
  }

  void _bindFollowingArtists() {
    _followRepo.followingArtistsStream().listen((data) {
      followingArtists.value = data;
    });
  }

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
  void ensureInPlaylist(Song song) {
    add(song);
  }

  /// 🔁 Đưa bài được chọn lên đầu
  void playFromHere(Song song) {
    final list = [...playlist.value];
    final index =
    list.indexWhere((s) => s.audioNetwork == song.audioNetwork);

    if (index == -1) {
      playlist.value = [song, ...list];
      AudioController.instance.playSong(song);
      return;
    }

    final current = list.removeAt(index);

    if (list.isNotEmpty) {
      final oldHead = list.removeAt(0);
      list.add(oldHead);
    }

    playlist.value = [current, ...list];
    AudioController.instance.playSong(current);
  }

  /// ▶️ AUTO NEXT
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
  // ❤️ FAVORITE SONG (FIRESTORE)
  // ======================

  void toggleFavorite(Song song) {
    _favoriteRepo.toggleFavoriteSong(song.Songid);
  }

  bool isFavorite(Song song) {
    return favorites.value.contains(song.Songid);
  }

  // ======================
  // 💿 FAVORITE ALBUM (FIRESTORE)
  // ======================

  void toggleFavoriteAlbum(String albumId) {
    _favoriteRepo.toggleFavoriteAlbum(albumId);
  }

  bool isFavoriteAlbum(String albumId) {
    return favoriteAlbums.value.contains(albumId);
  }

  // ======================
  // ➕ FOLLOW ARTIST (FIRESTORE)
  // ======================

  void toggleFollowArtist(String artistId) {
    _followRepo.toggleFollowArtist(artistId);
  }

  bool isFollowingArtist(String artistId) {
    return followingArtists.value.contains(artistId);
  }
}
