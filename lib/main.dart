import 'package:flutter/material.dart';
import 'login.dart'; // Sesuaikan dengan nama file login kamu
import 'home.dart';  // File yang akan berisi halaman Hello World

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(), // Set LoginPage sebagai halaman utama
    );
  }
}
