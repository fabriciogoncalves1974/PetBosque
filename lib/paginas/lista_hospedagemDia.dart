import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:pet_bosque/funcoes/info_hospedagem.dart';
import 'package:pet_bosque/paginas/destalhe_hospedagem.dart';
import 'package:pet_bosque/paginas/editar_hospedagem.dart';
import 'package:pet_bosque/paginas/inicio.dart';
import 'package:pet_bosque/paginas/lista_colaborador.dart';
import 'package:pet_bosque/paginas/lista_contato.dart';
import 'package:pet_bosque/paginas/lista_pet.dart';
import 'package:pet_bosque/paginas/lista_petHospedagem.dart';
import 'package:pet_bosque/paginas/lista_planos.dart';
import 'package:pet_bosque/paginas/principal.dart';

enum OrderOption { orderaz, orderza }

InfoHospedagem info = InfoHospedagem();

class ListaHospedagemDia extends StatefulWidget {
  const ListaHospedagemDia({Key? key}) : super(key: key);

  @override
  State<ListaHospedagemDia> createState() => _ListaHospedagemDiaState();
}

class _ListaHospedagemDiaState extends State<ListaHospedagemDia> {
  List<Hospedagem> hospedagen = [];
  late String _dataAgendamento;
  DateTime _dateTime = DateTime.now();
  late String observacao;
  final bool pendente = false;
  Color corPendente = Colors.yellow;
  Color corCancelado = Colors.red;
  Color corFinalizado = Colors.blue;
  Color corStatus = Color.fromRGBO(202, 236, 236, 1);
  bool loading = true;
  String statusSelecionado = 'Pendente';

  var status = [
    'Pendente',
    'Finalizado',
    'Cancelado',
  ];

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
        loading = false;
      });
    });
  }

  //FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    /* db.collection('hospedagem').snapshots().listen(
      (event) {
        setState(() {
          _dataAgendamento = DateFormat("dd/MM/yyyy").format(_dateTime);
          _obterTodasHospedagem(_dataAgendamento);
          loading = false;
        });
      },
    );*/
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
          title: Text(
            "Hospedagens " + DateFormat("dd/MM/yyyy").format(_dateTime),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
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
            /* DropdownButtonHideUnderline(
              child: DropdownButton2(
                value: statusSelecionado,
                hint: Text(
                  statusSelecionado,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                items: status.map((String items) {
                  return DropdownMenuItem(
                      value: items,
                      child: Text(
                        items,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    statusSelecionado = newValue!;
                    _obterTodasHospedagem(statusSelecionado);
                  });
                },
              ),
            )*/
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            paginaPetHospedagem();
          },
          icon: const Icon(Icons.add),
          backgroundColor: const Color.fromRGBO(249, 94, 0, 1),
          hoverColor: const Color.fromRGBO(249, 94, 0, 100),
          foregroundColor: Colors.white,
          label: Text("Novo"),
        ),
        body: !loading
            ? ListView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: hospedagen.length,
                itemBuilder: (context, index) {
                  return _cartaoHospedagem(context, index);
                })
            : Center(
                child: CircularProgressIndicator(
                  color: Colors.greenAccent,
                  backgroundColor: Colors.grey,
                ),
              ),
      ),
    );
  }

  Widget _cartaoHospedagem(BuildContext context, int index) {
    double valorTotal = double.parse(hospedagen[index].valorTotal!.toString());
    DateTime dataIn = DateTime.parse(hospedagen[index].dataCheckIn.toString());
    DateTime dataOut =
        DateTime.parse(hospedagen[index].dataCheckOut.toString());
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
                  color: Colors.blueAccent,
                  icon: Icons.edit,
                  caption: 'Editar',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditarHospedagem(
                              hospedagem: hospedagen[index],
                            )));
                  },
                ),
                IconSlideAction(
                  color: Colors.redAccent,
                  icon: Icons.delete,
                  caption: 'Excluir',
                  onTap: () {
                    // info.deletarHospedagemFirestore(hospedagen[index].id!);
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
                          "Pet: ",
                          style: TextStyle(
                            color: Color.fromARGB(255, 73, 66, 2),
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          hospedagen[index].nomePet ?? "",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
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
                          DateFormat("dd/MM/yyyy").format(dataIn) ?? "",
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
                          hospedagen[index].horaCheckIn.toString() ?? "",
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
                          DateFormat("dd/MM/yyyy").format(dataOut) ?? "",
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
                          "R\$ " + valorTotal!.toStringAsFixed(2) ?? "",
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
                    idHospedagem: hospedagen[index].id,
                    pendente: pendente,
                    status: hospedagen[index].status.toString(),
                  )));
        });
  }

  void _obterTodasHospedagem(String data) {
    /* info.obterTodasHospedagemDiaFirestore(data).then((dynamic list) {
      setState(() {
        hospedagen = list;
        String timestamp = DateFormat('dd/MM/yyyy, hh:MM')
            .format(hospedagen[0].dataCheckIn.toDate());
        DateTime start = DateTime.parse(timestamp);
        String timestamp2 = DateFormat('dd/MM/yyyy, hh:MM')
            .format(hospedagen[0].dataCheckOut.toDate());
        DateTime end = DateTime.parse(timestamp2);
        var diaria = DateTimeRange(start: start, end: end).duration.inDays;
        print("diaria $diaria");
      });
    });*/
    info.obterTodasHospedagensApi().then((dynamic list) {
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
