import 'package:flutter/material.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      // Usamos SingleChildScrollView para que no haya errores de desbordamiento si la pantalla es pequeña
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            
            // 1. Foto de Perfil y Nombre
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blueAccent.withOpacity(0.1),
                    child: const Icon(Icons.person, size: 50, color: Colors.blueAccent),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Juan Pérez',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'juan.perez@ejemplo.com',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),

            // 2. Tarjeta de Estadísticas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _construirEstadistica('Viajes', '42'),
                      _construirSeparador(),
                      _construirEstadistica('Puntos', '350'),
                      _construirSeparador(),
                      _construirEstadistica('Reseñas', '15'),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 3. Menú de Opciones
            _construirElementoMenu(Icons.person_outline, 'Datos Personales', context),
            _construirElementoMenu(Icons.security, 'Seguridad y Contraseña', context),
            _construirElementoMenu(Icons.notifications_none, 'Notificaciones', context),
            _construirElementoMenu(Icons.help_outline, 'Ayuda y Soporte', context),
            
            const Divider(height: 40, thickness: 1, indent: 16, endIndent: 16),
            
            // 4. Botón de Cerrar Sesión
            _construirElementoMenu(
              Icons.exit_to_app, 
              'Cerrar Sesión', 
              context, 
              esPeligroso: true
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para crear los números de estadísticas
  Widget _construirEstadistica(String titulo, String valor) {
    return Column(
      children: [
        Text(
          valor,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
        ),
        const SizedBox(height: 4),
        Text(
          titulo,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
    );
  }

  // Pequeña línea vertical para separar las estadísticas
  Widget _construirSeparador() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }

  // Widget auxiliar para generar los botones del menú rápidamente
  Widget _construirElementoMenu(IconData icono, String titulo, BuildContext context, {bool esPeligroso = false}) {
    final colorFuerte = esPeligroso ? Colors.redAccent : Colors.black87;
    
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: esPeligroso ? Colors.redAccent.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icono, color: colorFuerte),
      ),
      title: Text(
        titulo,
        style: TextStyle(
          color: colorFuerte,
          fontWeight: esPeligroso ? FontWeight.bold : FontWeight.w500,
          fontSize: 16,
        ),
      ),
      trailing: esPeligroso ? null : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Navegando a $titulo...'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }
}