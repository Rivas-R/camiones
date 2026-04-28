import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChoferScreen extends StatefulWidget {
  const ChoferScreen({super.key});

  @override
  ChoferScreenState createState() => ChoferScreenState();
}

class ChoferScreenState extends State<ChoferScreen> {
  bool _transmitiendo = false;
  StreamSubscription<Position>? _positionStream;
  final String miCamionId = 'camion_01'; // Por ahora lo dejamos fijo

  Future<void> _iniciarTransmision() async {
    // Pedir permisos
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    setState(() => _transmitiendo = true);

    // Escuchar el GPS del celular y subirlo a Firebase automáticamente
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 5),
    ).listen((Position position) {
      FirebaseFirestore.instance.collection('camiones').doc(miCamionId).set({
        'latitud': position.latitude,
        'longitud': position.longitude,
        'ultima_actualizacion': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)); // merge: true crea el documento si no existe
    });
  }

  void _detenerTransmision() {
    _positionStream?.cancel();
    setState(() => _transmitiendo = false);
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panel de Chofer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _transmitiendo ? Icons.satellite_alt : Icons.location_off,
              size: 80,
              color: _transmitiendo ? Colors.green : Colors.grey,
            ),
            const SizedBox(height: 20),
            Text(
              _transmitiendo ? 'Transmitiendo ubicación...' : 'Transmisión detenida',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _transmitiendo ? Colors.red : Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: _transmitiendo ? _detenerTransmision : _iniciarTransmision,
              child: Text(
                _transmitiendo ? 'Detener Viaje' : 'Iniciar Viaje',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}