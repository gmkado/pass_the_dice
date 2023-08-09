import 'package:flutter_data/flutter_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dice_roll.g.dart';
part 'dice_roll.freezed.dart';

@freezed
@DataRepository([])
class DiceRoll extends DataModel<DiceRoll> with _$DiceRoll {
  DiceRoll._();

  factory DiceRoll({
    int? id,
    required int value,
  }) = _DiceRoll;

  factory DiceRoll.fromJson(Map<String, dynamic> json) =>
      _$DiceRollFromJson(json);
}
