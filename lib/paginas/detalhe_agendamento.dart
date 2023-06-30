import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:pet_bosque/funcoes/info_agendamento.dart';
import 'package:pet_bosque/funcoes/info_coloborador.dart';
import 'package:pet_bosque/paginas/lista_agendamentos.dart';
import 'package:pet_bosque/paginas/lista_agendamentosPendentes.dart';
import 'package:pet_bosque/paginas/lista_contato.dart';
import 'package:pet_bosque/paginas/lista_pet.dart';

enum OrderOption { orderaz, orderza }

InfoAgendamento info = InfoAgendamento();
InfoColaborador infoColaborador = InfoColaborador();

class DetalheAgendamentos extends StatefulWidget {
  const DetalheAgendamentos(
      {Key? key, required this.idAgendamento, required this.pendente})
      : super(key: key);

  final int idAgendamento;
  final bool pendente;

  @override
  State<DetalheAgendamentos> createState() => _DetalheAgendamentosState();
}

class _DetalheAgendamentosState extends State<DetalheAgendamentos> {
  List<Agendamento> agendamento = [];
  List<Colaborador> colaborador = [];
  List<Colaborador> itens = [];
  DateTime data = DateTime.now();

  late String status;
  late int idAgendamento;
  late int agendamentoId;
  String nomeColaborador = "Geral";
  String idColaborador = "1";
  late String valorBanho;
  late String valoradicional;
  late String observacao;

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

  paginaPet() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ListaPet()),
    );
  }

  @override
  void initState() {
    super.initState();

    _obterAgendamentos();
    _obterColaboradores();
  }

  Colaborador? selectedValue;

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
          title: const Text("Detalhe do Agendamento"),
          centerTitle: true,
        ),
        body: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _detalhes(context, index);
                },
                childCount: agendamento.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detalhes(BuildContext context, int index) {
    agendamentoId = agendamento[index].id!;
    status = agendamento[index].status!;

    if (agendamento[index].valorAdicional == null) {
      valoradicional = "0.00";
    } else {
      valoradicional =
          agendamento[index].valorAdicional!.toStringAsFixed(2) ?? "";
    }
    if (agendamento[index].observacao == null) {
      observacao = "Sem observação";
    } else {
      observacao = agendamento[index].observacao.toString();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.grey[200],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 140.0,
              height: 140.0,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,

                // border: Border.all(
                //   width: 2,
                //   color: Colors.red,
                // ),
              ),
              child: Image.file(File(agendamento[index].fotoPet!),
                  errorBuilder: (context, error, stackTrace) =>
                      Image.asset("assets/imagens/pet.png"),
                  fit: BoxFit.cover),
            ),
            const SizedBox(
              height: 10,
            ),
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
                  agendamento[index].data ?? "",
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
            const SizedBox(
              height: 5,
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
                  width: 20,
                ),
                const Icon(color: Color.fromARGB(255, 73, 66, 2), Icons.pets),
                Text(
                  agendamento[index].nomePet ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const Row(children: [
              Text(
                "Serviços: ",
                style: TextStyle(
                  color: Color.fromARGB(255, 73, 66, 2),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ]),
            if (agendamento[index].svBanho == "S")
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                          Text(
                            "Banho",
                            textAlign: TextAlign.center,
                            style: TextStyle(height: 2, fontSize: 15),
                          ),
                        ],
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                          width: 150,
                        ),
                        child: Text(
                          agendamento[index].valorBanho!.toStringAsFixed(2) ??
                              "",
                          textAlign: TextAlign.center,
                          style: const TextStyle(height: 2, fontSize: 15),
                        ),
                      ),
                    ]),
              ),
            const SizedBox(
              height: 5,
            ),
            if (agendamento[index].svTosa == "S")
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                          Text(
                            "Tosa",
                            textAlign: TextAlign.center,
                            style: TextStyle(height: 2, fontSize: 15),
                          ),
                        ],
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                          width: 150,
                        ),
                        child: Text(
                          agendamento[index].valorTosa!.toStringAsFixed(2) ??
                              "",
                          textAlign: TextAlign.center,
                          style: const TextStyle(height: 2, fontSize: 15),
                        ),
                      ),
                    ]),
              ),
            const SizedBox(
              height: 5,
            ),
            if (agendamento[index].svTosaHigienica == "S")
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                          Text(
                            "Tosa Higienica",
                            textAlign: TextAlign.center,
                            style: TextStyle(height: 2, fontSize: 15),
                          ),
                        ],
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                          width: 150,
                        ),
                        child: Text(
                          agendamento[index]
                                  .valorTosaHigienica!
                                  .toStringAsFixed(2) ??
                              "",
                          textAlign: TextAlign.center,
                          style: const TextStyle(height: 2, fontSize: 15),
                        ),
                      ),
                    ]),
              ),
            const SizedBox(
              height: 5,
            ),
            if (agendamento[index].svCorteUnha == "S")
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                          Text(
                            "Corte de Unha",
                            textAlign: TextAlign.center,
                            style: TextStyle(height: 2, fontSize: 15),
                          ),
                        ],
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                          width: 150,
                        ),
                        child: Text(
                          agendamento[index]
                                  .valorCorteUnha!
                                  .toStringAsFixed(2) ??
                              "",
                          textAlign: TextAlign.center,
                          style: const TextStyle(height: 2, fontSize: 15),
                        ),
                      ),
                    ]),
              ),
            const SizedBox(
              height: 5,
            ),
            if (agendamento[index].svHidratacao == "S")
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                          Text(
                            "Hidratação",
                            textAlign: TextAlign.center,
                            style: TextStyle(height: 2, fontSize: 15),
                          ),
                        ],
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                          width: 150,
                        ),
                        child: Text(
                          agendamento[index]
                                  .valorHidratacao!
                                  .toStringAsFixed(2) ??
                              "",
                          textAlign: TextAlign.center,
                          style: const TextStyle(height: 2, fontSize: 15),
                        ),
                      ),
                    ]),
              ),
            const SizedBox(
              height: 5,
            ),
            if (agendamento[index].svPintura == "S")
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                          Text(
                            "Pintura",
                            textAlign: TextAlign.center,
                            style: TextStyle(height: 2, fontSize: 15),
                          ),
                        ],
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                          width: 150,
                        ),
                        child: Text(
                          agendamento[index].valorPintura!.toStringAsFixed(2) ??
                              "",
                          textAlign: TextAlign.center,
                          style: const TextStyle(height: 2, fontSize: 15),
                        ),
                      ),
                    ]),
              ),
            const SizedBox(
              height: 5,
            ),
            if (agendamento[index].svHospedagem == "S")
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                          Text(
                            "Hospedagem",
                            textAlign: TextAlign.center,
                            style: TextStyle(height: 2, fontSize: 15),
                          ),
                        ],
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                          width: 150,
                        ),
                        child: Text(
                          agendamento[index]
                                  .valorHospedagem!
                                  .toStringAsFixed(2) ??
                              "",
                          textAlign: TextAlign.center,
                          style: const TextStyle(height: 2, fontSize: 15),
                        ),
                      ),
                    ]),
              ),
            const SizedBox(
              height: 5,
            ),
            if (agendamento[index].svTransporte == "S")
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                          Text(
                            "Transporte",
                            textAlign: TextAlign.center,
                            style: TextStyle(height: 2, fontSize: 15),
                          ),
                        ],
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                          width: 150,
                        ),
                        child: Text(
                          agendamento[index]
                                  .valorTransporte!
                                  .toStringAsFixed(2) ??
                              "",
                          textAlign: TextAlign.center,
                          style: const TextStyle(height: 2, fontSize: 15),
                        ),
                      ),
                    ]),
              ),
            const SizedBox(
              height: 5,
            ),
            Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text(
                          "Adicional",
                          textAlign: TextAlign.center,
                          style: TextStyle(height: 2, fontSize: 15),
                        ),
                      ],
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(
                        width: 150,
                      ),
                      child: Text(
                        valoradicional ?? "",
                        textAlign: TextAlign.center,
                        style: const TextStyle(height: 2, fontSize: 20),
                      ),
                    ),
                  ]),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text(
                          "Total",
                          textAlign: TextAlign.center,
                          style: TextStyle(height: 2, fontSize: 20),
                        ),
                      ],
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(
                        width: 150,
                      ),
                      child: Text(
                        "R\$ " +
                                agendamento[index]
                                    .valorTotal!
                                    .toStringAsFixed(2) ??
                            "",
                        textAlign: TextAlign.center,
                        style: const TextStyle(height: 2, fontSize: 20),
                      ),
                    ),
                  ]),
            ),
            const SizedBox(
              height: 5,
            ),
            const Row(children: [
              Expanded(
                child: Text(
                  "Observação:",
                  style: TextStyle(
                    color: Color.fromARGB(255, 73, 66, 2),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
            ]),
            Row(children: [
              Text(
                observacao ?? "",
                textAlign: TextAlign.center,
                style: const TextStyle(height: 2, fontSize: 15),
              ),
            ]),
            Row(children: [
              const Text(
                "Colaborador:",
                style: TextStyle(
                  color: Color.fromARGB(255, 73, 66, 2),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                agendamento[index].colaborador ?? "",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (status == "Pendente")
                DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    hint: Text(
                      '  Selecione',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    items: itens
                        .map((item) => DropdownMenuItem<Colaborador>(
                              value: item,
                              child: Text(
                                item.nomeColaborador.toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ))
                        .toList(),
                    value: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value as Colaborador;
                      });
                    },
                    buttonStyleData: const ButtonStyleData(
                      height: 40,
                      width: 140,
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                    ),
                  ),
                ),
            ]),
            if (status == "Pendente")
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    width: 150,
                    height: 50,
                    child: TextButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(120, 50),
                        backgroundColor: Colors.redAccent,
                        side:
                            const BorderSide(width: 3, color: Colors.redAccent),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Cancelar Agendamento?"),
                                content: const Text(
                                    "Ao clicar em finalizar não sera possivel alterar o status."),
                                actions: <Widget>[
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(120, 50),
                                      backgroundColor: Colors.redAccent,
                                      side: const BorderSide(
                                          width: 3, color: Colors.redAccent),
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Não",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(120, 50),
                                      backgroundColor: Colors.blueAccent,
                                      side: const BorderSide(
                                          width: 3, color: Colors.blueAccent),
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    onPressed: () {
                                      status = "Cancelado";
                                      idAgendamento = agendamentoId;
                                      _alterarStatus(
                                          idAgendamento, status, "0", "0");
                                      if (widget.pendente == false) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ListaAgendamentos(
                                                        data: agendamento[index]
                                                            .data
                                                            .toString())));
                                      }
                                      if (widget.pendente == true) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ListaAgendamentosPendentes()));
                                      }
                                    },
                                    child: const Text(
                                      "Sim",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 35,
                  ),
                  Container(
                      margin: const EdgeInsets.all(10.0),
                      width: 150,
                      height: 50,
                      child: TextButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(120, 50),
                          backgroundColor: Colors.blueAccent,
                          side: const BorderSide(
                              width: 3, color: Colors.blueAccent),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Finalizar Agendamento?"),
                                  content: const Text(
                                      "Ao clicar em finalizar não sera possivel alterar o status."),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: const Size(120, 50),
                                        backgroundColor: Colors.redAccent,
                                        side: const BorderSide(
                                            width: 3, color: Colors.redAccent),
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Não",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: const Size(120, 50),
                                        backgroundColor: Colors.blueAccent,
                                        side: const BorderSide(
                                            width: 3, color: Colors.blueAccent),
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      onPressed: () {
                                        status = "Finalizado";
                                        idAgendamento = agendamentoId;
                                        _alterarStatus(idAgendamento, status,
                                            nomeColaborador, idColaborador);
                                        if (widget.pendente == false) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ListaAgendamentos(
                                                          data: agendamento[
                                                                  index]
                                                              .data
                                                              .toString())));
                                        }
                                        if (widget.pendente == true) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ListaAgendamentosPendentes()));
                                        }
                                      },
                                      child: const Text(
                                        "Sim",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: const Text(
                          'Finalizar',
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ],
              ),
            if (agendamento[index].status == "Finalizado")
              Row(
                children: [
                  const Icon(color: Colors.blue, Icons.check_box),
                  Text(
                    agendamento[index].status ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            if (agendamento[index].status == "Cancelado")
              Row(
                children: [
                  const Icon(color: Colors.red, Icons.cancel),
                  Text(
                    agendamento[index].status ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
    onTap:
    () {};
  }

  void _alterarStatus(
      int id, String status, String colaborador, String idColaborador) {
    if (selectedValue != null) {
      nomeColaborador = selectedValue!.nomeColaborador.toString();
      idColaborador = selectedValue!.id.toString();
    }
    info.atualizarStatus(idAgendamento, status, nomeColaborador, idColaborador);
    Navigator.pop(context);
  }

  void _obterAgendamentos() {
    info.obterAgendamentoContato(widget.idAgendamento).then((dynamic list) {
      setState(() {
        agendamento = list;
      });
    });
  }

  void _obterColaboradores() {
    infoColaborador.obterNomeColaborador().then((dynamic listaColaborador) {
      setState(() {
        itens = listaColaborador;
      });
    });
  }
}

//Customizar ListTile do menu
class CustomListTile extends StatelessWidget {
  final IconData icone;
  final String texto;
  final void Function()? onTap;

  //CustomListTile(this.icone, this.texto);
  const CustomListTile({
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
