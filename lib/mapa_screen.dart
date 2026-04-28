import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapaScreen extends StatefulWidget {
  final String camionId;
  const MapaScreen({super.key, required this.camionId});

  @override
  MapaScreenState createState() => MapaScreenState();
}

class MapaScreenState extends State<MapaScreen> {
  GoogleMapController? mapController;
  final Set<Marker> _marcadores = {};
  
  // Le quitamos el 'final' para obligar al mapa a redibujar la capa de líneas
  Set<Polyline> _lineasRuta = {}; 
  
  BitmapDescriptor? _iconoCamion;
  LatLng _ubicacionActual = const LatLng(32.6245, -115.4522);
  StreamSubscription<DocumentSnapshot>? _camionSubscription;

  // Coordenadas fijas de las paradas
  final List<LatLng> _paradasRuta1 = [
    const LatLng(32.6245, -115.4522), // Inicio
    const LatLng(32.6300, -115.4550), // Parada 2
    const LatLng(32.6350, -115.4600), // Parada 3
    const LatLng(32.6400, -115.4650), // Fin
  ];

  @override
  void initState() {
    super.initState();
    _dibujarRutaYParadas(); 
    _cargarIconoPersonalizado().then((_) {
      _escucharUbicacionCamion();
    });
  }

  @override
  void didUpdateWidget(MapaScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.camionId != widget.camionId) {
      _camionSubscription?.cancel();
      _escucharUbicacionCamion();
    }
  }

  void _dibujarRutaYParadas() {
    Set<Polyline> nuevasLineas = {};

    // 1. Crear la línea que conecta los puntos
    nuevasLineas.add(
      Polyline(
        polylineId: const PolylineId('ruta_actual'),
        points: _paradasRuta1,
        color: Colors.blueAccent,
        width: 3,
      ),
    );

    // Crear los marcadores fijos para cada parada
    for (int i = 0; i < _paradasRuta1.length; i++) {
      _marcadores.add(
        Marker(
          markerId: MarkerId('parada_$i'),
          position: _paradasRuta1[i],
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen), 
          infoWindow: InfoWindow(title: 'Parada ${i + 1}'),
        ),
      );
    }

    setState(() {
      _lineasRuta = nuevasLineas;
    });
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<void> _cargarIconoPersonalizado() async {
    final Uint8List markerIcon = await _getBytesFromAsset('assets/camion.png', 80); 
    setState(() {
      _iconoCamion = BitmapDescriptor.fromBytes(markerIcon);
    });
  }

  void _escucharUbicacionCamion() {
    _camionSubscription = FirebaseFirestore.instance
        .collection('camiones')
        .doc(widget.camionId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        double lat = data['latitud'] ?? 32.6245;
        double lng = data['longitud'] ?? -115.4522;
        LatLng nuevaPosicion = LatLng(lat, lng);

        setState(() {
          _ubicacionActual = nuevaPosicion;
          
          // IMPORTANTE: Removemos SOLO el camión anterior, para no borrar las paradas
          _marcadores.removeWhere((m) => m.markerId.value == widget.camionId);
          
          _marcadores.add(
            Marker(
              markerId: MarkerId(widget.camionId),
              position: nuevaPosicion,
              icon: _iconoCamion ?? BitmapDescriptor.defaultMarker,
              zIndexInt: 2, // Para que el camión se dibuje por encima de las paradas
            ),
          );
        });
        _centrarCamara();
      }
    });
  }

  void _centrarCamara() {
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _ubicacionActual, zoom: 14.5),
        ),
      );
    }
  }

  @override
  void dispose() {
    _camionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Área en Tiempo Real'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => mapController = controller,
            initialCameraPosition: CameraPosition(target: _ubicacionActual, zoom: 14.0),
            markers: _marcadores,
            polylines: _lineasRuta, 
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
          
          // Panel superior flotante
          Positioned(
            top: 16, left: 16, right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
              ),
              child: Row(
                children: [
                  const Icon(Icons.directions_bus, color: Colors.blueAccent),
                  const SizedBox(width: 12),
                  Text(
                    'Siguiendo: ${widget.camionId.toUpperCase()}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          // Botón flotante
          Positioned(
            bottom: 24, right: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.blueAccent,
              onPressed: _centrarCamara,
              child: const Icon(Icons.my_location, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}