import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Controller extends GetxController {
  RxList<int> rollHistory;
  RxBool showBarchart = true.obs;

  Controller(GetStorage storage) {
    // load saved (for some reason this doesn't work as a oneliner...)
    List<int> rh = (storage.read('rollHistory') ?? []).cast<int>();
    rollHistory = rh.obs;

    bool sb = storage.read('showBarchart') ?? true;
    showBarchart = sb.obs;

    // initialize rollcounts
    rollHistory.forEach((element) => rollCounts[element - 2].count++);

    // save on change
    rollHistory.listen((rh) async => await storage.write('rollHistory', rh));
    showBarchart.listen((sb) async => await storage.write('showBarchart', sb));
  }

  List<DiceCount> rollCounts = [
    DiceCount(2),
    DiceCount(3),
    DiceCount(4),
    DiceCount(5),
    DiceCount(6),
    DiceCount(7),
    DiceCount(8),
    DiceCount(9),
    DiceCount(10),
    DiceCount(11),
    DiceCount(12),
  ];

  addRoll(int value) {
    rollCounts[value - 2].count++;
    rollHistory.add(value);
  }

  undoRoll() {
    if (rollHistory.isNotEmpty) {
      rollCounts[rollHistory.removeLast() - 2].count--;
    }
  }

  clearAllRolls() {
    rollHistory.clear();
    rollCounts.forEach((element) => element.count.value = 0);
  }
}

class DiceCount {
  final int value;
  RxInt count = 0.obs;

  DiceCount(this.value);
}
