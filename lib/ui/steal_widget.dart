import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pass_the_dice/model/player.dart';
import 'package:pass_the_dice/providers/dragged_player.dart';
import 'package:pass_the_dice/providers/steal_history.dart';
import 'package:pass_the_dice/ui/player_widget.dart';

import '../model/steal.dart';

class StealWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        DraggablePlayerWidget(Player.orange),
        DraggablePlayerWidget(Player.blue),
      ]),
      Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        DraggablePlayerWidget(Player.white),
        DraggablePlayerWidget(Player.red),
      ])
    ]);
  }
}

class DraggablePlayerWidget extends ConsumerWidget {
  final Player player;
  DraggablePlayerWidget(this.player, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTarget = ref.watch(isTargetProvider(player));
    var viewFriendlyOffset = Offset(0, -30);
    if (isTarget) {
      return DragTarget<Player>(
        builder: (context, candidateData, rejectedData) {
          return candidateData.isEmpty
              ? PlayerWidget(player)
              : Transform.translate(
                  offset: viewFriendlyOffset,
                  child: PlayerFaceWidget(player,
                      faceOverride: Icons.sentiment_very_dissatisfied),
                );
        },
        onWillAccept: (data) => true,
        onAccept: (data) => ref
            .read(stealHistoryProvider.notifier)
            .add(Steal(from: player, to: data)),
      );
    } else {
      return Draggable(
        data: player,
        child: PlayerWidget(player),
        feedback: Transform.translate(
            offset: viewFriendlyOffset,
            child: PlayerFaceWidget(
              player,
              faceOverride: Icons.sentiment_very_satisfied,
            )),
        onDragStarted: () =>
            ref.read(draggedPlayerProvider.notifier).update(player),
        onDragEnd: (_) => ref.read(draggedPlayerProvider.notifier).update(null),
      );
    }
  }
}
