import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pass_the_dice/providers/steal_history.dart';

import '../model/player.dart';

class StealLineChart extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LineChart(LineChartData(lineBarsData: [
      getChartData(ref, Player.blue),
      getChartData(ref, Player.orange),
      getChartData(ref, Player.white),
      getChartData(ref, Player.red),
    ]));
  }

  LineChartBarData getChartData(WidgetRef ref, Player player) {
    final cumulativeSteals = ref.watch(getCumulativeStealCountProvider(player));
    var spots = cumulativeSteals
        .asMap()
        .entries
        .map((roll) => FlSpot(roll.key.toDouble(), roll.value.toDouble()))
        .toList();
    spots = spots.isEmpty ? [FlSpot(0, 0)] : spots;
    return LineChartBarData(color: playerToColorMap[player], spots: spots);
  }
}
