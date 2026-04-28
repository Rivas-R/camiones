import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RutasScreen extends StatelessWidget {
  final Function(String) onRutaSeleccionada;

  const RutasScreen({super.key, required this.onRutaSeleccionada});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Ruta'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      // StreamBuilder escucha la colección 'rutas' en tiempo real
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('rutas').snapshots(),
        builder: (context, snapshot) {
          // Mientras carga la información de internet, mostramos un círculo girando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Si hay un error o la colección está vacía
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay rutas disponibles por ahora.'));
          }

          // Extraemos los documentos de Firebase
          final rutasDocs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.only(top: 10),
            itemCount: rutasDocs.length,
            itemBuilder: (context, index) {
              // Obtenemos la información de cada documento
              final rutaData = rutasDocs[index].data() as Map<String, dynamic>;
              final nombre = rutaData['nombre'] ?? 'Ruta sin nombre';
              final camionId = rutaData['camion_id'] ?? 'camion_desconocido';
              
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.directions_bus, color: Colors.blueAccent),
                  ),
                  title: Text(
                    nombre,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text('ID del camión: $camionId'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  onTap: () {
                    // Manda el camionId a la pantalla principal para cambiar el mapa
                    onRutaSeleccionada(camionId);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}