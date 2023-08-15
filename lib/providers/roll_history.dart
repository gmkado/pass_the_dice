import 'dart:collection';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:pass_the_dice/providers/shared_prefs.dart';
import 'package:pass_the_dice/util/shared_preferences_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'roll_history.g.dart';

final _diceRollsProvider = createMapListPrefProvider<int>(
  prefs: (ref) => ref.read(getSharedPrefsProvider),
  prefKey: SharedPrefKeys.diceRolls.name,
  mapFrom: (rollString) => int.parse(rollString),
  mapTo: (roll) => roll.toString(),
);

@Riverpod(keepAlive: true)
class RollHistory extends _$RollHistory {
  @override
  IList<int> build() {
    final dice = ref.watch(_diceRollsProvider);
    return dice;
  }

  Future undo() async {
    if (state.lastOrNull == null) return;
    await ref.read(_diceRollsProvider.notifier).update(state.removeLast());
  }

  Future clear() async {
    await ref.read(_diceRollsProvider.notifier).update(<int>[].lock);
  }

  Future add(int diceRoll) async {
    await ref.read(_diceRollsProvider.notifier).update(state.add(diceRoll));
  }
}

@riverpod
IMap<int, int> getDiceCount(GetDiceCountRef ref) {
  final rollHistory = ref.watch(rollHistoryProvider);
  final counts = SplayTreeMap<int, int>();

  rollHistory.forEach((roll) => counts.update(
        roll,
        (value) => value + 1,
        ifAbsent: () => 1,
      ));

  return counts.lock;
}
