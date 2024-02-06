import '../core/notifier_store.dart';
import '../custom_player/custom_player_interface.dart';
import '../custom_player/helpers/caption_helpers.dart' as caption_helpers;
import '../models/caption_model.dart';
import '../models/subtitle_model.dart';
import '../states/subtitle_state.dart';

class SubtitleStore extends NotifierStore<SubtitleState> {
  final ICustomPlayer _customPlayer;
  SubtitleStore(this._customPlayer) : super(const SubtitleState.empty()) {
    _customPlayer.listenDuration(_mountSubtitle);
  }

  Future<void> changeSubtitle(SubtitleModel subtitleModel) async {
    final captionsList = await caption_helpers.captionsLoad(subtitleModel);
    update(state.copyWith(allCaptions: captionsList, selectedSubtitle: subtitleModel));
  }

  Future _mountSubtitle(Duration position, Duration duration) async {
    if (state.allCaptions.isNotEmpty) {
      var position = await _customPlayer.getCurrentPosition();
      var where = state.allCaptions
          .where((caption) => (caption.start! <= position && caption.end! >= position))
          .toList();

      if (where.isNotEmpty && where.first != state.currentCaption) {
        var caption = where.first;
        // NOTE delay da legenda
        await Future.delayed(const Duration(seconds: 1));
        update(state.copyWith(currentCaption: caption));
        Future.delayed(caption.end! - caption.start! + const Duration(seconds: 1), () {
          if (state.currentCaption == caption) update(state.copyWith(currentCaption: CaptionModel.none));
        });
      }
    }
  }
}
