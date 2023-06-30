import 'package:flutter/material.dart';
import 'package:pet_bosque/paginas/lista_pet.dart';
import 'package:pet_bosque/paginas/lista_petHospedagem.dart';

class Agendamentos extends StatefulWidget {
  const Agendamentos({Key? key}) : super(key: key);

  @override
  _AgendamentosState createState() => _AgendamentosState();
}

class _AgendamentosState extends State<Agendamentos> {
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
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                                image: AssetImage("assets/imagens/botao.png"),
                                fit: BoxFit.cover),
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Row(children: [
                            IconButton(
                              iconSize: 72,
                              color: Colors.white70,
                              icon: const Icon(Icons.pets),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const ListaPet()));
                              },
                            ),
                            const Text(
                              "BANHO E TOSA",
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
                              builder: (context) => const ListaPet()));
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
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                                image: AssetImage("assets/imagens/botao.png"),
                                fit: BoxFit.cover),
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Row(children: [
                            IconButton(
                              iconSize: 72,
                              color: Colors.white70,
                              icon: const Icon(Icons.home_filled),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const ListaPet()));
                              },
                            ),
                            const Text(
                              "HOSPEDAGEM",
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
                              builder: (context) =>
                                  const ListaPetHospedagem()));
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
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                                image: AssetImage("assets/imagens/botao.png"),
                                fit: BoxFit.cover),
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Row(children: [
                            IconButton(
                              iconSize: 72,
                              color: Colors.white70,
                              icon: const Icon(Icons.medical_services),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const ListaPet()));
                              },
                            ),
                            const Text(
                              "VETERINÁRIO",
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
                              builder: (context) => const ListaPet()));
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
