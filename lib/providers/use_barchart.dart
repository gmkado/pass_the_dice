import 'package:shared_preferences_riverpod/shared_preferences_riverpod.dart';

import 'shared_prefs.dart';

final useBarChartProvider = createPrefProvider<bool>(
  prefs: (ref) => ref.read(getSharedPrefsProvider),
  prefKey: SharedPrefKeys.useBarChart.name,
  defaultValue: false,
);
