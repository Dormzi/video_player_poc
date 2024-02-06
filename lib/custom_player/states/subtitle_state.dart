import '../core/notifier_store.dart';
import '../models/caption_model.dart';
import '../models/subtitle_model.dart';

class SubtitleState implements StoreState {
  final List<CaptionModel> allCaptions;
  final CaptionModel currentCaption;
  final SubtitleModel selectedSubtitle;

  const SubtitleState({
    required this.allCaptions,
    required this.currentCaption,
    required this.selectedSubtitle,
  });
  const SubtitleState.empty()
      : allCaptions = const [],
        currentCaption = CaptionModel.none,
        selectedSubtitle = const SubtitleModel.desactived();

  SubtitleState copyWith({
    List<CaptionModel>? allCaptions,
    CaptionModel? currentCaption,
    SubtitleModel? selectedSubtitle,
  }) {
    return SubtitleState(
      allCaptions: allCaptions ?? this.allCaptions,
      currentCaption: currentCaption ?? this.currentCaption,
      selectedSubtitle: selectedSubtitle ?? this.selectedSubtitle,
    );
  }
}
