import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_bosque/paginas/inicio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
      overlays: [SystemUiOverlay.top]);

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyBy0RGCYbp4jerl9z5GU-AbaAITfEPOVBk",
              appId: "1:211553804123:android:47d2cd16042ffa1a75447e",
              messagingSenderId: "211553804123",
              projectId: "lunapet-1974"))
      : await Firebase.initializeApp();
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
