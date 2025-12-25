import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import '../models/song.dart';
import 'playlist_controller.dart';

class AudioController {
  AudioController._internal() {
    // 🔊 cập nhật position
    player.positionStream.listen((p) {
      position.value = p;
    });

    // ⏱ cập nhật duration
    player.durationStream.listen((d) {
      if (d != null) duration.value = d;
    });

    // 🔥 TỰ ĐỘNG CHUYỂN BÀI KHI HẾT
    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (isRepeatOne.value) {
          // 🔁 repeat 1 bài
          player.seek(Duration.zero);
          player.play();
        } else {
          // ▶️ sang bài tiếp theo trong playlist
          PlaylistController.instance.playNext();
        }
      }
    });
  }

  static final AudioController instance = AudioController._internal();

  final AudioPlayer player = AudioPlayer();

  /// 🎵 bài hiện tại
  final ValueNotifier<Song?> currentSong = ValueNotifier(null);

  /// 🔁 repeat one
  final ValueNotifier<bool> isRepeatOne = ValueNotifier(false);

  /// 🔊 cho mini progress
  final ValueNotifier<Duration> position =
  ValueNotifier(Duration.zero);
  final ValueNotifier<Duration> duration =
  ValueNotifier(Duration.zero);

  /// ▶️ PLAY SONG
  Future<void> playSong(Song song) async {
    // 🔥 đảm bảo bài nằm trong playlist
    PlaylistController.instance.ensureInPlaylist(song);

    if (currentSong.value?.audioNetwork != song.audioNetwork) {
      await player.setUrl(song.audioNetwork);
      currentSong.value = song;
    }

    player.play();
  }

  /// ⏪⏩ SEEK
  void seekBy(int seconds) {
    final pos = player.position;
    final dur = player.duration ?? Duration.zero;

    final target = pos + Duration(seconds: seconds);

    if (target < Duration.zero) {
      player.seek(Duration.zero);
    } else if (target > dur) {
      player.seek(dur);
    } else {
      player.seek(target);
    }
  }

  void seekForward([int seconds = 10]) => seekBy(seconds);
  void seekBackward([int seconds = 10]) => seekBy(-seconds);

  /// ▶️ / ⏸️
  void togglePlay() {
    player.playing ? player.pause() : player.play();
  }

  /// ⛔ STOP
  void stop() {
    player.stop();
    currentSong.value = null;
  }

  /// 🔁 TOGGLE REPEAT
  Future<void> toggleRepeat() async {
    isRepeatOne.value = !isRepeatOne.value;
    await player.setLoopMode(
      isRepeatOne.value ? LoopMode.one : LoopMode.off,
    );
  }
}
