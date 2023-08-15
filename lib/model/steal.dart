import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pass_the_dice/model/player.dart';

part 'steal.g.dart';
part 'steal.freezed.dart';

@freezed
class Steal with _$Steal {
  Steal._();

  factory Steal({required Player from, required Player to}) = _Steal;

  factory Steal.fromJson(Map<String, dynamic> json) => _$StealFromJson(json);
}
