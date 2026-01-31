# 🍳 Recetas App

Una solución movil para el control de costos de producción y gestión de inventario para negocios gastronómicos.

## 🚀 Características
- **Inventario Inteligente:** Registro automático de entradas y salidas de insumos.
- **Cotización Precisa:** Cálculo automático del costo de recetas basado en el precio actual de los ingredientes.
- **Reportes:** Generación de resúmenes de movimientos.
- **Offline First:** Gracias a **Drift**, todos tus datos se almacenan localmente sin necesidad de internet.

## 📸## 📸 Capturas de Pantalla

| Pantalla Principal | Inventario | Reporte de Costos |
| :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/bdb5acd2-e2d6-4e67-b832-37a7dcd9ecb0" width="250"> | <img src="https://github.com/user-attachments/assets/112c0d90-f3c3-4b0e-b060-aeacef642c00" width="250"> | <img src="https://github.com/user-attachments/assets/82cb0d2b-b9f4-4e0f-af40-2c64524cabe9" width="250"> |

---

## 🚀 Guía de Inicio Rápido

Para ejecutar este proyecto en tu máquina local, sigue estos pasos:

### 1. Prerrequisitos
* Tener instalado el SDK de [Flutter](https://docs.flutter.dev/get-started/install).
* Un emulador o dispositivo físico conectado.

### 2. Instalación
Clona el repositorio y entra en la carpeta:
```bash
git clone [https://github.com/Castropy/recetas_app.git](https://github.com/Castropy/recetas_app.git)
cd recetas_app
2. **Instala dependencias:¨**
   ```bash
   flutter pubget
3. **Genera los archivos de Drift: Como este proyecto usa generación de código para la base de datos, ejecuta:**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs

4. Corre la app
   ```bash
   flutter run
   
   
