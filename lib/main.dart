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
                  itemCount: 4,
                  itemBuilder: (ctx, index) {
                    switch (index) {
                      case 0:
                        return Padding(
                            padding: EdgeInsets.all(30), child: RollBarChart());
                      case 1:
                        return Padding(
                            padding: EdgeInsets.all(30),
                            child: RollLineChart());
                      case 2:
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 150),
                          child: StealWidget(),
                        );
                      case 3:
                        return Padding(
                          padding: const EdgeInsets.all(30),
                          child: StealLineChart(),
                        );
                      default:
                        throw ArgumentError.value(
                            index, 'invalid index', 'index');
                    }
                  },
                  pagination: SwiperPagination(
                      builder: DotSwiperPaginationBuilder(color: Colors.grey)),
                ),
              ),
              DiceButtonList()
            ])));
  }
}
