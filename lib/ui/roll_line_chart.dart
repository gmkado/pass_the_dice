import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/roll_history.dart';

class RollLineChart extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rollHistory = ref.watch(rollHistoryProvider);
    var history = rollHistory
        .asMap()
        .entries
        .map((roll) => FlSpot(roll.key.toDouble(), roll.value.toDouble()))
        .toList();
    history = history.isEmpty ? [FlSpot(0, 0)] : history;
    return LineChart(LineChartData(
        lineBarsData: [LineChartBarData(color: Colors.blue, spots: history)]));
  }
}
