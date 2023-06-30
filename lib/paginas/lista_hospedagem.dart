import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:pet_bosque/funcoes/info_hospedagem.dart';
import 'package:pet_bosque/paginas/destalhe_hospedagem.dart';
import 'package:pet_bosque/paginas/inicio.dart';
import 'package:pet_bosque/paginas/lista_colaborador.dart';
import 'package:pet_bosque/paginas/lista_contato.dart';
import 'package:pet_bosque/paginas/lista_pet.dart';
import 'package:pet_bosque/paginas/lista_petHospedagem.dart';
import 'package:pet_bosque/paginas/lista_planos.dart';
import 'package:pet_bosque/paginas/principal.dart';

enum OrderOption { orderaz, orderza }

InfoHospedagem info = InfoHospedagem();

class ListaHospedagem extends StatefulWidget {
  const ListaHospedagem({Key? key}) : super(key: key);

  @override
  State<ListaHospedagem> createState() => _ListaHospedagemState();
}

class _ListaHospedagemState extends State<ListaHospedagem> {
  List<Hospedagem> hospedagen = [];
  late String _dataAgendamento;
  DateTime _dateTime = DateTime.now();
  late String observacao;
  final bool pendente = false;
  Color corPendente = Colors.yellow;
  Color corCancelado = Colors.red;
  Color corFinalizado = Colors.blue;
  Color corStatus = Color.fromRGBO(202, 236, 236, 1);

  paginaInicial() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => const Inicio(
                index: 2,
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

  paginaPetHospedagem() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ListaPetHospedagem()),
    );
  }

  paginaConfig() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const Principal()),
    );
  }

  void _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    ).then((value) {
      setState(() {
        _dataAgendamento = DateFormat("dd/MM/yyyy").format(value!);
        _dateTime = value;
        _obterTodasHospedagem(_dataAgendamento);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _dataAgendamento = DateFormat("dd/MM/yyyy").format(_dateTime);
    _obterTodasHospedagem(_dataAgendamento);
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
          title: const Text("Hospedagens"),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              paginaInicial();
            },
            icon: const Icon(Icons.home_outlined),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                _showDatePicker(context);
              },
              icon: const Icon(Icons.calendar_month),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            paginaPetHospedagem();
          },
          icon: const Icon(Icons.add),
          backgroundColor: Color.fromRGBO(35, 151, 166, 1),
          hoverColor: Color.fromRGBO(35, 151, 166, 50),
          foregroundColor: Colors.white,
          label: Text("Novo"),
        ),
        body: ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: hospedagen.length,
            itemBuilder: (context, index) {
              return _cartaoHospedagem(context, index);
            }),
      ),
    );
  }

  Widget _cartaoHospedagem(BuildContext context, int index) {
    if (hospedagen[index].status == "Pendente") {
      corStatus = corPendente;
    }
    if (hospedagen[index].status == "Cancelado") {
      corStatus = corCancelado;
    }
    if (hospedagen[index].status == "Finalizado") {
      corStatus = corFinalizado;
    }
    if (hospedagen[index].observacao == null) {
      observacao = "Sem observação";
    } else {
      observacao = hospedagen[index].observacao ?? "";
    }
    return GestureDetector(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Slidable(
              actionExtentRatio: 0.25,
              actionPane: const SlidableDrawerActionPane(),
              secondaryActions: [
                IconSlideAction(
                  color: Colors.redAccent,
                  icon: Icons.delete,
                  caption: 'Excluir',
                  onTap: () {
                    info.deletarHospedagem(hospedagen[index].id!);
                    setState(() {
                      hospedagen.removeAt(index);
                    });
                  },
                ),
              ],
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      //                   <--- left side
                      color: corStatus,
                      width: 5.0,
                    ),
                  ),
                  color: const Color.fromRGBO(204, 236, 247, 100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Check In: ",
                          style: TextStyle(
                            color: Color.fromARGB(255, 73, 66, 2),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          hospedagen[index].dataCheckIn ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Text(
                          "Hora: ",
                          style: TextStyle(
                            color: Color.fromARGB(255, 73, 66, 2),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          hospedagen[index].horaCheckIn ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "Check Out: ",
                          style: TextStyle(
                            color: Color.fromARGB(255, 73, 66, 2),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          hospedagen[index].dataCheckOut ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Text(
                          "Hora: ",
                          style: TextStyle(
                            color: Color.fromARGB(255, 73, 66, 2),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          hospedagen[index].horaCheckOut ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "Cliente: ",
                          style: TextStyle(
                            color: Color.fromARGB(255, 73, 66, 2),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          hospedagen[index].nomeContato ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        const Text(
                          "Pet: ",
                          style: TextStyle(
                            color: Color.fromARGB(255, 73, 66, 2),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          hospedagen[index].nomePet ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "N° Diárias: ",
                          style: TextStyle(
                            color: Color.fromARGB(255, 73, 66, 2),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          hospedagen[index].dia.toString() ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "Total: ",
                          style: TextStyle(
                            color: Color.fromARGB(255, 73, 66, 2),
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "R\$ " +
                                  hospedagen[index]
                                      .valorTotal!
                                      .toStringAsFixed(2) ??
                              "",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              )),
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DetalheHospedagem(
                  idHospedagem: hospedagen[index].id as int,
                  pendente: pendente)));
        });
  }

  void _obterTodasHospedagem(String dataAgendamento) {
    info.obterTodasHospedagem(_dataAgendamento).then((dynamic list) {
      setState(() {
        hospedagen = list;
      });
    });
  }

  void _ordenarLista(OrderOption result) {
    switch (result) {
      case OrderOption.orderaz:
        hospedagen.sort((a, b) =>
            a.nomePet!.toLowerCase().compareTo(b.nomePet!.toLowerCase()));
        break;
      case OrderOption.orderza:
        hospedagen.sort((a, b) =>
            b.nomePet!.toLowerCase().compareTo(a.nomePet!.toLowerCase()));
        break;
    }
    setState(() {});
  }
}