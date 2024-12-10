import 'package:chatapp/app/controllers/main_controller.dart';
import 'package:chatapp/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainController(), permanent: true);
    Get.put(HomeController());
  }
}