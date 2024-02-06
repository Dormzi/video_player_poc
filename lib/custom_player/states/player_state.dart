import '../core/notifier_store.dart';
import '../models/subtitle_model.dart';

class PlayerState implements StoreState {
  final bool isPlaying;
  final bool isVisibleMenu;
  final SubtitleModel selectedSubtitle;
  bool get isEnabledSubtitle => selectedSubtitle != const SubtitleModel.desactived();

  const PlayerState({
    required this.isPlaying,
    required this.isVisibleMenu,
    required this.selectedSubtitle,
  });

  const PlayerState.empty()
      : isPlaying = false,
        isVisibleMenu = true,
        selectedSubtitle = const SubtitleModel.desactived();

  PlayerState copyWith({
    bool? isPlaying,
    bool? isVisibleMenu,
    SubtitleModel? selectedSubtitle,
  }) {
    return PlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      isVisibleMenu: isVisibleMenu ?? this.isVisibleMenu,
      selectedSubtitle: selectedSubtitle ?? this.selectedSubtitle,
    );
  }
}
