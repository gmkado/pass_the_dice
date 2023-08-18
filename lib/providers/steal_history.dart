import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:pass_the_dice/providers/item_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/item.dart';
import '../model/player.dart';
import '../model/steal.dart';

part 'steal_history.g.dart';

@Riverpod(keepAlive: true)
class StealHistory extends _$StealHistory {
  @override
  IList<Steal> build() {
    final dice = ref.watch(itemHistoryProvider).map((item) => item.steal);
    return dice.nonNulls.toIList();
  }

  Future add(Steal steal) async {
    await ref.read(itemHistoryProvider.notifier).add(Item(steal: steal));
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

@riverpod
IList<int> getCumulativeStealCount(
    GetCumulativeStealCountRef ref, Player player) {
  final history = ref.watch(stealHistoryProvider);
  int count = 0;
  return [
    for (final steal in history)
      steal.to == player
          ? ++count
          : steal.from == player
              ? --count
              : count
  ].lock;
}
