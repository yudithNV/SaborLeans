import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'detalle_controller.dart';

class DetalleView extends GetView<DetalleController> {
  const DetalleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Plato'),
        centerTitle: true,
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                ),
                child: Icon(Icons.restaurant, size: 80, color: Colors.grey[600]),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (controller.platoData['nombre'] ?? '').toString(),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      (controller.platoData['origen'] ?? '').toString(),
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _indicador('Calorías', (controller.platoData['calorias'] ?? '').toString()),
                        _indicador('Proteínas', (controller.platoData['proteinas'] ?? '').toString()),
                        _indicador('Tiempo', (controller.platoData['tiempo'] ?? '').toString()),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(text: 'Ingredientes'),
                        Tab(text: 'Historia'),
                      ],
                    ),
                    SizedBox(
                      height: 300,
                      child: TabBarView(
                        children: [
                          _ingredientesTab(),
                          _historiaTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _indicador(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrange),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _ingredientesTab() {
    final ingredientes = controller.platoData['ingredientes'] as List<dynamic>? ?? [];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ingredientes.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.deepOrange, size: 20),
              const SizedBox(width: 12),
              Text(ingredientes[index] as String),
            ],
          ),
        );
      },
    );
  }

  Widget _historiaTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Text(
          (controller.platoData['historia'] ?? '').toString(),
          style: const TextStyle(fontSize: 14, height: 1.6),
        ),
      ),
    );
  }
}