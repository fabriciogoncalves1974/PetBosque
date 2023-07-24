import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pet_bosque/funcoes/info_contato.dart';
import 'package:pet_bosque/funcoes/info_pet.dart';
import 'package:pet_bosque/paginas/lista_contato.dart';
import 'package:pet_bosque/paginas/lista_pet_contato.dart';
import 'package:pet_bosque/paginas/novo_contato.dart';

class PesquisaPage extends SearchDelegate<Contato?> {
  InfoContato info = InfoContato();
  InfoPet infoPet = InfoPet();

  List<Contato> contatos = [];
  List<Pet> pets = [];

  @override
  String get searchFieldLabel => 'Pesquisar Contato';

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
    return FutureBuilder<List<Contato>>(
      future: _pesquisarTodosContatos(),
      builder: (context, snapshot) {
        final List<Contato>? contatos = snapshot.data;
        if (snapshot.hasData && contatos != null) {
          return Column(
            children: [
              if (snapshot.connectionState == ConnectionState.waiting)
                const LinearProgressIndicator(),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final contato = contatos[index];
                    return GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Slidable(
                          actionExtentRatio: 0.25,
                          actionPane: const SlidableDrawerActionPane(),
                          secondaryActions: [
                            IconSlideAction(
                              color: Colors.blue,
                              icon: Icons.edit,
                              caption: 'Editar',
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NovoContato(
                                              contato: contato,
                                            )));
                              },
                            ),
                            IconSlideAction(
                              color: Colors.red,
                              icon: Icons.delete,
                              caption: 'Excluir',
                              onTap: () {
                                info.deletarContato(contatos[index].id!);
                                infoPet.deletarPetContato(contatos[index].id!);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ListaContatos()));
                              },
                            ),
                          ],
                          actions: [
                            IconSlideAction(
                                color: Colors.yellow,
                                icon: Icons.pets,
                                caption: 'Pets',
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ListaPetContato(
                                            idContato:
                                                contatos[index].id.toString(),
                                            nomeContato:
                                                contatos[index].nome.toString(),
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
                                      "Cliente: ",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 73, 66, 2),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      contatos[index].nome ?? "",
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
                                      "Telefone: ",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 73, 66, 2),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      contatos[index].telefone ?? "",
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Cidade: ",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 73, 66, 2),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      contatos[index].cidade ?? "",
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
                  itemCount: contatos.length,
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

  Future<List<Contato>> _pesquisarTodosContatos() {
    return info.pesquisarTodosContatosFirestore(query);
  }
}
