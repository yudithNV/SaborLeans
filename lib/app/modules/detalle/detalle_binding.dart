import 'package:get/get.dart';
import 'detalle_controller.dart';

class DetalleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetalleController>(() => DetalleController());
  }
}