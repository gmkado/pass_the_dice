import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pass_the_dice/model/roll.dart';
import 'package:pass_the_dice/model/steal.dart';

part 'item.g.dart';
part 'item.freezed.dart';

@freezed
class Item with _$Item {
  Item._();

  factory Item({Steal? steal, Roll? roll}) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}
