import 'package:flutter/material.dart';

import 'models/subtitle_model.dart';
import 'stores/player_store.dart';

class SubtitleWidget extends StatelessWidget {
  final PlayerStore playerStore;
  final List<SubtitleModel> subtitlesList;
  SubtitleWidget({super.key, required this.playerStore, required this.subtitlesList});

  final _popupMenuKey = GlobalKey<PopupMenuButtonState>();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SubtitleModel>(
      key: _popupMenuKey,
      initialValue: playerStore.state.selectedSubtitle,
      onSelected: playerStore.onSubtitleChanged,
      onCanceled: playerStore.onSubtitleListClose,
      color: Colors.black54,
      tooltip: playerStore.state.isEnabledSubtitle
          ? "Legendas em ${playerStore.state.selectedSubtitle.name}\nClique para alterar"
          : "Habilitar legendas",
      icon: GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onTap: () async {
          _popupMenuKey.currentState?.showButtonMenu();
          await playerStore.onSubtitleListOpen();
        },
        child: Icon(
          playerStore.state.isEnabledSubtitle ? Icons.subtitles : Icons.subtitles_off,
          color: Colors.white,
        ),
      ),
      itemBuilder: (BuildContext context) => List.from(
        subtitlesList.map((subtitle) {
          return PopupMenuItem<SubtitleModel>(
            height: 30,
            value: subtitle,
            enabled: subtitle != playerStore.state.selectedSubtitle,
            textStyle: const TextStyle(fontSize: 13, color: Colors.white),
            child: Text(subtitle.name, textAlign: TextAlign.center),
          );
        }),
      ),
    );
  }
}
