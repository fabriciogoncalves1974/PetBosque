import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_bosque/funcoes/info_plano.dart';

enum OrderOption { orderaz, orderza }

class Lista extends StatefulWidget {
  const Lista({Key? key}) : super(key: key);

  @override
  State<Lista> createState() => _ListaState();
}

class list {
  String? nome;
}

class _ListaState extends State<Lista> {
  InfoPlano info = InfoPlano();
  FirebaseFirestore db = FirebaseFirestore.instance;

  List<Plano> plano = [];

  @override
  void initState() {
    db.collection('planos').snapshots().listen((query) {
      List list = [];
      query.docs.forEach((doc) {
        setState(() {
          list.add(doc.get('nomePlano'));
          print(list);
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
