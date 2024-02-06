import 'package:video_player/video_player.dart';

import '../core/notifier_store.dart';
import '../models/subtitle_model.dart';

class FlutterPlayerState implements StoreState {
  final VideoPlayerController? controller;
  final List<SubtitleModel>? subtitles;

  FlutterPlayerState({this.controller, this.subtitles});

  FlutterPlayerState copyWith({
    VideoPlayerController? controller,
    List<SubtitleModel>? subtitles,
  }) {
    return FlutterPlayerState(
      controller: controller ?? this.controller,
      subtitles: subtitles ?? this.subtitles,
    );
  }
}
