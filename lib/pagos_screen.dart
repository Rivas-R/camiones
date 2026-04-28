import 'package:flutter/material.dart';

class PagosScreen extends StatelessWidget {
  // Datos "dummy" para simular el historial de transacciones
  final List<Map<String, dynamic>> _transacciones = [
    {'titulo': 'Viaje - Ruta 1 Centro', 'fecha': '20 Abr 2026', 'monto': -15.00, 'icono': Icons.directions_bus},
    {'titulo': 'Recarga de saldo', 'fecha': '18 Abr 2026', 'monto': 100.00, 'icono': Icons.account_balance_wallet},
    {'titulo': 'Viaje - Ruta 3 Industrial', 'fecha': '15 Abr 2026', 'monto': -15.00, 'icono': Icons.directions_bus},
    {'titulo': 'Viaje - Ruta 1 Centro', 'fecha': '14 Abr 2026', 'monto': -15.00, 'icono': Icons.directions_bus},
  ];

  PagosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Billetera y Pagos'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Column(
        children: [
          // 1. Tarjeta de Saldo Principal
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Saldo Disponible',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text(
                  '\$125.50',
                  style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      '**** **** **** 4242',
                      style: TextStyle(color: Colors.white70, fontSize: 16, letterSpacing: 2),
                    ),
                    Icon(Icons.credit_card, color: Colors.white, size: 30),
                  ],
                ),
              ],
            ),
          ),

          // 2. Botón de Recarga
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Aquí irá la lógica para abrir la pasarela de pagos (ej. Stripe o MercadoPago)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Función de recarga en desarrollo')),
                  );
                },
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Recargar Saldo', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 3. Título del Historial
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Movimientos Recientes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // 4. Lista de Transacciones
          Expanded(
            child: ListView.builder(
              itemCount: _transacciones.length,
              itemBuilder: (context, index) {
                final tx = _transacciones[index];
                final esGasto = tx['monto'] < 0;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: esGasto ? Colors.redAccent.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                    child: Icon(
                      tx['icono'],
                      color: esGasto ? Colors.redAccent : Colors.green,
                    ),
                  ),
                  title: Text(tx['titulo'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(tx['fecha']),
                  trailing: Text(
                    '${esGasto ? '' : '+'}\$${tx['monto'].abs().toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: esGasto ? Colors.black87 : Colors.green,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}