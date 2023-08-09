import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'async_value_widget.dart';
import 'controller.dart';
import 'dice_roll.dart';
import 'main.data.dart';

void main() async {
  runApp(
    ProviderScope(
      child: MainApp(),
      overrides: [configureRepositoryLocalStorage()],
    ),
  );
}

class MainApp extends HookConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        home: Scaffold(
            body: AsyncValueWidget(
                value: ref.watch(repositoryInitializerProvider),
                data: (_) => HomePage())));
  }
}

class HomePage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showBarchart = useState(false);
    return Scaffold(
        appBar: AppBar(
          title: Text("Pass the dice"),
          actions: [
            Switch(
                activeTrackColor: Colors.white,
                activeColor: Colors.blue.shade800,
                value: showBarchart.value,
                onChanged: (val) => showBarchart.value = val),
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => ref.diceRolls.clear())
          ],
        ),
        body: Column(children: [
          Expanded(
              child: Padding(
                  padding: EdgeInsets.all(16),
                  child: showBarchart.value
                      ? StackedRollGraph()
                      : HistoryGraph())),
          Wrap(children: getButtonList(context, ref, 2, 12))
        ]));
  }

  List<Widget> getButtonList(
      BuildContext context, WidgetRef ref, int min, int max) {
    var buttonList = List.generate(
        max - min + 1,
        (index) => getPaddedButton(context,
            child: Text((min + index).toString()),
            onPressed: () => ref.diceRolls.save(DiceRoll(value: min + index))));
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
    return AsyncValueWidget(value: rollHistory, data: getHistoryChart);
  }

  Widget getHistoryChart(List<DiceRoll> data) {
    var history = data
        .asMap()
        .entries
        .map((roll) => FlSpot(roll.key.toDouble(), roll.value.value.toDouble()))
        .toList();
    history = history.isEmpty ? [FlSpot(0, 0)] : history;
    return LineChart(LineChartData(lineBarsData: [
      LineChartBarData(colors: [Colors.blue], spots: history)
    ]));
  }
}

class StackedRollGraph extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rollCounts = ref.watch(getDiceCountProvider);
    return AsyncValueWidget(value: rollCounts, data: getRollCountChart);
  }

  Widget getRollCountChart(IMap<DiceRoll, int> rollCounts) {
    return BarChart(BarChartData(
        barGroups: rollCounts.entries
            .map((element) => BarChartGroupData(
                  x: element.key.value,
                  barRods: [BarChartRodData(y: element.value.toDouble())],
                ))
            .toList()));
  }
}
