import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'controller.dart';

class HomeBindings extends Bindings {
  @override
  Future<void> dependencies() async {
    await GetStorage.init();
    Get.put<Controller>(Controller(GetStorage()));
  }
}
