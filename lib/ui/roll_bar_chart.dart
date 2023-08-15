import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/roll_history.dart';

class RollBarChart extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rollCounts = ref.watch(getDiceCountProvider);
    return BarChart(BarChartData(
        barGroups: rollCounts.entries
            .map((element) => BarChartGroupData(
                  x: element.key,
                  barRods: [BarChartRodData(toY: element.value.toDouble())],
                ))
            .toList()));
  }
}
