import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

class LogVideoPlayerController extends VideoPlayerController {
  LogVideoPlayerController.file(super.file, {Future<dynamic>? closedCaptionFile}) : super.file();
  LogVideoPlayerController.network(super.dataSource, {Future<dynamic>? closedCaptionFile}) : super.network();
  LogVideoPlayerController.asset(super.dataSource, {Future<dynamic>? closedCaptionFile}) : super.asset();

  VoidCallback? listenerDisposer;

  bool get isCompleted => value.isInitialized && value.position >= value.duration;

  @override
  Future<void> initialize() async {
    await super.initialize();
    void listener() {
      if (isCompleted) {
        print('--- CustomVideoPlayerController: completed(${value.position})');
        // super.seekTo(Duration.zero);
        // super.pause();
      }
    }

    addListener(listener);
    listenerDisposer = () => removeListener(listener);
  }

  @override
  Future<void> dispose() async {
    listenerDisposer?.call();
    await super.dispose();
  }

  @override
  Future<void> seekTo(Duration position) {
    if (!isCompleted) print('--- CustomVideoPlayerController: seekTo($position)');
    return super.seekTo(position);
  }

  @override
  Future<void> pause() {
    if (!isCompleted) print('--- CustomVideoPlayerController: pause(${value.position})');
    return super.pause();
  }

  @override
  Future<void> play() {
    if (!isCompleted) print('--- CustomVideoPlayerController: play(${value.position})');
    return super.play();
  }
}
