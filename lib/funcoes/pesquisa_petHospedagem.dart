import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pet_bosque/funcoes/info_pet.dart';
import 'package:pet_bosque/paginas/nova_hospedagem.dart';

class PesquisaPetHospedagem extends SearchDelegate<Pet?> {
  InfoPet infoPet = InfoPet();

  List<Pet> pets = [];
  late String contadorPlano;

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
    // TODO: implement buildResults
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
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => NovaHospedagem(
                                          fotoPet: pets[index].foto.toString(),
                                          nomeContato: pets[index]
                                              .nomeContato
                                              .toString(),
                                          nomePet:
                                              pets[index].nomePet.toString(),
                                          idPet: pets[index].id.toString(),
                                          porte: pets[index].porte.toString(),
                                          genero: pets[index].genero.toString(),
                                        )));
                              },
                            ),
                          ],
                          actions: [
                            IconSlideAction(
                              color: Colors.blueAccent,
                              icon: Icons.photo,
                              caption: 'Foto',
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
    return infoPet.pesquisarTodosPetApi(query);
  }
}
