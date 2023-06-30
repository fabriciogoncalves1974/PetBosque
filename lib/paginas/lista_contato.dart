//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pet_bosque/funcoes/info_contato.dart';
import 'package:pet_bosque/funcoes/info_pet.dart';
import 'package:pet_bosque/funcoes/pesquisa.dart';
import 'package:pet_bosque/paginas/lista_pet.dart';
import 'package:pet_bosque/paginas/lista_pet_contato.dart';
import 'package:pet_bosque/paginas/novo_contato.dart';
import 'package:pet_bosque/paginas/principal.dart';

enum OrderOption { orderaz, orderza }

InfoContato info = InfoContato();
InfoPet infoPet = InfoPet();

class ListaContatos extends StatefulWidget {
  const ListaContatos({Key? key}) : super(key: key);

  @override
  State<ListaContatos> createState() => _ListaContatosState();
}

class _ListaContatosState extends State<ListaContatos> {
  List<Contato> contatos = [];
//  late CollectionReference contactCollection;
  // ContactDAOFirestore() {
  //   contactCollection = FirebaseFirestore.instance.collection('contact');
  // }

  paginaPet() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ListaPet()),
    );
  }

  paginaInicial() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const Principal()),
    );
  }

/*
  paginaPetContato() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) =>   ListaPetContato(idContato: )),
    );
  }
*/
  late String nomeContato;
  @override
  void initState() {
    super.initState();

    _obterTodosContatos();
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
          title: const Text("Contatos"),
          leading: IconButton(
            onPressed: () {
              paginaInicial();
            },
            icon: const Icon(Icons.home_outlined),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: PesquisaPage(),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _ExibirNovoContato();
          },
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: contatos.length,
            itemBuilder: (context, index) {
              return _cartaoContato(context, index);
            }),
      ),
    );
  }

  Widget _cartaoContato(BuildContext context, int index) {
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
                Navigator.pop(context);
                _ExibirNovoContato(contato: contatos[index]);
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
                        title: Text("Deseja realmente excluir o contato  " +
                            contatos[index].nome.toString() +
                            "?"),
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
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              info.deletarContato(contatos[index].id!);
                              infoPet.deletarPetContato(contatos[index].id!);

                              setState(() {
                                contatos.removeAt(index);
                                Navigator.pop(context);
                              });
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
            ),
          ],
          actions: [
            IconSlideAction(
                color: Colors.greenAccent,
                icon: Icons.pets,
                caption: 'Pets',
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ListaPetContato(
                            idContato: contatos[index].id.toString(),
                            nomeContato: contatos[index].nome.toString(),
                          )));
                }),
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
  }

  /* void _exibirOpcoes(BuildContext context, int index) {
    showBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton.icon(
                        label: const Text("Ligar"),
                        icon: const Icon(Icons.call),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.green,
                          backgroundColor:
                              const Color.fromARGB(255, 229, 228, 220),
                        ),
                        onPressed: () {
                          launchUrlString("tel:${contatos[index].telefone}");
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton.icon(
                        label: const Text("Pet"),
                        icon: const Icon(Icons.pets),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.blueAccent,
                          backgroundColor:
                              const Color.fromARGB(255, 229, 228, 220),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ListaPetContato(
                                    idContato: contatos[index].id.toString(),
                                    nomeContato:
                                        contatos[index].nome.toString(),
                                  )));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton.icon(
                          label: const Text("Editar"),
                          icon: const Icon(Icons.edit),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.orange,
                            backgroundColor:
                                const Color.fromARGB(255, 229, 228, 220),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _ExibirNovoContato(contato: contatos[index]);
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton.icon(
                        label: const Text("Excluir"),
                        icon: const Icon(Icons.delete),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.red,
                          backgroundColor:
                              const Color.fromARGB(255, 229, 228, 220),
                        ),
                        onPressed: () {
                          info.deletarContato(contatos[index].id!);
                          setState(() {
                            contatos.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }*/

  void _ExibirNovoContato({Contato? contato}) async {
    final gravaContato = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NovoContato(
                  contato: contato,
                )));
    if (gravaContato != null) {
      if (contato != null) {
        await info.atualizarContato(gravaContato);

        _obterTodosContatos();
      } else {
        await info.salvarContato(gravaContato);
      }
      _obterTodosContatos();
    }
  }

  void _obterTodosContatos() {
    info.obterTodosContatos().then((dynamic list) {
      setState(() {
        contatos = list;
      });
    });
  }

  void _ordenarLista(OrderOption result) {
    switch (result) {
      case OrderOption.orderaz:
        contatos.sort(
            (a, b) => a.nome!.toLowerCase().compareTo(b.nome!.toLowerCase()));
        break;
      case OrderOption.orderza:
        contatos.sort(
            (a, b) => b.nome!.toLowerCase().compareTo(a.nome!.toLowerCase()));
        break;
    }
    setState(() {});
  }
}
