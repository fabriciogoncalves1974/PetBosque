import 'dart:io';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pet_bosque/paginas/agendamentos.dart';
import 'package:pet_bosque/paginas/lista_agendamentos.dart';
import 'package:pet_bosque/paginas/lista_agendamentosPendentes.dart';
import 'package:pet_bosque/paginas/lista_colaborador.dart';
import 'package:pet_bosque/paginas/lista_contato.dart';
import 'package:pet_bosque/paginas/lista_hospedagem.dart';
import 'package:pet_bosque/paginas/lista_todosPets.dart';
import 'package:pet_bosque/paginas/principal.dart';
import 'package:pet_bosque/paginas/tabelas.dart';

class Inicio extends StatefulWidget {
  const Inicio({Key? key, required this.index}) : super(key: key);

  @override
  final int index;
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  setFullscreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
  }

  final String data = DateFormat("dd/MM/yyyy").format(DateTime.now());
  String dataAgendamento = DateFormat("dd/MM/yyyy").format(DateTime.now());
  int qtdAgendamentos = 0;
  int qtdHospedagem = 0;
  int _currentIndex = 2;
  final List<Widget> _paginas = [
    const Agendamentos(),
    const ListaContatos(),
    const Principal(),
    const ListaTodosPets(),
    const Tabelas(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void sair() {
    exit(0);
  }

  paginaInicial() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => Inicio(
                index: 2,
              )),
    );
  }

  paginaContatos() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => const Inicio(
                index: 1,
              )),
    );
  }

  paginaPets() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => const Inicio(
                index: 3,
              )),
    );
  }

  paginaPlanos() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => const Inicio(
                index: 4,
              )),
    );
  }

  paginaTabelas() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const Tabelas()),
    );
  }

  paginaColaboradores() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ListaColaborador()),
    );
  }

  paginaPet() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => const Inicio(
                index: 3,
              )),
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
            color: Color.fromARGB(156, 228, 241, 245),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
                backgroundColor: const Color.fromRGBO(35, 151, 166, 1),
                centerTitle: true,
                title: Container(
                    height: 60,
                    width: 200,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(202, 236, 236, 1),
                      borderRadius: BorderRadius.circular(10), //<-- SEE HERE
                    ),
                    child: Image.asset(
                      "assets/imagens/petBosque.png",
                      alignment: Alignment.bottomCenter,
                      fit: BoxFit.fitHeight,
                    )),
                actions: <Widget>[
                  IconButton(
                      onPressed: () {
                        sair();
                      },
                      icon: const Icon(
                        Icons.exit_to_app_outlined,
                        size: 40.0,
                        color: Colors.black54,
                      )),
                ]),
            drawer: Drawer(
              child: ListView(
                children: <Widget>[
                  const DrawerHeader(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/imagens/petBosque.png"),
                            fit: BoxFit.cover)),
                    child: null,
                  ),
                  CustomListTile(
                    icone: Icons.home,
                    texto: "Inicio",
                    onTap: paginaInicial,
                  ),
                  CustomListTile(
                    icone: Icons.person,
                    texto: "Clientes",
                    onTap: paginaContatos,
                  ),
                  CustomListTile(
                    icone: Icons.pets,
                    texto: "Pets",
                    onTap: paginaPets,
                  ),
                  CustomListTile(
                    icone: Icons.attach_money,
                    texto: "Planos",
                    onTap: paginaPlanos,
                  ),
                  CustomListTile(
                    icone: Icons.attach_money,
                    texto: "Tabelas",
                    onTap: paginaTabelas,
                  ),
                  CustomListTile(
                    icone: Icons.account_circle,
                    texto: "Colaboradores",
                    onTap: paginaColaboradores,
                  ),
                  CustomListTile(
                    icone: Icons.list,
                    texto: "Lista Hospedagem",
                    onTap: paginaHospedagem,
                  ),
                  CustomListTile(
                    icone: Icons.list,
                    texto: "Lista Agendamentos",
                    onTap: paginaAgendamentos,
                  ),
                  CustomListTile(
                    icone: Icons.list,
                    texto: "Agendamentos Pendentes",
                    onTap: paginaAgendamentosPendentes,
                  ),
                  CustomListTile(
                      icone: Icons.exit_to_app,
                      texto: "Sair",
                      onTap: () => exit(0)),
                ],
              ),
            ),
            body: _paginas[_currentIndex],
            bottomNavigationBar: ConvexAppBar(
              style: TabStyle.titled,
              backgroundColor: Color.fromRGBO(35, 151, 166, 1),
              items: const [
                TabItem(
                  icon: Icons.calendar_month,
                  title: 'Agendar',
                ),
                TabItem(
                  icon: Icons.person,
                  title: 'Clientes',
                ),
                TabItem(
                  icon: Icons.home,
                  title: 'Home',
                ),
                TabItem(
                  icon: Icons.pets,
                  title: 'Pets',
                ),
                TabItem(icon: Icons.tab, title: 'Tabelas'),
              ],
              initialActiveIndex: _currentIndex,
              onTap: onTabTapped,
            ),
          ),
        ));
  }

  Future<bool> _retornaPop() {
    return Future.value(false);
  }
}
