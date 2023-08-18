import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pass_the_dice/providers/item_provider.dart';
import 'package:pass_the_dice/providers/shared_prefs.dart';
import 'package:pass_the_dice/providers/use_barchart.dart';
import 'package:pass_the_dice/ui/dice_button_list.dart';
import 'package:pass_the_dice/ui/roll_bar_chart.dart';
import 'package:pass_the_dice/ui/roll_line_chart.dart';
import 'package:pass_the_dice/ui/steal_line_chart.dart';
import 'package:pass_the_dice/ui/steal_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final useBarChart = ref.watch(useBarChartProvider);
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
                        ref.read(itemHistoryProvider.notifier).clear())
              ],
            ),
            body: Column(children: [
              Expanded(
                child: Swiper(
                  itemCount: 3,
                  itemBuilder: (ctx, index) {
                    final (title, chart) = switch (index) {
                      0 => ("Roll History", RollLineChart()),
                      1 => ("Roll Spread", RollBarChart()),
                      2 => ("Steal History", StealLineChart()),
                      _ => throw ArgumentError.value(
                          index, 'invalid index', 'index')
                    };
                    return Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          Expanded(
                            child: chart,
                          )
                        ],
                      ),
                    );
                  },
                  pagination: SwiperPagination(
                      builder: DotSwiperPaginationBuilder(color: Colors.grey)),
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: StealWidget(),
              )),
              DiceButtonList()
            ])));
  }
}
