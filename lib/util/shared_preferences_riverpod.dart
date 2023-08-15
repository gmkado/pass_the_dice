import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Converts the value of type parameter `T` to a String and persists
/// it in SharedPreferences.
///
/// To update the value, use the [update()] function.
/// Direct assignment to state cannot be used.
///
/// ```dart
/// await watch(mapPrefProvider.notifier).update(v);
/// ```
///
class MapListPrefNotifier<T> extends StateNotifier<IList<T>> {
  MapListPrefNotifier(this.prefs, this.prefKey, this.mapFrom, this.mapTo)
      : super(
            prefs.getStringList(prefKey)?.map(mapFrom).toIList() ?? <T>[].lock);

  SharedPreferences prefs;
  String prefKey;
  T Function(String) mapFrom;
  String Function(T) mapTo;

  /// Updates the value asynchronously.
  Future<void> update(IList<T> value) async {
    await prefs.setStringList(prefKey, value.map(mapTo).toList());
    super.state = value;
  }

  /// Do not use the setter for state.
  /// Instead, use `await update(value).`
  @override
  set state(IList<T> value) {
    assert(false,
        "Don\'t use the setter for state. Instead use `await update(value)`.");
    Future(() async {
      await update(value);
    });
  }
}

/// Returns a [Provider] that can access the preference with any type you want.
///
/// Persist to SharePreferences after converting to String.
/// The argument [prefs] specifies an instance of SharedPreferences.
/// The arguments [prefKey] and [defaultValue] specify the key name and default
/// value of the preference.
/// Specify how to convert from String to type T in [mapFrom].
/// Specifies how to convert from type T to String in [mapTo].
///
/// ```dart
///
/// enum EnumValues {
///   foo,
///   bar,
/// }
///
/// Future<void> main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///
///   final prefs = await SharedPreferences.getInstance();
///
///   final enumPrefProvider = createMapPrefProvider<EnumValues>(
///     prefs: (_) => prefs,
///     prefKey: "enumValue",
///     mapFrom: (v) => EnumValues.values
///         .firstWhere((e) => e.toString() == v, orElse: () => EnumValues.foo),
///     mapTo: (v) => v.toString(),
///   );
///
/// ```
///
/// When referring to a value, use it as you would a regular provider.
///
/// ```dart
///
///   Consumer(builder: (context, watch, _) {
///     final value = watch(enumPrefProvider);
///
/// ```
///
/// To change the value, use the update() method.
///
/// ```dart
///
///   await watch(enumPrefProvider.notifier).update(EnumValues.bar);
///
/// ```
///
StateNotifierProvider<MapListPrefNotifier<T>, IList<T>>
    createMapListPrefProvider<T>({
  required SharedPreferences Function(Ref) prefs,
  required String prefKey,
  required T Function(String) mapFrom,
  required String Function(T) mapTo,
}) {
  return StateNotifierProvider<MapListPrefNotifier<T>, IList<T>>(
      (ref) => MapListPrefNotifier<T>(prefs(ref), prefKey, mapFrom, mapTo));
}
