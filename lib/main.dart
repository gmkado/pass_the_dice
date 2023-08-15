import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pass_the_dice/shared_prefs_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(ProviderScope(
    child: MainApp(),
    overrides: [getSharedPrefsProvider.overrideWithValue(prefs)],
  ));
}

class MainApp extends HookConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var useBarChart = ref.watch(useBarChartProvider);
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text("Pass the dice"),
              actions: [
                Switch(
                    activeTrackColor: Colors.white,
                    activeColor: Colors.blue.shade800,
                    value: useBarChart,
                    onChanged: (val) {
                      ref.read(useBarChartProvider.notifier).update(val);
                    }),
                IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () =>
                        ref.read(rollHistoryProvider.notifier).clear())
              ],
            ),
            body: Column(children: [
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.all(16),
                      child:
                          useBarChart ? StackedRollGraph() : HistoryGraph())),
              Wrap(children: getButtonList(context, ref, 2, 12))
            ])));
  }

  List<Widget> getButtonList(
      BuildContext context, WidgetRef ref, int min, int max) {
    var buttonList = List.generate(
        max - min + 1,
        (index) => getPaddedButton(context,
            child: Text((min + index).toString()),
            onPressed: () =>
                ref.read(rollHistoryProvider.notifier).add(min + index)));
    buttonList.add(getPaddedButton(context,
        child: Icon(Icons.undo),
        onPressed: () => ref.read(rollHistoryProvider.notifier).undo()));
    return buttonList;
  }

  Widget getPaddedButton(BuildContext context,
      {required Widget child, VoidCallback? onPressed}) {
    var screenWidth = MediaQuery.of(context).size.width;
    var buttonWidth = screenWidth / 6 - 15;
    return Padding(
        padding: EdgeInsets.all(5),
        child: SizedBox(
            width: buttonWidth,
            child: ElevatedButton(child: child, onPressed: onPressed)));
  }
}

class HistoryGraph extends ConsumerWidget {
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

class StackedRollGraph extends ConsumerWidget {
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
