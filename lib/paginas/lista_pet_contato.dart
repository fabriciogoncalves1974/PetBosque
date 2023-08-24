import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:pet_bosque/funcoes/info_pet.dart';
import 'package:pet_bosque/paginas/inicio.dart';
import 'package:pet_bosque/paginas/novo_pet.dart';

import 'editar_pet.dart';

enum OrderOption { orderaz, orderza }

class ListaPetContato extends StatefulWidget {
  const ListaPetContato({
    Key? key,
    required this.nomeContato,
    required this.idContato,
  }) : super(key: key);

  final String idContato;
  final String nomeContato;

  @override
  State<ListaPetContato> createState() => _ListaPetContatoState();
}

class _ListaPetContatoState extends State<ListaPetContato> {
  InfoPet info = InfoPet();
  List<Pet> pet = [];

  @override
  void initState() {
    super.initState();

    _obterTodosPetContato();
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
              widget.nomeContato ?? "Meu Pet",
              style: TextStyle(
                color: Color.fromARGB(255, 73, 66, 2),
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: BackButton(onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Inicio(
                        index: 1,
                      )));
            }),
            centerTitle: true,
            actions: <Widget>[
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
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => NovoPet(
                      idContato: widget.idContato.toString(),
                      nomeContato: widget.nomeContato.toString()
                      // idContato: widget.idContato,
                      //nomeContato: widget.nomeContato,
                      )));
            },
            icon: const Icon(Icons.add),
            backgroundColor: Color.fromRGBO(35, 151, 166, 1),
            hoverColor: const Color.fromRGBO(35, 151, 166, 50),
            foregroundColor: Colors.white,
            label: const Text("Novo"),
          ),
          body: ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: pet.length,
              itemBuilder: (context, index) {
                return _cartaoPet(context, index);
              }),
        ));
  }

  Widget _cartaoPet(BuildContext context, int index) {
    DateTime dataNasc = DateTime.parse(pet[index].dtNasc.toString());
    DateTime dataCad = DateTime.parse(pet[index].dataCadastro.toString());

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
                _EditarPet(pet: pet[index]);
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
                            "Deseja realmente excluir o Pet  ${pet[index].nomePet}?"),
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
                            onPressed: () async {
                              await info.excluirPetApi(pet[index].id!);
                              //infoPet.deletarPetContatoFirestore(
                              //  contatos[index].id!);

                              // ignore: use_build_context_synchronously

                              setState(() {
                                Navigator.pop(context);
                                pet.removeAt(index);
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
                      "Data do Cadastro: ",
                      style: TextStyle(
                        color: Color.fromARGB(255, 73, 66, 2),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      DateFormat("dd/MM/yyyy").format(dataCad) ?? "",
                      style: const TextStyle(
                        fontSize: 12,
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
                      DateFormat("dd/MM/yyyy").format(dataNasc) ?? "",
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
                      pet[index].genero ?? "",
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
                      pet[index].porte ?? "",
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "Raça: ",
                      style: TextStyle(
                        color: Color.fromARGB(255, 73, 66, 2),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      pet[index].raca ?? "",
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
                      pet[index].cor ?? "",
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
                      pet[index].especie ?? "",
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                if (pet[index].idPlano != "0")
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
                        pet[index].nomePlano ?? "",
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
                        pet[index].valorPlano ?? "",
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
                        pet[index].dataContrato ?? "",
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                if (pet[index].idPlano! != "0")
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
                        pet[index].contaPlano.toString() ?? "",
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

  void _EditarPet({Pet? pet}) async {
    final gravaPet = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditarPet(
                  pet: pet,
                )));
    if (gravaPet != null) {
      if (pet != null) {
        await info.atualizarPet(gravaPet);
        _obterTodosPetContato();
      } else {
        await info.salvarPet(gravaPet);
      }
      _obterTodosPetContato();
    }
    _obterTodosPetContato();
  }

  void _obterTodosPetContato() {
    info.obterTodosPetClienteApi(widget.idContato).then((dynamic list) {
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
