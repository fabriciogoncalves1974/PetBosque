import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pet_bosque/funcoes/info_pet.dart';
import 'package:pet_bosque/paginas/detalhe_contato.dart';
import 'package:pet_bosque/paginas/editar_pet.dart';
import 'package:pet_bosque/paginas/inicio.dart';

class PesquisaTodosPetPage extends SearchDelegate<Pet?> {
  InfoPet infoPet = InfoPet();

  List<Pet> pets = [];
  late String contadorPlano;
  String renovaPlanoSim = "S";
  String renovaPlanoNao = "N";

  @override
  String get searchFieldLabel => 'Pesquisar Pet';

  @override
  List<Widget>? buildActions(BuildContext context) {
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
                              color: Colors.blueAccent,
                              icon: Icons.edit,
                              caption: 'Editar',
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditarPet(
                                              pet: pets[index],
                                            )));
                              },
                            ),
                            IconSlideAction(
                              color: Colors.redAccent,
                              icon: Icons.delete,
                              caption: 'Excluir',
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                            "Deseja realmente excluir o Pet  ${pets[index].nomePet}?"),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              fixedSize: const Size(120, 50),
                                              backgroundColor: Colors.redAccent,
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
                                              "Não",
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
                                              //infoPet.deletarPetFirestore(
                                              // pets[index].id!);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const Inicio(
                                                            index: 3,
                                                          )));
                                            },
                                            child: const Text(
                                              "Sim",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
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
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      pets[index].nomeContato ?? "",
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
                                      "Data Nascimento: ",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 73, 66, 2),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      pets[index].dtNasc ?? "",
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Genero: ",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 73, 66, 2),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      pets[index].genero ?? "",
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Porte: ",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 73, 66, 2),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      pets[index].porte ?? "",
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "raça: ",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 73, 66, 2),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      pets[index].raca ?? "",
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Cor: ",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 73, 66, 2),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      pets[index].cor ?? "",
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Especie: ",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 73, 66, 2),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      pets[index].especie ?? "",
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                if (pets[index].idPlano != "0")
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
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text(
                                        "Valor: ",
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 73, 66, 2),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        pets[index].valorPlano ?? "",
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text(
                                        "Contratação: ",
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 73, 66, 2),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        pets[index].dataContrato ?? "",
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                if (pets[index].idPlano! != "0")
                                  Row(
                                    children: [
                                      const Text(
                                        "Agendamentos Restantes: ",
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 73, 66, 2),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        pets[index].contaPlano.toString() ?? "",
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
                            builder: (context) => DetalheContato(
                                idContato: pets[index].idContato!)));
                      },
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
