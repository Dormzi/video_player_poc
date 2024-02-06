// ignore_for_file: prefer_const_constructors

import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'web/web_stub.dart' if (dart.library.html) 'web/web_player.dart';
import 'log_video_player_controller.dart';
import 'vimeo_service.dart';
import 'vimeo_store.dart';

class VimeoPlayer extends StatefulWidget {
  final String url;
  const VimeoPlayer({super.key, required this.url});

  @override
  State<VimeoPlayer> createState() => _VimeoPlayerState();
}

class _VimeoPlayerState extends State<VimeoPlayer> {
  late VimeoVideoConfigStore store;
  VideoPlayerController? videoPlayerController;
  // CustomVideoPlayerController? _customVideoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    final service = VimeoService(dio);
    store = VimeoVideoConfigStore(service);
    store.loadUrl(widget.url).then((_) {
      final state = store.value;
      if (state is Fetched$VimeoState) {
        videoPlayerController = LogVideoPlayerController.network(state.videoUrl)
          ..initialize().then((value) => setState(() {}));
        _chewieController = ChewieController(
          videoPlayerController: videoPlayerController!,
          autoPlay: false,
          looping: false,
          aspectRatio: 16 / 9,
        );
        // _customVideoPlayerController = CustomVideoPlayerController(
        //     context: context,
        //     videoPlayerController: videoPlayerController!,
        //     customVideoPlayerSettings: CustomVideoPlayerSettings(allowVolumeOnSlide: true)
        //     // customVideoPlayerSettings: CustomVideoPlayerSettings(
        //     //   customVideoPlayerPopupSettings: CustomVideoPlayerPopupSettings(),
        //     // ),
        //     );
      }
    });
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    _chewieController?.dispose();
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VimeoState>(
      valueListenable: store,
      builder: (context, state, child) {
        return switch (state) {
          Initial$VimeoState() => Container(),
          Loading$VimeoState() => const Center(child: CircularProgressIndicator()),
          Error$VimeoState(message: var message) => Center(child: Text(message)),
          Fetched$VimeoState(videoUrl: var videoUrl) => Center(
              child: (_chewieController == null)
                  ? null
                  : AspectRatio(
                      aspectRatio: 16 / 9,
                      child: kIsWeb ? WebPlayer(videoUrl: videoUrl) : Chewie(controller: _chewieController!),
                      // child: Chewie(controller: _chewieController!),
                      // child: WebPlayer(videoUrl: videoUrl),
                    ),
              // : FlutterPlayerWidget(videoUrl: videoUrl),
              // : CustomVideoPlayer(customVideoPlayerController: _customVideoPlayerController!),
            ),
        };
      },
    );
  }
}
