import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';

import 'custom_player/custom_player_interface.dart';
import 'stores/player_store.dart';
import 'stores/timer_store.dart';

class TimerWidget extends StatefulWidget {
  final ICustomPlayer customPlayer;
  final PlayerStore playerStore;
  const TimerWidget({Key? key, required this.customPlayer, required this.playerStore}) : super(key: key);

  @override
  State<TimerWidget>  createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
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
          Expanded(
            child: Stack(
              children: [
                Container(height: 2, color: Colors.white24),
                Positioned.fill(
                  child: Row(
                    children: [
                      Expanded(
                          flex: store.state.positionMilliseconds,
                          child: Container(height: 2, color: Colors.red)),
                      if (store.state.durationMilliseconds - store.state.positionMilliseconds > 0)
                        Spacer(flex: store.state.durationMilliseconds - store.state.positionMilliseconds),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      );
    });
  }
}
