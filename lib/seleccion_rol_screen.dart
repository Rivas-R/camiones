import 'package:flutter/material.dart';
import 'usuario_screen.dart'; // La pantalla principal de usuarios normales
import 'chofer_screen.dart'; // La pantalla principal de choferes

class SeleccionRolScreen extends StatelessWidget {
  const SeleccionRolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bienvenido')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.person),
              label: const Text('Soy Usuario (Ver Rutas)'),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.directions_bus),
              label: const Text('Soy Camionero (Compartir Ubicación)'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ChoferScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}