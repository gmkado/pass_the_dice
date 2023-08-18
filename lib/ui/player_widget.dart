import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/player.dart';
import '../providers/dragged_player.dart';
import '../providers/steal_history.dart';

class PlayerWidget extends ConsumerWidget {
  final Player player;
  final IconData? faceOverride;

  const PlayerWidget(this.player, {super.key, this.faceOverride});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final potentialStealer = ref.watch(draggedPlayerProvider);
    final stolenFromCount =
        ref.watch(GetStolenFromCountProvider(player, potentialStealer));
    final stoleCount =
        ref.watch(GetStoleToCountProvider(player, potentialStealer));

    var textStyle =
        Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 20);
    var playerColor = playerToColorMap[player];
    return Row(children: [
      PlayerFaceWidget(player, faceOverride: faceOverride),
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

class PlayerFaceWidget extends StatelessWidget {
  final Player player;
  final IconData? faceOverride;

  const PlayerFaceWidget(this.player, {super.key, this.faceOverride});

  @override
  Widget build(BuildContext context) {
    return Icon(
        size: 70,
        faceOverride ?? Icons.sentiment_neutral,
        color: playerToColorMap[player]);
  }
}
