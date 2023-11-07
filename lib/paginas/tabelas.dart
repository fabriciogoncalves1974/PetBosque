import 'package:flutter/material.dart';
import 'package:pet_bosque/paginas/lista_colaborador.dart';
import 'package:pet_bosque/paginas/lista_especie.dart';
import 'package:pet_bosque/paginas/lista_pet.dart';
import 'package:pet_bosque/paginas/lista_planos.dart';
import 'package:pet_bosque/paginas/lista_raca.dart';

class Tabelas extends StatefulWidget {
  const Tabelas({Key? key}) : super(key: key);

  @override
  _TabelasState createState() => _TabelasState();
}

class _TabelasState extends State<Tabelas> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _retornaPop,
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/imagens/back_app.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 125,
                  ),
                  Row(
                    children: [
                      InkWell(
                        child: Container(
                          height: 100,
                          width: 371,
                          color: Color.fromRGBO(35, 151, 166, 1),
                          /*decoration: BoxDecoration(
                            image: const DecorationImage(
                                image: AssetImage("assets/imagens/botao.png"),
                                fit: BoxFit.cover),
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(25.0),
                          ),*/
                          child: Row(children: [
                            IconButton(
                              iconSize: 72,
                              color: Colors.white70,
                              icon: const Icon(Icons.view_timeline_outlined),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const ListaPet()));
                              },
                            ),
                            const Text(
                              "-- COLABORADOR --",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                              ),
                            ),
                          ]),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ListaColaborador()));
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      InkWell(
                        child: Container(
                          height: 100,
                          width: 371,
                          color: Color.fromRGBO(35, 151, 166, 1),
                          /*decoration: BoxDecoration(
                            image: const DecorationImage(
                                image: AssetImage("assets/imagens/botao.png"),
                                fit: BoxFit.cover),
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(25.0),
                          ),*/
                          child: Row(children: [
                            IconButton(
                              iconSize: 72,
                              color: Colors.white70,
                              icon: const Icon(Icons.view_timeline_outlined),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const ListaPet()));
                              },
                            ),
                            const Text(
                              "-- PLANOS --",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                              ),
                            ),
                          ]),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ListaPlanos()));
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      InkWell(
                        child: Container(
                          height: 100,
                          width: 371,
                          color: Color.fromRGBO(35, 151, 166, 1),
                          /*decoration: BoxDecoration(
                            image: const DecorationImage(
                                image: AssetImage("assets/imagens/botao.png"),
                                fit: BoxFit.cover),
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(25.0),
                          ),*/
                          child: Row(children: [
                            IconButton(
                              iconSize: 72,
                              color: Colors.white70,
                              icon: const Icon(Icons.view_timeline_outlined),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const ListaEspecie()));
                              },
                            ),
                            const Text(
                              "-- ESPÉCIES --",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                              ),
                            ),
                          ]),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ListaEspecie()));
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      InkWell(
                        child: Container(
                          height: 100,
                          width: 371,
                          color: Color.fromRGBO(35, 151, 166, 1),
                          /*decoration: BoxDecoration(
                            image: const DecorationImage(
                                image: AssetImage("assets/imagens/botao.png"),
                                fit: BoxFit.cover),
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(25.0),
                          ),*/
                          child: Row(children: [
                            IconButton(
                              iconSize: 72,
                              color: Colors.white70,
                              icon: const Icon(Icons.view_timeline_outlined),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const ListaRaca()));
                              },
                            ),
                            const Text(
                              "-- RAÇAS --",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                              ),
                            ),
                          ]),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ListaRaca()));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<bool> _retornaPop() {
    return Future.value(true);
  }
}
