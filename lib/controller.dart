import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dice_roll.dart';
import 'main.data.dart';

part 'controller.g.dart';

@Riverpod(keepAlive: true)
class RollHistory extends _$RollHistory {
  @override
  FutureOr<List<DiceRoll>> build() async {
    final dice = ref.diceRolls.watchAll(remote: false);
    return dice.model ?? [];
  }

  void undo() async {
    if (state.valueOrNull?.lastOrNull == null) return;

    ref.diceRolls.delete(state.requireValue.last, remote: false);
  }
}

@riverpod
FutureOr<IMap<DiceRoll, int>> getDiceCount(GetDiceCountRef ref) async {
  final rollHistory = await ref.watch(rollHistoryProvider.future);
  Map<DiceRoll, int> counts = {};

  rollHistory.forEach((roll) => counts.update(
        roll,
        (value) => value + 1,
        ifAbsent: () => 1,
      ));

  return counts.lock;
}
