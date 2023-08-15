import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pass_the_dice/model/player.dart';
import 'package:pass_the_dice/ui/player_widget.dart';

class StealWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        PlayerWidget(Player.orange),
        PlayerWidget(Player.blue),
      ]),
      Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        PlayerWidget(Player.white),
        PlayerWidget(Player.red),
      ])
    ]);
  }
}
