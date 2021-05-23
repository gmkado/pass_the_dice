import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pass_the_dice/controller.dart';

class MockStorage implements GetStorage {
  int readCount = 0;
  int writeCount = 0;

  @override
  T read<T>(String key) {
    readCount++;
    return null;
  }

  @override
  Future<void> write(String key, value) async => writeCount++;

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('Controller', () {
    test('addRoll should increment the roll count', () {
      final controller = Controller(MockStorage());
      controller.addRoll(2);

      expect(controller.rollCounts[0].count(), 1);
    });

    test('addRoll should add to the roll history', () {
      final controller = Controller(MockStorage());
      controller.addRoll(2);

      expect(controller.rollHistory.length, 1);
      expect(controller.rollHistory[0], 2);
    });

    test('undoRoll should remove last from history', () {
      final controller = Controller(MockStorage());
      controller.addRoll(2);
      controller.undoRoll();
      expect(controller.rollHistory.isEmpty, true);
    });

    test('undoRoll should not error if empty', () {
      final controller = Controller(MockStorage());
      expect(controller.rollHistory.isEmpty, true);
      controller.undoRoll();
    });

    test('undoRoll should reduce count of last', () {
      final controller = Controller(MockStorage());
      controller.addRoll(2);
      controller.undoRoll();
      expect(controller.rollCounts[0].count(), 0);
    });
    test('clearRoll should clear history', () {
      final controller = Controller(MockStorage());
      controller.addRoll(2);
      controller.addRoll(3);
      controller.addRoll(4);

      expect(controller.rollHistory.length, 3);
      controller.clearAllRolls();
      expect(controller.rollHistory.length, 0);
    });
    test('clearRoll should clear counts', () {
      final controller = Controller(MockStorage());
      controller.addRoll(2);
      controller.addRoll(2);
      controller.addRoll(2);

      expect(controller.rollCounts[0].count(), 3);
      controller.clearAllRolls();
      expect(controller.rollCounts[0].count(), 0);
    });

    test('Read saved values on construction', () {
      final storage = MockStorage();
      expect(storage.readCount, 0);

      Controller(storage);
      expect(storage.readCount != 0, true);
    });

    test('Save on change', () {
      final storage = MockStorage();
      final controller = Controller(storage);

      expect(storage.writeCount, 0);
      controller.addRoll(2);
      expect(storage.writeCount, 1);
    });
  });
}
