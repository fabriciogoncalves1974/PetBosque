import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:pet_bosque/funcoes/info_pet.dart';
import 'package:pet_bosque/funcoes/pesquisa_pet.dart';
import 'package:pet_bosque/paginas/lista_agendamentos.dart';
import 'package:pet_bosque/paginas/novo_agendamento.dart';
import 'package:pet_bosque/paginas/novo_agendamentoPlano.dart';
import 'package:pet_bosque/paginas/principal.dart';

enum OrderOption { orderaz, orderza }

class ListaPet extends StatefulWidget {
  const ListaPet({Key? key}) : super(key: key);

  @override
  State<ListaPet> createState() => _ListaPetState();
}

class _ListaPetState extends State<ListaPet> {
  InfoPet info = InfoPet();
  bool loading = true;
  List<Pet> pet = [];
  late String contadorPlano;
  String data = DateFormat("dd/MM/yyyy").format(DateTime.now());

  String renovaPlanoSim = "S";
  String renovaPlanoNao = "N";

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
      MaterialPageRoute(builder: (context) => const Principal()),
    );
  }

  @override
  void initState() {
    super.initState();

    _obterTodosPet();
    loading = false;
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
          title: const Text("Pets"),
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
                showSearch(
                  context: context,
                  delegate: PesquisaPetPage(),
                );
              },
              icon: const Icon(Icons.search),
            ),
            PopupMenuButton<OrderOption>(
              itemBuilder: (context) => <PopupMenuEntry<OrderOption>>[
                const PopupMenuItem<OrderOption>(
                  value: OrderOption.orderaz,
                  child: Text("Ordenar de A-Z"),
                ),
                const PopupMenuItem<OrderOption>(
                  value: OrderOption.orderza,
                  child: Text("Ordenar de Z-A"),
                ),
              ],
              onSelected: _ordenarLista,
            )
          ],
        ),
        body: !loading
            ? ListView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: pet.length,
                itemBuilder: (context, index) {
                  return _cartaoPet(context, index);
                })
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Widget _cartaoPet(BuildContext context, int index) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Slidable(
          actionExtentRatio: 0.25,
          actionPane: const SlidableDrawerActionPane(),
          secondaryActions: [
            IconSlideAction(
              color: Colors.greenAccent,
              icon: Icons.add,
              caption: 'Agendar',
              onTap: () {
                if (pet[index].idPlano.toString() != "" &&
                    pet[index].contaPlano! > 0) {
                  contadorPlano = pet[index].contaPlano.toString();
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                              "Esse pet possui $contadorPlano agendamentos restantes! "),
                          actions: <Widget>[
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(120, 50),
                                backgroundColor: Colors.redAccent,
                                side: const BorderSide(
                                    width: 3, color: Colors.redAccent),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Cancelar",
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
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => NovoAgendamentoPlano(
                                        fotoPet: pet[index].foto.toString(),
                                        nomeContato:
                                            pet[index].nomeContato.toString(),
                                        nomePet: pet[index].nomePet.toString(),
                                        idPet: pet[index].id.toString(),
                                        contaPlano:
                                            pet[index].contaPlano.toString(),
                                        renovaPlano: renovaPlanoNao,
                                        idPlano:
                                            pet[index].idPlano.toString())));
                              },
                              child: const Text(
                                "Continuar",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      });
                }
                if (pet[index].idPlano != "0" && pet[index].contaPlano! == 0) {
                  contadorPlano = pet[index].contaPlano.toString();
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                              "Esse pet possui $contadorPlano agendamentos restantes! "),
                          actions: <Widget>[
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(300, 50),
                                backgroundColor: Colors.redAccent,
                                side: const BorderSide(
                                    width: 3, color: Colors.redAccent),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Cancelar",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(300, 50),
                                backgroundColor: Colors.yellowAccent,
                                side: const BorderSide(
                                    width: 3, color: Colors.yellowAccent),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => NovoAgendamentoPlano(
                                        fotoPet: pet[index].foto.toString(),
                                        nomeContato:
                                            pet[index].nomeContato.toString(),
                                        nomePet: pet[index].nomePet.toString(),
                                        idPet: pet[index].id.toString(),
                                        contaPlano:
                                            pet[index].contaPlano.toString(),
                                        renovaPlano: renovaPlanoNao,
                                        idPlano:
                                            pet[index].idPlano.toString())));
                              },
                              child: const Text(
                                "Agendar sem Renovar",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(300, 50),
                                backgroundColor: Colors.blueAccent,
                                side: const BorderSide(
                                    width: 3, color: Colors.blueAccent),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => NovoAgendamentoPlano(
                                        fotoPet: pet[index].foto.toString(),
                                        nomeContato:
                                            pet[index].nomeContato.toString(),
                                        nomePet: pet[index].nomePet.toString(),
                                        idPet: pet[index].id.toString(),
                                        contaPlano:
                                            pet[index].contaPlano.toString(),
                                        renovaPlano: renovaPlanoSim,
                                        idPlano:
                                            pet[index].idPlano.toString())));
                              },
                              child: const Text(
                                "Renovar e Agendar",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        );
                      });
                }
                if (pet[index].idPlano == "0") {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NovoAgendamento(
                            fotoPet: pet[index].foto.toString(),
                            nomeContato: pet[index].nomeContato.toString(),
                            nomePet: pet[index].nomePet.toString(),
                            idPet: pet[index].id.toString(),
                            contaPlano: pet[index].contaPlano.toString(),
                          )));
                }
              },
            ),
          ],
          actions: [
            GestureDetector(
              child: Image.file(
                File(pet[index].foto ?? ""),
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset("assets/imagens/pet.png"),
                fit: BoxFit.cover,
              ),
              onTap: () {},
            ),
          ],
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.grey[200],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Text(
                      "Pet: ",
                      style: TextStyle(
                        color: Color.fromARGB(255, 73, 66, 2),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      pet[index].nomePet ?? "",
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
                      "Contato: ",
                      style: TextStyle(
                        color: Color.fromARGB(255, 73, 66, 2),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      pet[index].nomeContato ?? "",
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
      onTap: () {},
    );
  }

  void _obterTodosPet() {
    info.obterTodosPetFirestore().then((dynamic list) {
      setState(() {
        pet = list;
      });
    });
  }

  void _ordenarLista(OrderOption result) {
    switch (result) {
      case OrderOption.orderaz:
        pet.sort((a, b) =>
            a.nomePet!.toLowerCase().compareTo(b.nomePet!.toLowerCase()));
        break;
      case OrderOption.orderza:
        pet.sort((a, b) =>
            b.nomePet!.toLowerCase().compareTo(a.nomePet!.toLowerCase()));
        break;
    }
    setState(() {});
  }
}
