import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pet_bosque/funcoes/info_pet.dart';
import 'package:pet_bosque/paginas/novo_agendamento.dart';
import 'package:pet_bosque/paginas/novo_agendamentoPlano.dart';

class PesquisaPetPage extends SearchDelegate<Pet?> {
  InfoPet infoPet = InfoPet();

  List<Pet> pets = [];
  late String contadorPlano;
  String renovaPlanoSim = "S";
  String renovaPlanoNao = "N";

  @override
  String get searchFieldLabel => 'Pesquisar Pet';

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Pet>>(
      future: _pesquisarTodosPets(),
      builder: (context, snapshot) {
        final List<Pet>? pets = snapshot.data;
        if (snapshot.hasData && pets != null) {
          return Column(
            children: [
              if (snapshot.connectionState == ConnectionState.waiting)
                const LinearProgressIndicator(),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final pet = pets[index];
                    return GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Slidable(
                          actionExtentRatio: 0.25,
                          actionPane: const SlidableDrawerActionPane(),
                          secondaryActions: [
                            IconSlideAction(
                              color: Colors.green,
                              icon: Icons.add,
                              caption: 'Agendar',
                              onTap: () {
                                if (pets[index].idPlano != "0") {
                                  contadorPlano =
                                      pets[index].contaPlano.toString();
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
                                                backgroundColor:
                                                    Colors.redAccent,
                                                side: const BorderSide(
                                                    width: 3,
                                                    color: Colors.redAccent),
                                                elevation: 3,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                "Cancelar",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                fixedSize: const Size(120, 50),
                                                backgroundColor:
                                                    Colors.blueAccent,
                                                side: const BorderSide(
                                                    width: 3,
                                                    color: Colors.blueAccent),
                                                elevation: 3,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        NovoAgendamentoPlano(
                                                            fotoPet: pets[index]
                                                                .foto
                                                                .toString(),
                                                            nomeContato:
                                                                pets[index]
                                                                    .nomeContato
                                                                    .toString(),
                                                            nomePet: pets[index]
                                                                .nomePet
                                                                .toString(),
                                                            idPet: pets[index]
                                                                .id
                                                                .toString(),
                                                            contaPlano:
                                                                pets[index]
                                                                    .contaPlano
                                                                    .toString(),
                                                            renovaPlano:
                                                                renovaPlanoNao,
                                                            idPlano: pets[index]
                                                                .idPlano
                                                                .toString())));
                                              },
                                              child: const Text(
                                                "Continuar",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                }
                                if (pets[index].idPlano == "0") {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => NovoAgendamento(
                                            fotoPet:
                                                pets[index].foto.toString(),
                                            nomeContato: pets[index]
                                                .nomeContato
                                                .toString(),
                                            nomePet:
                                                pets[index].nomePet.toString(),
                                            idPet: pets[index].id.toString(),
                                            contaPlano: pets[index]
                                                .contaPlano
                                                .toString(),
                                          )));
                                }
                              },
                            ),
                          ],
                          actions: [
                            GestureDetector(
                              child: Image.file(
                                File(pets[index].foto ?? ""),
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
                              color: const Color.fromRGBO(204, 236, 247, 100),
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
                                      pets[index].nomePet ?? "",
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
                                      pets[index].nomeContato ?? "",
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                if (pets[index].nomePlano != 'N')
                                  Row(
                                    children: [
                                      const Text(
                                        "Plano: ",
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 73, 66, 2),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        pets[index].nomePlano ?? "",
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
                  },
                  itemCount: pets.length,
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Future<List<Pet>> _pesquisarTodosPets() {
    return infoPet.pesquisarTodosPetFirestore(query);
  }
}
