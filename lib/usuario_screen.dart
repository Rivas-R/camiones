import 'package:flutter/material.dart';
import 'rutas_screen.dart';
import 'mapa_screen.dart';
import 'pagos_screen.dart';
import 'perfil_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late PageController _pageController;
  
  // Variable para guardar qué camión estamos siguiendo
  String _camionSeleccionado = 'camion_01'; 

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // 2. Función que recibe el ID de la ruta y cambia al mapa
  void _seleccionarRuta(String camionId) {
    setState(() {
      _camionSeleccionado = camionId;
    });
    // Cambiamos automáticamente a la pestaña del Mapa (índice 1)
    _onItemTapped(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          // 3. Pasamos la función a la pantalla de Rutas
          RutasScreen(onRutaSeleccionada: _seleccionarRuta), 
          // 4. Pasamos el ID al Mapa
          MapaScreen(camionId: _camionSeleccionado),
          PagosScreen(),
          PerfilScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.route), label: 'Rutas'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Área'),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Pagos'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}