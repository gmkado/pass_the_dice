import 'dart:convert';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:pass_the_dice/providers/shared_prefs.dart';
import 'package:pass_the_dice/util/shared_preferences_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/item.dart';

part 'item_provider.g.dart';

final _itemProvider = createMapListPrefProvider<Item>(
  prefs: (ref) => ref.read(getSharedPrefsProvider),
  prefKey: SharedPrefKeys.items.name,
  mapFrom: (itemString) => Item.fromJson(jsonDecode(itemString)),
  mapTo: (item) => jsonEncode(item.toJson()),
);

@Riverpod(keepAlive: true)
class ItemHistory extends _$ItemHistory {
  @override
  IList<Item> build() {
    final items = ref.watch(_itemProvider);
    return items;
  }

  Future undo() async {
    if (state.lastOrNull == null) return;
    await ref.read(_itemProvider.notifier).update(state.removeLast());
  }

  Future clear() async {
    await ref.read(_itemProvider.notifier).update(<Item>[].lock);
  }

  Future add(Item item) async {
    await ref.read(_itemProvider.notifier).update(state.add(item));
  }
}
