import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pet_bosque/funcoes/info_pet.dart';
import 'package:pet_bosque/funcoes/pesquisa_petHospedagem.dart';
import 'package:pet_bosque/paginas/detalhe_contato.dart';
import 'package:pet_bosque/paginas/inicio.dart';
import 'package:pet_bosque/paginas/nova_hospedagem.dart';

enum OrderOption { orderaz, orderza }

class ListaPetHospedagem extends StatefulWidget {
  const ListaPetHospedagem({Key? key}) : super(key: key);

  @override
  State<ListaPetHospedagem> createState() => _ListaPetHospedagem();
}

class _ListaPetHospedagem extends State<ListaPetHospedagem> {
  InfoPet info = InfoPet();

  List<Pet> pet = [];
  late String contadorPlano;

  paginaInicial() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => const Inicio(
                index: 0,
              )),
    );
  }

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
          title: const Text("Pets"),
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
                  delegate: PesquisaPetHospedagem(),
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
        body: ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: pet.length,
            itemBuilder: (context, index) {
              return _cartaoPet(context, index);
            }),
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
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NovaHospedagem(
                            fotoPet: pet[index].foto.toString(),
                            nomeContato: pet[index].nomeContato.toString(),
                            nomePet: pet[index].nomePet.toString(),
                            idPet: pet[index].id.toString(),
                            porte: pet[index].porte.toString(),
                            genero: pet[index].genero.toString(),
                          )));
                }),
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
                if (pet[index].nomePlano != 'N')
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
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                DetalheContato(idContato: pet[index].idContato!)));
      },
    );
  }

  void _obterTodosPet() {
    info.obterTodosPetApi().then((dynamic list) {
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
