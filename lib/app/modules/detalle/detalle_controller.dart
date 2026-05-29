import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class DetalleController extends GetxController {
  static final Uri _endpoint =
      Uri.parse('http://10.0.2.2:8000/identificar');

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString mensaje = ''.obs;
  final RxString nombre = ''.obs;
  final RxInt calorias = 0.obs;
  final RxString historia = ''.obs;
  final RxString ingredientes = ''.obs;
  final RxString imagenUrl = ''.obs;

  final platoData = <String, dynamic>{}.obs;

  bool get tienePlato => nombre.value.isNotEmpty;

  Future<bool> identificarPlato(XFile imagen) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final request = http.MultipartRequest('POST', _endpoint);
      request.files.add(
        await http.MultipartFile.fromPath(
          'foto',
          imagen.path,
          filename: imagen.name,
          contentType: MediaType.parse(_obtenerMimeType(imagen)),
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      Get.log('Respuesta identificar: ${response.statusCode}');
      Get.log(response.body);

      final decodedBody = jsonDecode(response.body);
      if (decodedBody is! Map<String, dynamic>) {
        throw Exception('La respuesta del servidor no es un JSON valido.');
      }

      final body = decodedBody;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (body['error'] != null) {
          errorMessage.value = body['error'].toString();
          Get.snackbar('Error', errorMessage.value);
          return false;
        }

        final plato = _extraerPlato(body);

        if (plato == null) {
          throw Exception(
            'La respuesta no contiene datos del plato. Body: ${response.body}',
          );
        }

        mensaje.value = (body['mensaje'] ?? '').toString();
        nombre.value = (plato['nombre'] ?? '').toString();
        calorias.value = _toInt(plato['calorias']);
        historia.value = (plato['historia'] ?? '').toString();
        final ingredientesNormalizados =
            _normalizarIngredientes(plato['ingredientes']);
        ingredientes.value = ingredientesNormalizados.join(', ');
        imagenUrl.value = (plato['imagen_url'] ?? '').toString();

        platoData.assignAll({
          'nombre': nombre.value,
          'calorias': '${calorias.value} kcal',
          'historia': historia.value,
          'ingredientes': ingredientesNormalizados,
          'imagen_url': imagenUrl.value,
        });

        return true;
      }

      errorMessage.value =
          (body['error'] ?? 'No se pudo identificar el plato.').toString();
      Get.snackbar('Error', errorMessage.value);
      return false;
    } catch (e) {
      errorMessage.value = 'Error al enviar la imagen: $e';
      Get.snackbar('Error', errorMessage.value);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  String _obtenerMimeType(XFile imagen) {
    if (imagen.mimeType != null && imagen.mimeType!.isNotEmpty) {
      return imagen.mimeType!;
    }

    final extension = imagen.path.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'heic':
        return 'image/heic';
      default:
        return 'image/jpeg';
    }
  }

  Map<String, dynamic>? _extraerPlato(Map<String, dynamic> body) {
    final plato = body['plato'];
    if (plato is Map<String, dynamic>) return plato;

    for (final key in ['data', 'resultado', 'result']) {
      final wrapper = body[key];
      if (wrapper is Map<String, dynamic>) {
        final platoAnidado = wrapper['plato'];
        if (platoAnidado is Map<String, dynamic>) return platoAnidado;
      }
    }

    if (body.containsKey('nombre') ||
        body.containsKey('calorias') ||
        body.containsKey('historia') ||
        body.containsKey('ingredientes') ||
        body.containsKey('imagen_url')) {
      return body;
    }

    return null;
  }

  List<String> _normalizarIngredientes(dynamic value) {
    if (value is List) {
      return value
          .map((ingrediente) => ingrediente.toString().trim())
          .where((ingrediente) => ingrediente.isNotEmpty)
          .toList();
    }

    return value
        .toString()
        .split(RegExp(r'[\n,]'))
        .map((ingrediente) => ingrediente.trim())
        .where((ingrediente) => ingrediente.isNotEmpty)
        .toList();
  }
}
