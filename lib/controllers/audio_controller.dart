import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import '../models/song.dart';
import 'playlist_controller.dart';

class AudioController {
  AudioController._internal() {
    // 🔊 position cho mini + now playing
    player.positionStream.listen((p) {
      position.value = p;
    });

    // ⏱ duration cho mini + now playing
    player.durationStream.listen((d) {
      if (d != null) duration.value = d;
    });

    // 🔁 FIX repeat + sync progress
    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed &&
          isRepeatOne.value) {
        player.seek(Duration.zero);
        player.play();
      }
    });
  }

  static final AudioController instance = AudioController._internal();

  final AudioPlayer player = AudioPlayer();

  // 🎵 Bài hiện tại
  final ValueNotifier<Song?> currentSong = ValueNotifier(null);

  // 🔁 Repeat 1
  final ValueNotifier<bool> isRepeatOne = ValueNotifier(false);

  // 🔊 Cho mini progress
  final ValueNotifier<Duration> position =
  ValueNotifier(Duration.zero);
  final ValueNotifier<Duration> duration =
  ValueNotifier(Duration.zero);

  Future<void> playSong(Song song) async {
    // 🔥 LUÔN ĐẢM BẢO BÀI ĐANG PHÁT CÓ TRONG PLAYLIST
    PlaylistController.instance.playFrom(song);

    if (currentSong.value?.audioAsset != song.audioAsset) {
      await player.setAsset(song.audioAsset);
      currentSong.value = song;
    }
    player.play();
  }

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

  void seekForward([int seconds = 10]) {
    seekBy(seconds);
  }

  void seekBackward([int seconds = 10]) {
    seekBy(-seconds);
  }

  void togglePlay() {
    player.playing ? player.pause() : player.play();
  }

  // ⛔ STOP (🔥 BẠN THIẾU CÁI NÀY)
  void stop() {
    player.stop();
    currentSong.value = null;
  }

  Future<void> toggleRepeat() async {
    isRepeatOne.value = !isRepeatOne.value;
    await player.setLoopMode(
      isRepeatOne.value ? LoopMode.one : LoopMode.off,
    );
  }
}
