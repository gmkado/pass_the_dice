import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_state.dart';
import 'dice_roll.dart';
import 'main.data.dart';

part 'controller.g.dart';

@Riverpod(keepAlive: true)
class RollHistory extends _$RollHistory {
  @override
  FutureOr<List<DiceRoll>> build() async {
    final dice = ref.diceRolls.watchAll();
    return dice.model ?? [];
  }

  void undo() async {
    if (state.valueOrNull?.lastOrNull == null) return;

    ref.diceRolls.delete(state.requireValue.last);
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

@riverpod
FutureOr<AppState> getAppState(GetAppStateRef ref) async {
  var appState = await ref.appStates.findOne(1);
  if (appState == null) {
    appState = AppState(id: 1, showBarchart: false);
    appState.save();
  }

  return appState;
}
