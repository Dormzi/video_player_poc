import 'dart:async';

import '../core/notifier_store.dart';
// import 'package:wakelock/wakelock.dart';

import '../custom_player/custom_player_interface.dart';
import '../models/subtitle_model.dart';
import '../states/player_state.dart';

const TIME_TO_CLOSE_MENU = Duration(seconds: 3);

class PlayerStore extends NotifierStore<PlayerState> {
  final ICustomPlayer customPlayer;
  PlayerStore(this.customPlayer) : super(PlayerState.empty()) {
    customPlayer.listenVideoEnd(() => update(state.copyWith(isPlaying: false)));
  }
  StreamSubscription? closeMenuTimeOutSubscription;

  Future<void> togglePlayPause() async {
    update(state.copyWith(isPlaying: !state.isPlaying));

    await runOrCancelMenuHiddenTimeout();
    if (state.isPlaying) {
      await customPlayer.play();
      // await Wakelock.enable();
    } else {
      await customPlayer.pause();
      // await Wakelock.disable();
    }
  }

  Future<void> toggleMenuVisibility() async {
    update(state.copyWith(isVisibleMenu: !state.isVisibleMenu));
    await runOrCancelMenuHiddenTimeout();
  }

  Future<void> showMenu() async {
    update(state.copyWith(isVisibleMenu: true));
    await cancelMenuHiddenTimeout();
  }

  Future<void> onSubtitleListOpen() => cancelMenuHiddenTimeout();
  Future<void> onSubtitleListClose() => runOrCancelMenuHiddenTimeout();
  Future<void> onSubtitleChanged(SubtitleModel model) async {
    update(state.copyWith(selectedSubtitle: model));
    await cancelMenuHiddenTimeout();
    await runOrCancelMenuHiddenTimeout();
  }

  Future<void> cancelMenuHiddenTimeout() async {
    await closeMenuTimeOutSubscription?.cancel();
    closeMenuTimeOutSubscription = null;
  }

  Future<void> runOrCancelMenuHiddenTimeout() async {
    if (state.isVisibleMenu && state.isPlaying) {
      bool menuIsTimingOut = closeMenuTimeOutSubscription != null;
      if (menuIsTimingOut) await cancelMenuHiddenTimeout();
      closeMenuTimeOutSubscription = Future.delayed(TIME_TO_CLOSE_MENU)
          .asStream()
          .listen((event) => update(state.copyWith(isVisibleMenu: false)));
    } else {
      await cancelMenuHiddenTimeout();
    }
  }
}
