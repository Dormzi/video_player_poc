import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';

import 'custom_player/custom_player_interface.dart';
import 'stores/player_store.dart';
import 'stores/timer_store.dart';

class ButtonsWidget extends StatefulWidget {
  final ICustomPlayer customPlayer;
  final PlayerStore playerStore;
  const ButtonsWidget({Key? key, required this.customPlayer, required this.playerStore}) : super(key: key);

  @override
  State<ButtonsWidget> createState() => _ButtonsWidgetState();
}

class _ButtonsWidgetState extends State<ButtonsWidget> {
  late final store = TimerStore(widget.playerStore, widget.customPlayer);

  @override
  Widget build(BuildContext context) {
    return RxBuilder(builder: (context) {
      return Row(
        children: [
          Text(
            "${store.state.formattedPosition} / ${store.state.formattedDuration}",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 7),
          InkWell(
            onTap: store.prev15Seconds,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history, color: Colors.white),
                  Text("-15", style: TextStyle(color: Colors.white, fontSize: 9)),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: store.next15Seconds,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.update, color: Colors.white),
                  Text("+15", style: TextStyle(color: Colors.white, fontSize: 9)),
                ],
              ),
            ),
          ),
          SizedBox(width: 15),
        ],
      );
    });
  }
}
