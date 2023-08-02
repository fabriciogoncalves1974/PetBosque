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
              apiKey: "AIzaSyBiwgpTQGW8jKUQS-AKxRXnI0mFUSQnPR4",
              appId: "1:379303878360:android:dacfc171b167ad3100c1ad",
              messagingSenderId: "379303878360",
              projectId: "petbosque-7e36e"))
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
