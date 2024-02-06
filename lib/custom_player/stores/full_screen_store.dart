import '../core/notifier_store.dart';
import '../custom_player/custom_player_interface.dart';
import '../states/timer_state.dart';
import 'player_store.dart';

class FullScreenStore extends NotifierStore<TimerState> {
  final PlayerStore playerStore;
  final ICustomPlayer customPlayer;
  FullScreenStore(this.playerStore, this.customPlayer) : super(const TimerState.empty()) {
    customPlayer.listenDuration((position, duration) {
      update(state.copyWith(duration: duration, position: position));
    });
  }

  Future<void> next15Seconds() async {
    playerStore.cancelMenuHiddenTimeout();
    playerStore.runOrCancelMenuHiddenTimeout();
    final currentPosition = await customPlayer.getCurrentPosition();
    final duration = await customPlayer.getDuration();
    final nextPosition = currentPosition + const Duration(seconds: 15);
    if (nextPosition <= duration) await customPlayer.seekTo(nextPosition);
  }

  Future<void> prev15Seconds() async {
    playerStore.cancelMenuHiddenTimeout();
    playerStore.runOrCancelMenuHiddenTimeout();
    final currentPosition = await customPlayer.getCurrentPosition();
    final nextPosition = currentPosition - const Duration(seconds: 15);
    if (nextPosition >= Duration.zero) await customPlayer.seekTo(nextPosition);
  }
}
