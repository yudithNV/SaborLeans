import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import 'detalle_controller.dart';

class DetalleView extends GetView<DetalleController> {
  const DetalleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detalles del Plato'),
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios_new,
              size: 18, color: AppColors.textDark),
        ),
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // imagen hero
              Container(
                width: double.infinity,
                height: 240,
                color: AppColors.primarySoft,
                child: Icon(
                  Icons.restaurant,
                  size: 80,
                  color: AppColors.primary.withOpacity(0.3),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // nombre y origen
                    Text(
                      (controller.platoData['nombre'] ?? '').toString(),
                      style: GoogleFonts.fraunces(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            size: 14, color: AppColors.textMedium),
                        const SizedBox(width: 4),
                        Text(
                          (controller.platoData['origen'] ?? '').toString(),
                          style: TextStyle(
                              fontSize: 13, color: AppColors.textMedium),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // indicadores
                    Row(
                      children: [
                        _indicador(
                          Icons.local_fire_department_outlined,
                          (controller.platoData['calorias'] ?? '').toString(),
                          'Calorías',
                        ),
                        const SizedBox(width: 12),
                        _indicador(
                          Icons.fitness_center_outlined,
                          (controller.platoData['proteinas'] ?? '').toString(),
                          'Proteínas',
                        ),
                        const SizedBox(width: 12),
                        _indicador(
                          Icons.access_time_outlined,
                          (controller.platoData['tiempo'] ?? '').toString(),
                          'Tiempo',
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),

              // tabs
              DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      indicatorColor: AppColors.primary,
                      indicatorWeight: 2,
                      labelColor: AppColors.primary,
                      unselectedLabelColor: AppColors.textMedium,
                      labelStyle: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                      tabs: const [
                        Tab(text: 'Ingredientes'),
                        Tab(text: 'Historia'),
                      ],
                    ),
                    SizedBox(
                      height: 320,
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

  Widget _indicador(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.primarySoft,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: AppColors.textMedium),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ingredientesTab() {
    final ingredientes =
        controller.platoData['ingredientes'] as List<dynamic>? ?? [];
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      itemCount: ingredientes.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.secondaryLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check,
                    size: 15, color: AppColors.secondary),
              ),
              const SizedBox(width: 14),
              Text(
                ingredientes[index] as String,
                style: TextStyle(
                    fontSize: 14, color: AppColors.textDark),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _historiaTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Text(
        (controller.platoData['historia'] ?? '').toString(),
        style: TextStyle(
          fontSize: 14,
          height: 1.7,
          color: AppColors.textDark,
        ),
      ),
    );
  }
}