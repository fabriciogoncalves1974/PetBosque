import 'package:flutter/material.dart';
import 'package:pet_bosque/paginas/inicio.dart';

void main() {
  runApp(
    MaterialApp(
      home: Inicio(index: 2),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        cardTheme: const CardTheme(elevation: 20),
        useMaterial3: true,
      ),
    ),
  );
}
