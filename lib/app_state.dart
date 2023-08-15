import 'package:flutter_data/flutter_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_state.g.dart';
part 'app_state.freezed.dart';

@freezed
@DataRepository([])
class AppState extends DataModel<AppState> with _$AppState {
  AppState._();

  factory AppState({
    int? id,
    required bool showBarchart,
  }) = _AppState;

  factory AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);
}
