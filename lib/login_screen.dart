import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'usuario_screen.dart'; // La pantalla principal de usuarios
import 'chofer_screen.dart'; // La pantalla principal de choferes

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _iniciarSesion() async {
    setState(() => _isLoading = true);

    try {
      //  Iniciar sesión en Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      //  Buscar el rol del usuario en Firestore
      String uid = userCredential.user!.email!;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();

      String rol = 'usuario'; // Rol por defecto
      if (userDoc.exists) {
        rol = userDoc['rol'] ?? 'usuario';
      }

      // 3. Redirigir según el rol
      if (!mounted) return; // Evita errores si la pantalla ya se cerró
      
      if (rol == 'camionero') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChoferScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      }

    } on FirebaseAuthException catch (e) {
      // Mostrar error (contraseña incorrecta, usuario no existe, etc.)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.directions_bus, size: 100, color: Colors.blueAccent),
              const SizedBox(height: 20),
              const Text(
                'Bienvenido',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              
              // Campo de Correo
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              
              // Campo de Contraseña
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 30),
              
              // Botón de Iniciar Sesión
              _isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _iniciarSesion,
                        child: const Text('Iniciar Sesión', style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}