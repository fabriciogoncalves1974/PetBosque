import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pet_bosque/funcoes/info_coloborador.dart';
import 'package:pet_bosque/funcoes/info_hospedagem.dart';
import 'package:pet_bosque/paginas/lista_contato.dart';
import 'package:pet_bosque/paginas/lista_hospedagem.dart';
import 'package:pet_bosque/paginas/lista_pet.dart';

enum OrderOption { orderaz, orderza }

InfoHospedagem info = InfoHospedagem();
InfoColaborador infoColaborador = InfoColaborador();

class DetalheHospedagem extends StatefulWidget {
  const DetalheHospedagem(
      {Key? key, required this.idHospedagem, required this.pendente})
      : super(key: key);

  final int idHospedagem;
  final bool pendente;

  @override
  State<DetalheHospedagem> createState() => _DetalheHospedagemState();
}

class _DetalheHospedagemState extends State<DetalheHospedagem> {
  List<Hospedagem> hospedagem = [];
  List<Colaborador> colaborador = [];
  List<Colaborador> itens = [];

  late String status;
  late int idHospedagem;
  late int hospedagemId;
  String nomeColaborador = "Geral";
  String idColaborador = "1";
  late String valorBanho;
  late String valoradicional;
  late String observacao;
  late String porte;

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

    _obterHospedagem();
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
          title: const Text("Detalhe da Hospedagem"),
          centerTitle: true,
        ),
        body: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _detalhes(context, index);
                },
                childCount: hospedagem.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detalhes(BuildContext context, int index) {
    hospedagemId = hospedagem[index].id!;
    status = hospedagem[index].status!;
    double totalDiarias =
        (hospedagem[index].dia! * hospedagem[index].valorDia!);
    if (hospedagem[index].observacao == null) {
      observacao = "Sem observação";
    } else {
      observacao = hospedagem[index].observacao.toString();
    }
    if (hospedagem[index].porte == 'null') {
      porte = "Não informado";
    } else {
      porte = hospedagem[index].porte.toString();
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
              child: Image.file(File(hospedagem[index].fotoPet!),
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
                  "Check IN: ",
                  style: TextStyle(
                    color: Color.fromARGB(255, 73, 66, 2),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  hospedagem[index].dataCheckIn ?? "",
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
                  hospedagem[index].horaCheckIn ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
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
                  hospedagem[index].dataCheckOut ?? "",
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
                  hospedagem[index].horaCheckOut ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
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
                  hospedagem[index].nomeContato ?? "",
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
                "Dados do Pet ",
                style: TextStyle(
                  color: Color.fromARGB(255, 73, 66, 2),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ]),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const Text(
                  "Nome: ",
                  style: TextStyle(
                    color: Color.fromARGB(255, 73, 66, 2),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  hospedagem[index].nomePet ?? "",
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
                  "Porte: ",
                  style: TextStyle(
                    color: Color.fromARGB(255, 73, 66, 2),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  porte ?? "",
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
                  "Genero: ",
                  style: TextStyle(
                    color: Color.fromARGB(255, 73, 66, 2),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  hospedagem[index].genero ?? "",
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
                  "Nº Diárias: ",
                  style: TextStyle(
                    color: Color.fromARGB(255, 73, 66, 2),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  hospedagem[index].dia.toString() ?? "",
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
                  "Valor Diária: ",
                  style: TextStyle(
                    color: Color.fromARGB(255, 73, 66, 2),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "R\$ " + hospedagem[index].valorDia!.toStringAsFixed(2) ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text(
                          "Total (N° x Valor): ",
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
                        "R\$ " + totalDiarias!.toStringAsFixed(2) ?? "",
                        textAlign: TextAlign.center,
                        style: const TextStyle(height: 2, fontSize: 20),
                      ),
                    ),
                  ]),
            ),
            Container(
              color: const Color.fromARGB(255, 228, 222, 222),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text(
                          "Valor Adicional",
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
                        "R\$ " +
                                hospedagem[index]
                                    .adicional!
                                    .toStringAsFixed(2) ??
                            "",
                        textAlign: TextAlign.center,
                        style: const TextStyle(height: 2, fontSize: 20),
                      ),
                    ),
                  ]),
            ),
            const SizedBox(
              height: 10,
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
                                hospedagem[index]
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
                                title: const Text("Cancelar Hospedagem?"),
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
                                      idHospedagem = hospedagemId;
                                      _alterarStatus(
                                          idHospedagem, status, "0", "0");
                                      if (widget.pendente == false) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ListaHospedagem()));
                                      }
                                      if (widget.pendente == true) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ListaHospedagem()));
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
                                  title: const Text("Finalizar Hospedagem?"),
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
                                        idHospedagem = hospedagemId;
                                        _alterarStatus(idHospedagem, status,
                                            nomeColaborador, idColaborador);
                                        if (widget.pendente == false) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ListaHospedagem()));
                                        }
                                        if (widget.pendente == true) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ListaHospedagem()));
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
          ],
        ),
      ),
    );
    onTap:
    () {};
  }

  void _alterarStatus(
      int id, String status, String colaborador, String idColaborador) {
    info.atualizarStatus(idHospedagem, status, nomeColaborador, idColaborador);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ListaHospedagem()),
    );
  }

  void _obterHospedagem() {
    info.obterHospedagemContato(widget.idHospedagem).then((dynamic list) {
      setState(() {
        hospedagem = list;
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
