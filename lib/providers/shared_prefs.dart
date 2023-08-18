import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shared_prefs.g.dart';

enum SharedPrefKeys { useBarChart, items }

@riverpod
SharedPreferences getSharedPrefs(GetSharedPrefsRef ref) {
  // ignore: null_check_always_fails
  return null!;
}
