import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../detalle/detalle_controller.dart';
import '../../routes/app_routes.dart';

class HomeController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final RxBool isLoading = false.obs;

  Future<void> escanearPlato() async {
    await _abrirImagen(ImageSource.camera);
  }

  Future<void> subirDeGaleria() async {
    await _abrirImagen(ImageSource.gallery);
  }

  Future<void> _abrirImagen(ImageSource source) async {
    final XFile? imagen = await _picker.pickImage(source: source);

    if (imagen == null) return; // usuario cancelo

    isLoading.value = true;
    final detalleController = Get.isRegistered<DetalleController>()
        ? Get.find<DetalleController>()
        : Get.put(DetalleController());

    final identificado = await detalleController.identificarPlato(imagen);
    isLoading.value = false;

    if (identificado) {
      Get.toNamed(AppRoutes.detalle);
    }
  }
}
