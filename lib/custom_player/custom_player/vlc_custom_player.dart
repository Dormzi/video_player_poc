// import 'dart:io';

// import 'package:flutter_vlc_player/flutter_vlc_player.dart';

// import 'custom_player_interface.dart';

// class VlcCustomPlayer implements ICustomPlayer {
//   final VlcPlayerController controller;
//   VlcCustomPlayer.file(String filePath) : controller = VlcPlayerController.file(File(filePath), hwAcc: HwAcc.FULL, options: VlcPlayerOptions(), autoPlay: true);
//   VlcCustomPlayer.network(String videoUrl) : controller = VlcPlayerController.network(videoUrl ?? "", hwAcc: HwAcc.FULL, options: VlcPlayerOptions(), autoPlay: true);

//   @override
//   Future<void> play() => controller.play();

//   @override
//   Future<void> pause() => controller.pause();

//   @override
//   Future<void> stop() => controller.stop();

//   @override
//   Future<void> seekTo(Duration position) => controller.seekTo(position);

//   @override
//   Future<Duration> getCurrentPosition() async => controller.value?.position ?? await controller.getPosition();

//   @override
//   Future<Duration> getDuration() async => controller.value?.duration ?? await controller.getDuration();

//   @override
//   void listenDuration(void Function(Duration position, Duration duration) listenerCallback) {
//     controller.addListener(() {
//       listenerCallback?.call(controller.value.position, controller.value.duration);
//     });
//   }

//   @override
//   void listenVideoEnd(void Function() listenerCallback) {
//     controller.addListener(() async {
//       if (controller.value.playingState == PlayingState.ended) {
//         await controller.stop();
//         listenerCallback?.call();
//       }
//     });
//   }

//   Future<void> dispose() async {
//     await controller.dispose();
//   }
// }
