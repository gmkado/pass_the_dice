import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:fl_chart/fl_chart.dart';

import 'bindings.dart';
import 'controller.dart';

void main() async {
  var bindings = HomeBindings();
  await bindings.dependencies();

  runApp(GetMaterialApp(
    initialRoute: '/home',
    getPages: [GetPage(name: '/home', page: () => Home(), binding: bindings)],
  ));
}

class Home extends GetView<Controller> {
  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Pass the dice"),
          actions: [
            Obx(() => Switch(
                activeTrackColor: Colors.white,
                activeColor: Colors.blue.shade800,
                value: controller.showBarchart(),
                onChanged: (val) => controller.showBarchart.value = val)),
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => controller.clearAllRolls())
          ],
        ),
        body: Column(children: [
          Expanded(
              child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Obx(() {
                    if (controller.showBarchart()) {
                      return StackedRollGraph();
                    } else {
                      return HistoryGraph();
                    }
                  }))),
          Wrap(children: getButtonList(context, 2, 12))
        ]));
  }

  List<Widget> getButtonList(BuildContext context, int min, int max) {
    var buttonList = List.generate(
        max - min + 1,
        (index) => getPaddedButton(context,
            child: Text((min + index).toString()),
            onPressed: () => controller.addRoll(min + index)));
    buttonList.add(getPaddedButton(context,
        child: Icon(Icons.undo), onPressed: () => controller.undoRoll()));
    return buttonList;
  }

  Widget getPaddedButton(BuildContext context,
      {Widget child, Function onPressed}) {
    var screenWidth = MediaQuery.of(context).size.width;
    var buttonWidth = screenWidth / 6 - 15;
    return Padding(
        padding: EdgeInsets.all(5),
        child: SizedBox(
            width: buttonWidth,
            child: ElevatedButton(child: child, onPressed: onPressed)));
  }
}

class HistoryGraph extends GetView<Controller> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => LineChart(LineChartData(lineBarsData: getHistory())));
  }

  List<LineChartBarData> getHistory() {
    return [
      LineChartBarData(colors: [Colors.blue], spots: getSpots())
    ];
  }

  List<FlSpot> getSpots() {
    var history = controller.rollHistory
        .asMap()
        .entries
        .map((element) =>
            FlSpot(element.key.toDouble(), element.value.toDouble()))
        .toList();
    return history.isEmpty ? [FlSpot(0, 0)] : history;
  }
}

class StackedRollGraph extends GetView<Controller> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => BarChart(BarChartData(barGroups: getCounts())));
  }

  List<BarChartGroupData> getCounts() {
    return controller.rollCounts
        .map((element) => BarChartGroupData(
              x: element.value,
              barRods: [BarChartRodData(y: element.count().toDouble())],
            ))
        .toList();
  }
}
