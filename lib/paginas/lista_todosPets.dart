import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:pet_bosque/funcoes/info_pet.dart';
import 'package:pet_bosque/funcoes/pesquisa_todosPet.dart';
import 'package:pet_bosque/paginas/lista_hospedagemPet.dart';

import 'editar_pet.dart';

enum OrderOption { orderaz, orderza }

enum Options { Add, Edit, Delete, Thankyou }

class ListaTodosPets extends StatefulWidget {
  const ListaTodosPets({Key? key}) : super(key: key);

  @override
  State<ListaTodosPets> createState() => _ListaTodosPetsState();
}

class _ListaTodosPetsState extends State<ListaTodosPets> {
  String selected = "Home Page";
  var appBarHeight = AppBar().preferredSize.height;
  InfoPet info = InfoPet();
  List<Pet> pet = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();

    _obterTodosPet();
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
              "Pets cadastrados",
              style: TextStyle(
                color: Color.fromARGB(255, 73, 66, 2),
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: PesquisaTodosPetPage(),
                );
              },
              icon: const Icon(Icons.search),
            ),
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
          body: !loading
              ? ListView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: pet.length,
                  itemBuilder: (context, index) {
                    return _cartaoPet(context, index);
                  })
              : const Center(
                  child: CircularProgressIndicator(
                    color: Colors.greenAccent,
                    backgroundColor: Colors.grey,
                  ),
                ),
        ));
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
                    barrierDismissible: false,
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
                            onPressed: () {
                              //  info.deletarPetFirestore(pet[index].id!);
                              setState(() {
                                pet.removeAt(index);

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
                      pet[index].nomePet ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.list),
                      color: Colors.blue,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ListaHospedagemPet(
                                  idPet: pet[index].id!,
                                  nomePet: pet[index].nomePet.toString(),
                                )));
                      },
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
                      pet[index].nomeContato ?? "",
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
                      DateFormat("dd/MM/yyyy").format(DateTime.parse(
                              pet[index].dataCadastro.toString())) ??
                          "",
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
                      DateFormat("dd/MM/yyyy").format(
                              DateTime.parse(pet[index].dtNasc.toString())) ??
                          "",
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
                        double.parse(pet[index].valorPlano.toString())
                                .toStringAsFixed(2) ??
                            "",
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
                        DateFormat("dd/MM/yyyy").format(DateTime.parse(
                                pet[index].dataContrato.toString())) ??
                            "",
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
      onTap: () {
        menu();
      },
    );
  }

  Padding menu() {
    return Padding(
      padding: EdgeInsets.only(right: 20),
      child: CircleAvatar(
          backgroundColor: Colors.cyanAccent,
          child: PopupMenuButton(
            icon: const Icon(Icons.more_vert_rounded),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            )),
            offset: Offset(0.0, appBarHeight),
            itemBuilder: (ctx) => [
              _buildPopupMenuItem("Add", Icons.add, Options.Add.index),
              _buildPopupMenuItem("Edit", Icons.edit, Options.Edit.index),
              _buildPopupMenuItem(
                  "Delete", Icons.remove_circle, Options.Delete.index),
              _buildPopupMenuItem(
                  "Thankyou", Icons.remove_circle, Options.Thankyou.index),
            ],
            onSelected: (value) {
              _onSelectedItem(value as int);
            },
          )),
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
        _obterTodosPet();
      } else {
        await info.salvarPet(gravaPet);
      }
      _obterTodosPet();
    }
    _obterTodosPet();
  }

  Future _obterTodosPet() async {
    await info.obterTodosPetApi().then((dynamic list) {
      setState(() {
        pet = list;
        loading = false;
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

  PopupMenuItem _buildPopupMenuItem(
      String title, IconData iconData, int position) {
    return PopupMenuItem(
      value: position,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.all(10),
              child: Icon(iconData, color: Colors.black)),
          Text(title),
        ],
      ),
    );
  }

  _onSelectedItem(int value) {
    if (value == Options.Add.index) {
      print("Add Menu Click");
      setState(() {
        selected = "Add Page";
      });
    } else if (value == Options.Edit.index) {
      print("Edit Menu Click");
      setState(() {
        selected = "Edit Page";
      });
    } else if (value == Options.Delete.index) {
      print("Delete Menu Click");
      setState(() {
        selected = "Delete Page";
      });
    } else {
      print("Thank you :)");
      setState(() {
        selected = "Thank you :)";
      });
    }
  }
}
