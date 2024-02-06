import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:video_player/video_player.dart';

import 'custom_player/flutter_custom_player.dart';
import 'full_screen_button.dart';
import 'models/subtitle_model.dart';
import 'stores/player_store.dart';
import 'stores/subtitle_store.dart';
import 'subtitle_widget.dart';
import 'timer_widget.dart';

class FlutterPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final List<SubtitleModel> subtitles;
  final FlutterCustomPlayer? flutterCustomPlayer;
  FlutterPlayerWidget._(
      {super.key, required this.videoUrl, List<SubtitleModel> subtitles = const [], this.flutterCustomPlayer})
      : subtitles = [...subtitles, const SubtitleModel.desactived()];

  factory FlutterPlayerWidget(
      {Key? key, required String videoUrl, List<SubtitleModel> subtitles = const []}) {
    return FlutterPlayerWidget._(
        key: key, videoUrl: videoUrl, subtitles: subtitles, flutterCustomPlayer: null);
  }

  factory FlutterPlayerWidget.test({
    Key? key,
    required String videoUrl,
    List<SubtitleModel> subtitles = const [],
    FlutterCustomPlayer? flutterCustomPlayer,
  }) {
    return FlutterPlayerWidget._(
        key: key, videoUrl: videoUrl, subtitles: subtitles, flutterCustomPlayer: flutterCustomPlayer);
  }

  @override
  State<FlutterPlayerWidget> createState() => _FlutterPlayerWidgetState();
}

class _FlutterPlayerWidgetState extends State<FlutterPlayerWidget> {
  late FlutterCustomPlayer flutterCustomPlayer;
  late SubtitleStore subtitleStore;
  late PlayerStore playerStore;

  VoidCallback? subtitleListenerDisposer;
  final double aspectRatio = 16 / 9;

  @override
  void initState() {
    super.initState();
    flutterCustomPlayer = widget.flutterCustomPlayer ?? FlutterCustomPlayer.network(widget.videoUrl);
    subtitleStore = SubtitleStore(flutterCustomPlayer);
    playerStore = PlayerStore(flutterCustomPlayer);

    subtitleListenerDisposer = playerStore.observer(onState: (state) {
      if (state.selectedSubtitle != subtitleStore.state.selectedSubtitle) {
        subtitleStore.changeSubtitle(state.selectedSubtitle);
      }
    });

    flutterCustomPlayer.initialize();
  }

  @override
  void dispose() {
    if (widget.flutterCustomPlayer == null) flutterCustomPlayer.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    playerStore.destroy();
    subtitleListenerDisposer?.call();
    subtitleStore.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => playerStore.showMenu(),
      onExit: (event) => playerStore.runOrCancelMenuHiddenTimeout(),
      child: Material(
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: playerStore.toggleMenuVisibility,
              child: LayoutBuilder(builder: (context, constraints) {
                return AspectRatio(
                  aspectRatio: aspectRatio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Image.network(
                      //   "https://observatoriodocinema.uol.com.br/wp-content/uploads/2020/08/Santana-netflix.jpg",
                      //   fit: BoxFit.cover,
                      // ),
                      Container(color: Colors.black),
                      AspectRatio(
                        aspectRatio: aspectRatio,
                        child: VideoPlayer(flutterCustomPlayer.controller),
                        // placeholder: const Center(child: CircularProgressIndicator()),
                      ),
                      RxBuilder(builder: (context) {
                        if (subtitleStore.state.currentCaption.isNone) return Container();
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            color: Colors.black,
                            margin: const EdgeInsets.only(bottom: 50),
                            padding: const EdgeInsets.all(2),
                            child: Text(
                              subtitleStore.state.currentCaption.text,
                              style: const TextStyle(color: Colors.white, fontSize: 17),
                            ),
                          ),
                        );
                      }),
                      Positioned.fill(
                        child: RxBuilder(
                          builder: (context) {
                            return AnimatedCrossFade(
                              duration: const Duration(milliseconds: 300),
                              alignment: Alignment.center,
                              firstCurve: Curves.ease,
                              secondCurve: Curves.ease,
                              crossFadeState: playerStore.state.isVisibleMenu
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              secondChild: Container(),
                              firstChild: AbsorbPointer(
                                absorbing: !playerStore.state.isVisibleMenu,
                                child: Container(
                                  color: Colors.black26,
                                  height: constraints.maxHeight,
                                  alignment: Alignment.center,
                                  child: InkWell(
                                    mouseCursor: SystemMouseCursors.click,
                                    onTap: playerStore.togglePlayPause,
                                    child: Icon(
                                      playerStore.state.isPlaying
                                          ? Icons.pause_circle_outline
                                          : Icons.play_circle_outline,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: RxBuilder(builder: (context) {
                          return ClipRRect(
                            child: AnimatedAlign(
                              alignment: Alignment.topCenter,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                              heightFactor: playerStore.state.isVisibleMenu ? 1 : 0,
                              child: Container(
                                width: constraints.maxWidth,
                                color: Colors.black54,
                                child: Row(
                                  children: [
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: TimerWidget(
                                        customPlayer: flutterCustomPlayer,
                                        playerStore: playerStore,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    SubtitleWidget(playerStore: playerStore, subtitlesList: widget.subtitles),
                                    const SizedBox(width: 15),
                                    FullScreenButton(
                                      controller: flutterCustomPlayer.controller,
                                      flutterCustomPlayer: flutterCustomPlayer,
                                      videoUrl: widget.videoUrl,
                                      deviceOrientationsOnEnterFullScreen: const [
                                        DeviceOrientation.landscapeLeft,
                                        DeviceOrientation.landscapeRight
                                      ],
                                    ),
                                    const SizedBox(width: 15),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                );
              }),
            ),
            AnimatedBuilder(
              animation: flutterCustomPlayer.controller,
              builder: (context, snapshot) {
                bool controllerIsLoading = !flutterCustomPlayer.controller.value.isInitialized;
                if (controllerIsLoading) {
                  return SizedBox.expand(
                    child: Container(
                      color: Colors.black54,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
