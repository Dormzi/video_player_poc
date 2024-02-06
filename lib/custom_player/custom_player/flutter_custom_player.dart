import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

import 'custom_player_interface.dart';

typedef ListenDurationCallback = void Function(Duration position, Duration duration);

class FlutterCustomPlayer implements ICustomPlayer {
  final VideoPlayerController controller;
  FlutterCustomPlayer.file(String filePath) : controller = VideoPlayerController.file(File(filePath));
  FlutterCustomPlayer.network(String videoUrl) : controller = VideoPlayerController.network(videoUrl);

  bool isInitialized = false;

  bool get isCompleted =>
      controller.value.isInitialized && controller.value.position >= controller.value.duration;

  @override
  Future<void> initialize() async {
    if (!isInitialized) {
      isInitialized = true;
      await controller.initialize();
    }
  }

  @override
  Future<void> play() => controller.play();

  @override
  Future<void> pause() => controller.pause();

  @override
  Future<void> stop() async {
    await controller.pause();
    await controller.seekTo(Duration.zero);
  }

  @override
  Future<void> seekTo(Duration position) => controller.seekTo(position);

  @override
  Future<Duration> getCurrentPosition() async => controller.value.position; // ?? await controller.position;

  @override
  Future<Duration> getDuration() async => controller.value.duration; // ?? await controller.getDuration();

  @override
  VoidCallback listenDuration(ListenDurationCallback callback) {
    void listener() {
      callback.call(controller.value.position, controller.value.duration);
    }

    controller.addListener(listener);
    return () => controller.removeListener(listener);
  }

  @override
  VoidCallback listenVideoEnd(void Function() listenerCallback) {
    void listener() async {
      if (isCompleted) {
        await stop();
        listenerCallback.call();
      }
    }

    controller.addListener(listener);
    return () => controller.removeListener(listener);
  }

  Future<void> dispose() async {
    await controller.dispose();
  }
}
