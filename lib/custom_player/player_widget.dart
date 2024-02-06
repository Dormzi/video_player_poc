// import 'dart:developer';

// import 'package:appp/app/widgets/back_button/back_button_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_modular/flutter_modular.dart';
// import 'package:flutter_vlc_player/flutter_vlc_player.dart';
// import 'package:rx_notifier/rx_notifier.dart';

// import 'custom_player/vlc_custom_player.dart';
// import 'models/subtitle_model.dart';
// import 'states/player_state.dart';
// import 'stores/player_store.dart';
// import 'stores/subtitle_store.dart';
// import 'subtitle_widget.dart';
// import 'timer_widget.dart';

// class PlayerWidget extends StatefulWidget {
//   final String videoUrl;
//   final List<SubtitleModel> subtitles;
//   final VlcCustomPlayer? vlcCustomPlayer;
//   PlayerWidget._(
//       {super.key, required this.videoUrl, List<SubtitleModel> subtitles = const [], this.vlcCustomPlayer})
//       : subtitles = [...subtitles, const SubtitleModel.desactived()];
//   factory PlayerWidget({Key? key, required String videoUrl, List<SubtitleModel> subtitles = const []}) {
//     return PlayerWidget._(key: key, videoUrl: videoUrl, subtitles: subtitles, vlcCustomPlayer: null);
//   }

//   factory PlayerWidget.test({
//     Key? key,
//     required String videoUrl,
//     List<SubtitleModel> subtitles = const [],
//     VlcCustomPlayer? vlcCustomPlayer,
//   }) {
//     return PlayerWidget._(
//         key: key, videoUrl: videoUrl, subtitles: subtitles, vlcCustomPlayer: vlcCustomPlayer);
//   }

//   @override
//   State<PlayerWidget> createState() => _PlayerWidgetState();
// }

// class _PlayerWidgetState extends State<PlayerWidget> {
//   late VlcCustomPlayer vlcCustomPlayer;
//   late SubtitleStore subtitleStore;
//   late PlayerStore playerStore;

//   VoidCallback? subtitleListenerDisposer;
//   final double aspectRatio = 16 / 9;

//   @override
//   void initState() {
//     super.initState();
//     vlcCustomPlayer = widget.vlcCustomPlayer ?? VlcCustomPlayer.network(widget.videoUrl);
//     subtitleStore = SubtitleStore(vlcCustomPlayer);
//     playerStore = PlayerStore(vlcCustomPlayer);

//     subtitleListenerDisposer = playerStore.observer(onState: (state) {
//       if (state.selectedSubtitle != subtitleStore.state.selectedSubtitle) {
//         subtitleStore.changeSubtitle(state.selectedSubtitle);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     vlcCustomPlayer.dispose();

//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//     ]);

//     playerStore.destroy();
//     subtitleListenerDisposer?.call();
//     subtitleStore.destroy();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.black,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           GestureDetector(
//             onTap: playerStore.toggleMenuVisibility,
//             child: LayoutBuilder(builder: (context, constraints) {
//               return AspectRatio(
//                 aspectRatio: aspectRatio,
//                 child: Stack(
//                   fit: StackFit.expand,
//                   children: [
//                     // Image.network(
//                     //   "https://observatoriodocinema.uol.com.br/wp-content/uploads/2020/08/Santana-netflix.jpg",
//                     //   fit: BoxFit.cover,
//                     // ),
//                     Container(color: Colors.black),
//                     VlcPlayer(
//                       controller: vlcCustomPlayer.controller,
//                       aspectRatio: aspectRatio,
//                       placeholder: const Center(child: CircularProgressIndicator()),
//                     ),
//                     RxBuilder(builder: (context) {
//                       if (subtitleStore.state.currentCaption.isNone) return Container();
//                       return Align(
//                         alignment: Alignment.bottomCenter,
//                         child: Container(
//                           color: Colors.black,
//                           margin: const EdgeInsets.only(bottom: 50),
//                           padding: const EdgeInsets.all(2),
//                           child: Text(
//                             subtitleStore.state.currentCaption.text,
//                             style: const TextStyle(color: Colors.white, fontSize: 17),
//                           ),
//                         ),
//                       );
//                     }),
//                     Positioned.fill(
//                       child: ValueListenableBuilder(
//                         valueListenable: playerStore,
//                         builder: (context, PlayerState state, child) {
//                           return AnimatedCrossFade(
//                             duration: const Duration(milliseconds: 300),
//                             alignment: Alignment.center,
//                             firstCurve: Curves.ease,
//                             secondCurve: Curves.ease,
//                             crossFadeState:
//                                 state.isVisibleMenu ? CrossFadeState.showFirst : CrossFadeState.showSecond,
//                             secondChild: Container(),
//                             firstChild: AbsorbPointer(
//                               absorbing: !state.isVisibleMenu,
//                               child: Container(
//                                 color: Colors.black26,
//                                 height: constraints.maxHeight,
//                                 alignment: Alignment.center,
//                                 child: InkWell(
//                                   mouseCursor: SystemMouseCursors.click,
//                                   onTap: playerStore.togglePlayPause,
//                                   child: Icon(
//                                     state.isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline,
//                                     color: Colors.white,
//                                     size: 50,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 0,
//                       left: 0,
//                       right: 0,
//                       child: RxBuilder(builder: (context) {
//                         return ClipRRect(
//                           child: AnimatedAlign(
//                             alignment: Alignment.topCenter,
//                             duration: const Duration(milliseconds: 300),
//                             curve: Curves.ease,
//                             heightFactor: playerStore.state.isVisibleMenu ? 1 : 0,
//                             child: Container(
//                               width: constraints.maxWidth,
//                               color: Colors.black54,
//                               child: Row(
//                                 children: [
//                                   const SizedBox(width: 15),
//                                   Expanded(
//                                       child: TimerWidget(
//                                           customPlayer: vlcCustomPlayer, playerStore: playerStore)),
//                                   const SizedBox(width: 15),
//                                   SubtitleWidget(playerStore: playerStore, subtitlesList: widget.subtitles),
//                                   const SizedBox(width: 15),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       }),
//                     ),
//                   ],
//                 ),
//               );
//             }),
//           ),
//           AnimatedBuilder(
//             animation: vlcCustomPlayer.controller,
//             builder: (context, snapshot) {
//               bool controllerIsLoading =
//                   vlcCustomPlayer.controller.value.playingState == PlayingState.initializing;
//               if (controllerIsLoading) {
//                 return SizedBox.expand(
//                     child: Container(
//                         color: Colors.black54,
//                         alignment: Alignment.center,
//                         child: const CircularProgressIndicator()));
//               } else {
//                 return Container();
//               }
//             },
//           ),
//           Positioned(
//             top: MediaQuery.of(context).viewPadding.top + 15,
//             left: 15,
//             child: BackButtonWidget(onTap: () async {
//               if (vlcCustomPlayer.controller.value.isPlaying)
//                 vlcCustomPlayer.stop().then((value) => log("stopped"));
//               Modular.to.pop();
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }
