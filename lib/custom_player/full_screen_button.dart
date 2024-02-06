import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'custom_player/flutter_custom_player.dart';
import 'flutter_player_widget.dart';

class FullScreenButton extends StatefulWidget {
  final FlutterCustomPlayer flutterCustomPlayer;
  final VideoPlayerController controller;
  final List<DeviceOrientation>? deviceOrientationsOnEnterFullScreen;
  final String videoUrl;
  const FullScreenButton({
    super.key,
    required this.controller,
    required this.deviceOrientationsOnEnterFullScreen,
    required this.flutterCustomPlayer,
    required this.videoUrl,
  });

  @override
  State<FullScreenButton> createState() => _FullScreenButtonState();
}

class _FullScreenButtonState extends State<FullScreenButton> {
  static const systemOverlaysAfterFullScreen = SystemUiOverlay.values;
  static const deviceOrientationsAfterFullScreen = DeviceOrientation.values;
  bool _isFullScreen = false;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_isFullScreen ? Icons.fullscreen_exit_rounded : Icons.fullscreen_rounded),
      onPressed: _pushFullScreenWidget,
      color: Colors.white,
      tooltip: 'Full screen',
    );
  }

  Future<dynamic> _pushFullScreenWidget() async {
    final TransitionRoute<void> route = PageRouteBuilder<void>(pageBuilder: _fullScreenRoutePageBuilder);

    onEnterFullScreen();

    WakelockPlus.enable();
    _isFullScreen = true;
    await Navigator.of(context, rootNavigator: true).push(route);
    setState(() {
      _isFullScreen = false;
    });
    // widget.controller.exitFullScreen();

    WakelockPlus.disable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: systemOverlaysAfterFullScreen);
    SystemChrome.setPreferredOrientations(deviceOrientationsAfterFullScreen);
  }

  Widget _fullScreenRoutePageBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // final controllerProvider = ChewieControllerProvider(
    //   controller: widget.controller,
    //   child: ChangeNotifierProvider<PlayerNotifier>.value(
    //     value: notifier,
    //     builder: (context, w) => const PlayerWithControls(),
    //   ),
    // );

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            alignment: Alignment.center,
            color: Colors.black,
            child: FlutterPlayerWidget.test(
              flutterCustomPlayer: widget.flutterCustomPlayer,
              videoUrl: widget.videoUrl,
            ),
          ),
        );
      },
    );
  }

  void onEnterFullScreen() {
    final videoWidth = widget.controller.value.size.width;
    final videoHeight = widget.controller.value.size.height;

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    // if (widget.controller.systemOverlaysOnEnterFullScreen != null) {
    //   /// Optional user preferred settings
    //   SystemChrome.setEnabledSystemUIMode(
    //     SystemUiMode.manual,
    //     overlays: widget.controller.systemOverlaysOnEnterFullScreen,
    //   );
    // } else {
    //   /// Default behavior
    //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    // }

    if (widget.deviceOrientationsOnEnterFullScreen != null) {
      /// Optional user preferred settings
      SystemChrome.setPreferredOrientations(widget.deviceOrientationsOnEnterFullScreen!);
    } else {
      final isLandscapeVideo = videoWidth > videoHeight;
      final isPortraitVideo = videoWidth < videoHeight;

      /// Default behavior
      /// Video w > h means we force landscape
      if (isLandscapeVideo) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }

      /// Video h > w means we force portrait
      else if (isPortraitVideo) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }

      /// Otherwise if h == w (square video)
      else {
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      }
    }
  }
}
