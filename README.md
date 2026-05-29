# SaborLens 🇧🇴

Aplicación móvil en **Flutter** utilizando la arquitectura **GetX** que identifica platos típicos bolivianos mediante inteligencia artificial (visión artificial) y despliega su información nutricional, ingredientes e historia cultural.

---

## 🛠️ Estructura del Proyecto

El proyecto sigue la estructura modular recomendada por **Get CLI**:

* **`lib/app/core/`**: Configuraciones globales compartidas (temas de color, constantes, estilos).
* **`lib/app/data/`**: Capa de datos (modelos de datos y el motor/proveedor de la IA).
* **`lib/app/modules/`**: Módulos independientes por pantalla. Cada uno contiene:
    * `_view`: Diseño de la interfaz gráfica.
    * `_controller`: Lógica y estados de la pantalla.
    * `_binding`: Inyección y gestión eficiente de la memoria RAM (`Get.lazyPut`).
* **`lib/app/routes/`**: Gestión centralizada de la navegación de la app (`app_pages.dart` y `app_routes.dart`).

---




## 💻 Requisitos para Ejecutar

1. Tener instalado Flutter SDK.
2. Clonar el repositorio y ejecutar en la terminal:
   ```bash
   flutter pub get
   flutter run