import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/player.dart';

part 'dragged_player.g.dart';

@riverpod
class DraggedPlayer extends _$DraggedPlayer {
  @override
  Player? build() {
    return null;
  }

  void update(Player? player) {
    state = player;
  }
}

@riverpod
bool isTarget(IsTargetRef ref, Player player) {
  // if the dragged player is null or the same as the player, return false
  final draggedPlayer = ref.watch(draggedPlayerProvider);
  if (draggedPlayer == null) {
    return false;
  }

  return draggedPlayer != player;
}
