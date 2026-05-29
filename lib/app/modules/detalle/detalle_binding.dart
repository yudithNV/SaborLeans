import 'package:get/get.dart';
import 'detalle_controller.dart';

class DetalleBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<DetalleController>()) {
      Get.lazyPut<DetalleController>(() => DetalleController());
    }
  }
}
