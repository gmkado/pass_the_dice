import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:pass_the_dice/providers/shared_prefs.dart';
import 'package:pass_the_dice/util/shared_preferences_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/player.dart';
import '../model/steal.dart';

part 'steal_history.g.dart';

final _stealHistoryProvider = createMapListPrefProvider<Steal>(
  prefs: (ref) => ref.read(getSharedPrefsProvider),
  prefKey: SharedPrefKeys.steals.name,
  mapFrom: (stealString) => Steal.fromJson(jsonDecode(stealString)),
  mapTo: (steal) => jsonEncode(steal.toJson()),
);

@Riverpod(keepAlive: true)
class StealHistory extends _$StealHistory {
  @override
  IList<Steal> build() {
    final dice = ref.watch(_stealHistoryProvider);
    return dice;
  }

  Future undo() async {
    if (state.lastOrNull == null) return;
    await ref.read(_stealHistoryProvider.notifier).update(state.removeLast());
  }

  Future clear() async {
    await ref.read(_stealHistoryProvider.notifier).update(<Steal>[].lock);
  }

  Future add(Steal steal) async {
    await ref.read(_stealHistoryProvider.notifier).update(state.add(steal));
  }
}

@riverpod
int getStolenFromCount(GetStolenFromCountRef ref, Player player) {
  final history = ref.watch(stealHistoryProvider);
  return history.count((element) => element.from == player);
}

@riverpod
int getStoleToCount(GetStoleToCountRef ref, Player player) {
  final history = ref.watch(stealHistoryProvider);
  return history.count((element) => element.to == player);
}
