import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/player.dart';
import '../providers/steal_history.dart';

class PlayerWidget extends ConsumerWidget {
  final Player player;
  const PlayerWidget(this.player, {super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stolenFromCount = ref.watch(GetStolenFromCountProvider(player));
    final stoleCount = ref.watch(GetStoleToCountProvider(player));

    var textStyle =
        Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 20);
    var playerColor = playerToColorMap[player];
    return Row(children: [
      Icon(size: 70, Icons.sentiment_neutral, color: playerColor),
      Column(children: [
        Badge.count(
            backgroundColor: playerColor,
            largeSize: 24,
            offset: Offset(20, 0),
            textStyle: textStyle,
            alignment: Alignment.centerRight,
            child: Icon(size: 35, Icons.arrow_forward),
            count: stolenFromCount),
        Badge.count(
            backgroundColor: playerColor,
            largeSize: 24,
            offset: Offset(20, 0),
            textStyle: textStyle,
            alignment: Alignment.centerRight,
            child: Icon(size: 35, Icons.arrow_back),
            count: stoleCount),
      ]),
    ]);
  }
}
