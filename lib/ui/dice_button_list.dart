import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pass_the_dice/providers/item_provider.dart';

import '../model/roll.dart';
import '../providers/roll_history.dart';

class DiceButtonList extends HookConsumerWidget {
  final int min = 2;
  final int max = 12;

  const DiceButtonList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var buttonList = List.generate(
        max - min + 1,
        (index) => getPaddedButton(context,
            child: Text((min + index).toString()),
            onPressed: () => ref
                .read(rollHistoryProvider.notifier)
                .add(Roll(value: min + index))));
    buttonList.add(getPaddedButton(context,
        child: Icon(Icons.undo),
        onPressed: () => ref.read(itemHistoryProvider.notifier).undo()));
    return Wrap(children: buttonList);
  }

  Widget getPaddedButton(BuildContext context,
      {required Widget child, VoidCallback? onPressed}) {
    var screenWidth = MediaQuery.of(context).size.width;
    var buttonWidth = screenWidth / 6 - 15;
    return Padding(
        padding: EdgeInsets.all(5),
        child: SizedBox(
            width: buttonWidth,
            child: ElevatedButton(child: child, onPressed: onPressed)));
  }
}
