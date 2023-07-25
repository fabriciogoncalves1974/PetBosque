import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:pet_bosque/funcoes/info_coloborador.dart';
import 'package:pet_bosque/paginas/detalhe_colaborador.dart';
import 'package:pet_bosque/paginas/editar_colaborador.dart';
import 'package:pet_bosque/paginas/inicio.dart';
import 'package:pet_bosque/paginas/lista_agendamentos.dart';
import 'package:pet_bosque/paginas/novo_colaborador.dart';

enum OrderOption { orderaz, orderza }

class ListaColaborador extends StatefulWidget {
  const ListaColaborador({Key? key}) : super(key: key);

  @override
  State<ListaColaborador> createState() => _ListaColaboradorState();
}

FirebaseFirestore db = FirebaseFirestore.instance;

class _ListaColaboradorState extends State<ListaColaborador> {
  InfoColaborador info = InfoColaborador();
  String data = DateFormat("dd/MM/yyyy").format(DateTime.now());
  List<Colaborador> colaborador = [];

  paginaAgendamentos() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ListaAgendamentos(
                data: data,
              )),
    );
  }

  paginaInicial() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => const Inicio(
                index: 2,
              )),
    );
  }

  @override
  void initState() {
    super.initState();
    db.collection('colaborador').snapshots().listen(
      (event) {
        setState(() {
          _obterDadosColaboradores();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/imagens/back_app.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Colaboradores"),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              paginaInicial();
            },
            icon: const Icon(Icons.home_outlined),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => NovoColaborador()));
          },
          icon: const Icon(Icons.add),
          backgroundColor: Color.fromRGBO(35, 151, 166, 1),
          hoverColor: Color.fromRGBO(35, 151, 166, 50),
          foregroundColor: Colors.white,
          label: Text("Novo"),
        ),
        body: ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: colaborador.length,
            itemBuilder: (context, index) {
              return _cartaoColaborador(context, index);
            }),
      ),
    );
  }

  Widget _cartaoColaborador(BuildContext context, int index) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Slidable(
          actionExtentRatio: 0.25,
          actionPane: const SlidableDrawerActionPane(),
          secondaryActions: [
            IconSlideAction(
              color: Colors.blueAccent,
              icon: Icons.edit,
              caption: 'Editar',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditarColaborador(
                          colaborador: colaborador[index],
                        )));
              },
            ),
            if (colaborador[index].status == "Ativo")
              IconSlideAction(
                color: Colors.redAccent,
                icon: Icons.add,
                caption: 'Desativar',
                onTap: () {
                  //info.inativarColaborador(colaborador[index].id!);
                  db.collection("colaborador").doc(colaborador[index].id).set({
                    "idColaborador": colaborador[index].id,
                    "nomeColaborador": colaborador[index].nomeColaborador,
                    "funcao": colaborador[index].funcao,
                    "porcenComissao": colaborador[index].porcenComissao,
                    "porcenParticipante": colaborador[index].porcenParticipante,
                    "metaComissao": colaborador[index].metaComissao,
                    "status": "Inativo"
                  });
                  setState(() {
                    _obterDadosColaboradores();
                  });
                },
              ),
            if (colaborador[index].status == "Inativo")
              IconSlideAction(
                color: Colors.greenAccent,
                icon: Icons.add,
                caption: 'Ativar',
                onTap: () {
                  //info.ativarColaborador(colaborador[index].id!);
                  db.collection("colaborador").doc(colaborador[index].id).set({
                    "idColaborador": colaborador[index].id,
                    "nomeColaborador": colaborador[index].nomeColaborador,
                    "funcao": colaborador[index].funcao,
                    "porcenComissao": colaborador[index].porcenComissao,
                    "porcenParticipante": colaborador[index].porcenParticipante,
                    "metaComissao": colaborador[index].metaComissao,
                    "status": "Ativo"
                  });
                  setState(() {
                    _obterDadosColaboradores();
                  });
                },
              ),
          ],
          actions: [
            IconSlideAction(
                color: Colors.blueAccent,
                icon: Icons.calculate,
                caption: 'Agendamentos',
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DetalheColaborador(
                            idColaborador: colaborador[index].id!,
                            nome: colaborador[index].nomeColaborador!,
                          )));
                }),
          ],
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: const Color.fromRGBO(204, 236, 247, 100),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Text(
                      "Colaborador: ",
                      style: TextStyle(
                        color: Color.fromARGB(255, 73, 66, 2),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      colaborador[index].nomeColaborador ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Row(children: [
                  const Text(
                    "Função: ",
                    style: TextStyle(
                      color: Color.fromARGB(255, 73, 66, 2),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    colaborador[index].funcao ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ]),
                Row(children: [
                  const Text(
                    "Taxa comissão % : ",
                    style: TextStyle(
                      color: Color.fromARGB(255, 73, 66, 2),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    colaborador[index].porcenComissao.toString() ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ]),
                Row(children: [
                  const Text(
                    "Taxa Participação % : ",
                    style: TextStyle(
                      color: Color.fromARGB(255, 73, 66, 2),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    colaborador[index].porcenParticipante.toString() ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ]),
                Row(children: [
                  const Text(
                    "Meta: ",
                    style: TextStyle(
                      color: Color.fromARGB(255, 73, 66, 2),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "R\$ " +
                            colaborador[index]
                                .metaComissao!
                                .toStringAsFixed(2) ??
                        "",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ]),
                Row(children: [
                  const Text(
                    "Status: ",
                    style: TextStyle(
                      color: Color.fromARGB(255, 73, 66, 2),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    colaborador[index].status.toString() ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (colaborador[index].status.toString() == "Ativo")
                    const Icon(color: Colors.blue, Icons.check_box),
                  if (colaborador[index].status.toString() == "Inativo")
                    const Icon(color: Colors.red, Icons.cancel),
                ]),
              ],
            ),
          ),
        ),
      ),
      onTap: () {},
    );
  }

  void _obterDadosColaboradores() {
    info.obterTodosColaboradoresFirestore().then((dynamic list) {
      setState(() {
        colaborador = list;
      });
    });
  }
}
