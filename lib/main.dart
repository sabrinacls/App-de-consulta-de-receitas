/*
 Integrantes:
 Sabrina Clemente da Silva
Vivian Gomes Leal da Rocha
 */

import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const ReceitaFacilApp());
}

class ReceitaFacilApp extends StatelessWidget {
  const ReceitaFacilApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color verdeCulinario = Color(0xFF4E7D5B);
    const Color laranjaDestaque = Color(0xFFE67E22);
    const Color fundoClaro = Color(0xFFF7F9F5);

    return MaterialApp(
      title: 'Receita Fácil',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: fundoClaro,
        colorScheme: ColorScheme.fromSeed(
          seedColor: verdeCulinario,
          primary: verdeCulinario,
          secondary: laranjaDestaque,
          surface: fundoClaro,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: verdeCulinario,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      ),
      home: const HomePage(),
    );
  }
}