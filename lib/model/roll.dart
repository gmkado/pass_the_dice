import 'package:freezed_annotation/freezed_annotation.dart';

part 'roll.g.dart';
part 'roll.freezed.dart';

@freezed
class Roll with _$Roll {
  Roll._();

  factory Roll({required int value}) = _Roll;

  factory Roll.fromJson(Map<String, dynamic> json) => _$RollFromJson(json);
}
