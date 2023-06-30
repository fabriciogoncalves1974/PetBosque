import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_bosque/funcoes/info_agendamento.dart';
import 'package:pet_bosque/funcoes/info_hospedagem.dart';
import 'package:pet_bosque/paginas/inicio.dart';
import 'package:pet_bosque/paginas/lista_agendamentos.dart';
import 'package:pet_bosque/paginas/lista_agendamentosPendentes.dart';
import 'package:pet_bosque/paginas/lista_colaborador.dart';
import 'package:pet_bosque/paginas/lista_contato.dart';
import 'package:pet_bosque/paginas/lista_hospedagem.dart';
import 'package:pet_bosque/paginas/lista_pet.dart';
import 'package:pet_bosque/paginas/lista_planos.dart';

InfoAgendamento info = InfoAgendamento();
InfoHospedagem infoHospedagem = InfoHospedagem();

class Principal extends StatefulWidget {
  const Principal({Key? key}) : super(key: key);

  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  List<Agendamento> agendamento = [];
  List<Hospedagem> hospedagem = [];
  String contatoPrimeiroAgendamento = "";
  String petPrimeiroAgendamento = "";
  String horaPrimeiroAgendamento = "";
  String contatoPrimeiroHospedagem = "";
  String petPrimeiroHospedagem = "";
  String horaPrimeiroHospedagem = "";
  final String data = DateFormat("dd/MM/yyyy").format(DateTime.now());
  String dataAgendamento = DateFormat("dd/MM/yyyy").format(DateTime.now());
  int qtdAgendamentos = 0;
  int qtdHospedagem = 0;
  int index = 0;
  int index2 = 0;

  @override
  void initState() {
    super.initState();
    _obterTodosAgendamentos(data);
    _obterQuantidadeAgendamentos();
    _obterQuantidadeHospedagem();
    _obterTodasHospedagens(data);
  }

  paginaInicial() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => const Inicio(
                index: 0,
              )),
    );
  }

  paginaContatos() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ListaContatos()),
    );
  }

  paginaPets() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ListaPet()),
    );
  }

  paginaPlanos() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ListaPlanos()),
    );
  }

  paginaColaboradores() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ListaColaborador()),
    );
  }

  paginaPet() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ListaPet()),
    );
  }

  paginaHospedagem() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ListaHospedagem()),
    );
  }

  paginaAgendamentos() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ListaAgendamentos(
                data: dataAgendamento,
              )),
    );
  }

  paginaAgendamentosPendentes() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => const ListaAgendamentosPendentes()),
    );
  }

  paginaConfig() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const Principal()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _retornaPop,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/imagens/back_app.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Agendamentos do dia! ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.teal.shade100,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  if (contatoPrimeiroAgendamento != "")
                    Row(
                      children: [
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          "Banho e tosa possui ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          qtdAgendamentos.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const Text(
                          " agendamentos para hoje!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (contatoPrimeiroAgendamento != "")
                    Row(
                      children: [
                        InkWell(
                          child: Container(
                              padding: const EdgeInsets.all(2.0),
                              height: 110,
                              width: 380,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                                color: const Color.fromRGBO(204, 236, 247, 100),
                              ),
                              child: Column(children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(children: [
                                  const Text(
                                    "Primeiro agendamento do dia para  ",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    horaPrimeiroAgendamento.toString() ?? "",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  const Text(
                                    " Horas",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ]),
                                Row(children: [
                                  const Text(
                                    "Pet: ",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    petPrimeiroAgendamento.toString() ?? "",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    "contato: ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      //fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    contatoPrimeiroAgendamento.toString() ?? "",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                ]),
                                Row(children: [
                                  const SizedBox(
                                    width: 270,
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.blueAccent,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ListaAgendamentos(
                                                    data: dataAgendamento,
                                                  )));
                                    },
                                    child: Text('ver todos...'),
                                  )
                                ]),
                              ])),
                          onTap: () {},
                        ),
                      ],
                    ),
                  if (contatoPrimeiroAgendamento == "")
                    Row(
                      children: [
                        InkWell(
                          child: Container(
                              height: 110,
                              width: 320,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                                color: const Color.fromRGBO(204, 236, 247, 100),
                              ),
                              child: Column(children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(children: [
                                  const Text(
                                    "Sem agendamentos para hoje!  ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ]),
                              ])),
                          onTap: () {},
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 25,
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.teal.shade100,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  if (contatoPrimeiroHospedagem != "")
                    Row(
                      children: [
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          "Hospedagem possui ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          qtdHospedagem.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const Text(
                          " agendamentos para hoje!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (contatoPrimeiroHospedagem != "")
                    Row(
                      children: [
                        InkWell(
                          child: Container(
                              padding: const EdgeInsets.all(2.0),
                              height: 110,
                              width: 320,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                                color: const Color.fromRGBO(204, 236, 247, 100),
                              ),
                              child: Column(children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(children: [
                                  const Text(
                                    "Primeira hospedagem check in para  ",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    horaPrimeiroHospedagem.toString() ?? "",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  const Text(
                                    " Horas",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ]),
                                Row(children: [
                                  const Text(
                                    "Pet: ",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Text(
                                    petPrimeiroHospedagem.toString() ?? "",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    "contato: ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    contatoPrimeiroHospedagem.toString() ?? "",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                ]),
                                Row(children: [
                                  const SizedBox(
                                    width: 270,
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.blueAccent,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ListaHospedagem()));
                                    },
                                    child: Text('ver todos...'),
                                  )
                                ]),
                              ])),
                          onTap: () {},
                        ),
                      ],
                    ),
                  if (contatoPrimeiroHospedagem == "")
                    Row(
                      children: [
                        InkWell(
                          child: Container(
                              height: 110,
                              width: 380,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                                color: const Color.fromRGBO(204, 236, 247, 100),
                              ),
                              child: Column(children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(children: [
                                  const Text(
                                    "Sem hospedagem para hoje!  ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ]),
                              ])),
                          onTap: () {},
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
    return Future.value(false);
  }

  void _obterQuantidadeAgendamentos() {
    info.quantidadeAgendamentosDia(data).then((dynamic result) {
      setState(() {
        qtdAgendamentos = result;
      });
    });
  }

  void _obterTodasHospedagens(String dataAgendamento) {
    infoHospedagem.obterTodasHospedagem(data).then((dynamic list) {
      setState(() {
        hospedagem = list;
        if (hospedagem.isEmpty) {
          contatoPrimeiroHospedagem = "";
          petPrimeiroHospedagem = "";
          horaPrimeiroHospedagem = "";
          index2 = 1;
        }
        if (hospedagem.isNotEmpty) {
          contatoPrimeiroHospedagem = hospedagem[index2].nomeContato!;
          petPrimeiroHospedagem = hospedagem[index2].nomePet!;
          horaPrimeiroHospedagem = hospedagem[index2].horaCheckIn!;
        }
      });
    });
  }

  void _obterTodosAgendamentos(String dataAgendamento) {
    info.obterTodosAgendamentos(data).then((dynamic list) {
      setState(() {
        agendamento = list;
        if (agendamento.isEmpty) {
          contatoPrimeiroAgendamento = "";
          petPrimeiroAgendamento = "";
          horaPrimeiroAgendamento = "";
          index = 1;
        }
        if (agendamento.isNotEmpty) {
          contatoPrimeiroAgendamento = agendamento[index].nomeContato!;
          petPrimeiroAgendamento = agendamento[index].nomePet!;
          horaPrimeiroAgendamento = agendamento[index].hora!;
          index = index + 1;
        }
      });
    });
  }

  void _obterQuantidadeHospedagem() {
    infoHospedagem.quantidadeHospedagemDia(data).then((dynamic result) {
      setState(() {
        qtdHospedagem = result;
      });
    });
  }
}