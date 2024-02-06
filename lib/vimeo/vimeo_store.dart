import 'package:flutter/material.dart';

import 'failures.dart';
import 'vimeo_service.dart';
import 'vimeo_video_config.dart';

class VimeoVideoConfigStore extends ValueNotifier<VimeoState> {
  final VimeoService _vimeoService;
  VimeoVideoConfigStore(this._vimeoService) : super(const Initial$VimeoState());

  Future<void> loadUrl(String videoUrl) async {
    try {
      value = const Loading$VimeoState();
      final videoId = _vimeoService.getVideoId(videoUrl);
      final config = await _vimeoService.getVimeoVideoConfigFromId(videoId);
      value = Fetched$VimeoState(config);
    } on Failure catch (failure) {
      value = Failure$VimeoState(failure);
      rethrow;
    } catch (ex, stack) {
      value = UnexpectedError$VimeoState(exception: ex, stackTrace: stack);
      rethrow;
    }
  }
}

sealed class VimeoState {}

class Initial$VimeoState implements VimeoState {
  const Initial$VimeoState();
}

class Loading$VimeoState implements VimeoState {
  const Loading$VimeoState();
}

class Fetched$VimeoState implements VimeoState {
  final VimeoVideoConfig config;
  const Fetched$VimeoState(this.config);

  String get videoUrl =>
      config.request?.files?.progressive?.firstWhere((e) => e!.quality == '1080p')?.url ?? '';
}

sealed class Error$VimeoState implements VimeoState {
  final String message;
  const Error$VimeoState({required this.message});
}

class Failure$VimeoState extends Error$VimeoState {
  final Failure failure;
  Failure$VimeoState(this.failure) : super(message: failure.message);
}

class UnexpectedError$VimeoState extends Error$VimeoState {
  final Object exception;
  final StackTrace stackTrace;
  const UnexpectedError$VimeoState({required this.exception, required this.stackTrace})
      : super(message: 'Something unexpected happened');
}
