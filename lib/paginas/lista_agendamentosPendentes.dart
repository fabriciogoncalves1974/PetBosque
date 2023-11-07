import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:pet_bosque/funcoes/info_agendamento.dart';
import 'package:pet_bosque/paginas/detalhe_agendamento.dart';
import 'package:pet_bosque/paginas/inicio.dart';
import 'package:pet_bosque/paginas/lista_colaborador.dart';
import 'package:pet_bosque/paginas/lista_contato.dart';
import 'package:pet_bosque/paginas/lista_pet.dart';
import 'package:pet_bosque/paginas/lista_planos.dart';
import 'package:pet_bosque/paginas/principal.dart';

enum OrderOption { orderaz, orderza }

InfoAgendamento info = InfoAgendamento();

class ListaAgendamentosPendentes extends StatefulWidget {
  const ListaAgendamentosPendentes({Key? key}) : super(key: key);

  @override
  State<ListaAgendamentosPendentes> createState() =>
      _ListaAgendamentosPendentesState();
}

class _ListaAgendamentosPendentesState
    extends State<ListaAgendamentosPendentes> {
  List<Agendamento> agendamento = [];
  late String _dataAgendamento;
  DateTime _dateTime = DateTime.now();
  final bool pendente = true;
  Color corPendente = Colors.yellow;
  Color corCancelado = Colors.red;
  Color corFinalizado = Colors.blue;
  Color corStatus = Color.fromRGBO(202, 236, 236, 1);
  bool loading = true;

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

  paginaPet() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ListaPet()),
    );
  }

  paginaConfig() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const Principal()),
    );
  }

  // FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();

    setState(() {
      _obterTodosAgendamentosPendentes();
      loading = false;
    });
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
          title: const Text("Agendamentos Pendentes"),
          leading: IconButton(
            onPressed: () {
              paginaInicial();
            },
            icon: const Icon(Icons.home_outlined),
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            paginaPet();
          },
          icon: const Icon(Icons.add),
          backgroundColor: Color.fromRGBO(35, 151, 166, 1),
          hoverColor: Color.fromRGBO(35, 151, 166, 50),
          foregroundColor: Colors.white,
          label: Text("Novo"),
        ),
        body: !loading
            ? ListView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: agendamento.length,
                itemBuilder: (context, index) {
                  return _cartaoContato(context, index);
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

  Widget _cartaoContato(BuildContext context, int index) {
    DateTime data = DateTime.parse(agendamento[index].data.toString());
    double valorTotal = double.parse(agendamento[index].valorTotal!.toString());
    if (agendamento[index].status == "Pendente") {
      corStatus = corPendente;
    }
    if (agendamento[index].status == "Cancelado") {
      corStatus = corCancelado;
    }
    if (agendamento[index].status == "Finalizado") {
      corStatus = corFinalizado;
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
                  //info.deletarAgendamentoFirestore(agendamento[index].id!);
                  setState(() {
                    agendamento.removeAt(index);
                  });
                },
              ),
            ],
            child: Container(
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Data: ",
                        style: TextStyle(
                          color: Color.fromARGB(255, 73, 66, 2),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        DateFormat("dd/MM/yyyy").format(data) ?? "",
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
                        agendamento[index].hora ?? "",
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
                        agendamento[index].nomeContato ?? "",
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
                        agendamento[index].nomePet ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const Row(children: [
                    Text(
                      "Serviços: ",
                      style: TextStyle(
                        color: Color.fromARGB(255, 73, 66, 2),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ]),
                  Row(children: [
                    if (agendamento[index].svBanho == "S")
                      const Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                    if (agendamento[index].svBanho == "S")
                      const Text(
                        "Banho",
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    if (agendamento[index].svTosa == "S")
                      const Icon(color: Colors.green, Icons.check),
                    if (agendamento[index].svTosa == "S")
                      const Text(
                        "Tosa",
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    if (agendamento[index].svTosaHigienica == "S")
                      const Icon(color: Colors.green, Icons.check),
                    if (agendamento[index].svTosaHigienica == "S")
                      const Text(
                        "Tosa Hig",
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    if (agendamento[index].svCorteUnha == "S")
                      const Icon(color: Colors.green, Icons.check),
                    if (agendamento[index].svCorteUnha == "S")
                      const Text(
                        "Corte Unha",
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                  ]),
                  Row(children: [
                    if (agendamento[index].svHidratacao == "S")
                      const Icon(color: Colors.green, Icons.check),
                    if (agendamento[index].svHidratacao == "S")
                      const Text(
                        "Hidratação",
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    if (agendamento[index].svPintura == "S")
                      const Icon(color: Colors.green, Icons.check),
                    if (agendamento[index].svPintura == "S")
                      const Text(
                        "Pintura",
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                  ]),
                  Row(children: [
                    if (agendamento[index].svTransporte == "S")
                      const Icon(color: Colors.red, Icons.delivery_dining),
                    if (agendamento[index].svHospedagem == "S")
                      const Icon(color: Colors.grey, Icons.house),
                  ]),
                  Row(
                    children: [
                      const Text(
                        "Total: ",
                        style: TextStyle(
                          color: Color.fromARGB(255, 73, 66, 2),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "R\$ " + valorTotal!.toStringAsFixed(2) ?? "",
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DetalheAgendamentos(
                    idAgendamento: agendamento[index].id,
                    pendente: pendente,
                  )));
        });
  }

  void _obterTodosAgendamentosPendentes() {
    info.obterTodosAgendamentosPendentesApi().then((dynamic list) {
      setState(() {
        agendamento = list;
      });
    });
  }

  void _ordenarLista(OrderOption result) {
    switch (result) {
      case OrderOption.orderaz:
        agendamento.sort((a, b) =>
            a.nomePet!.toLowerCase().compareTo(b.nomePet!.toLowerCase()));
        break;
      case OrderOption.orderza:
        agendamento.sort((a, b) =>
            b.nomePet!.toLowerCase().compareTo(a.nomePet!.toLowerCase()));
        break;
    }
    setState(() {});
  }
}

//Customizar ListTile do menu
class CustomListTilePendentes extends StatelessWidget {
  final IconData icone;
  final String texto;
  final void Function()? onTap;

  //CustomListTile(this.icone, this.texto);
  const CustomListTilePendentes({
    super.key,
    required this.icone,
    required this.texto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade400))),
        child: InkWell(
          splashColor: Colors.lightBlue,
          onTap: onTap,
          child: SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(icone),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        texto,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.arrow_right)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
