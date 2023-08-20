import 'dart:collection';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:pass_the_dice/providers/item_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/item.dart';
import '../model/roll.dart';

part 'roll_history.g.dart';

@Riverpod(keepAlive: true)
class RollHistory extends _$RollHistory {
  @override
  IList<Roll> build() {
    final dice = ref.watch(itemHistoryProvider).map((item) => item.roll);
    return dice.nonNulls.toIList();
  }

  Future add(Roll diceRoll) async {
    await ref.read(itemHistoryProvider.notifier).add(Item(roll: diceRoll));
  }
}

@riverpod
IMap<int, int> getDiceCount(GetDiceCountRef ref) {
  final rollHistory = ref.watch(rollHistoryProvider);
  final counts = {for (var i = 2; i <= 12; i++) i: 0};
  for (final roll in rollHistory) {
    counts[roll.value] = counts[roll.value]! + 1;
  }

  return counts.lock;
}
