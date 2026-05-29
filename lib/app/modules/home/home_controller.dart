import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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

    if (imagen == null) return; // usuario canceló

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2)); // simula la IA
    isLoading.value = false;

    Get.toNamed(AppRoutes.detalle);
  }
}