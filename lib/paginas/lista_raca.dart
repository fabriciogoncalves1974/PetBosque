import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pet_bosque/funcoes/info_especie.dart';
import 'package:pet_bosque/funcoes/info_raca.dart';
import 'package:pet_bosque/paginas/inicio.dart';
import 'package:pet_bosque/paginas/nova_raca.dart';

enum OrderOption { orderaz, orderza }

class ListaRaca extends StatefulWidget {
  const ListaRaca({Key? key}) : super(key: key);

  @override
  State<ListaRaca> createState() => _ListaRacaState();
}

//FirebaseFirestore db = FirebaseFirestore.instance;

class _ListaRacaState extends State<ListaRaca> {
  InfoRaca info = InfoRaca();
  InfoEspecie infoEspecie = InfoEspecie();
  bool loading = true;
  List<Raca> raca = [];
  List<Especie> itensEspecie = [];

  Especie? selectedValue;
  paginaInicial() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => const Inicio(
                index: 2,
              )),
    );
  }

  String menssagem = "";
  @override
  void initState() {
    super.initState();
    setState(() {
      _obterTodasRaca();
      _obterEspecie();
    });
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
          title: const Text("Raça"),
          centerTitle: true,
          actions: <Widget>[
            DropdownButtonHideUnderline(
              child: DropdownButton2(
                hint: Text(
                  'Todas Especies',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                items: itensEspecie
                    .map((item) => DropdownMenuItem<Especie>(
                          value: item,
                          child: Text(
                            item.nome.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ))
                    .toList(),
                value: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value;
                    _pesquisaRaca(value!.id);
                  });
                },
                buttonStyleData: const ButtonStyleData(
                  height: 40,
                  width: 140,
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                ),
              ),
            ),
          ],
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              paginaInicial();
            },
            icon: const Icon(Icons.home_outlined),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => NovaRaca()));
          },
          icon: const Icon(Icons.add),
          backgroundColor: const Color.fromRGBO(35, 151, 166, 1),
          hoverColor: const Color.fromRGBO(35, 151, 166, 50),
          foregroundColor: Colors.white,
          label: const Text("Novo"),
        ),
        body: !loading
            ? ListView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: raca.length,
                itemBuilder: (context, index) {
                  return _cartaoPet(context, index);
                })
            : const Center(
                child: CircularProgressIndicator(
                  color: Colors.greenAccent,
                  backgroundColor: Colors.grey,
                ),
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
              color: Colors.redAccent,
              icon: Icons.add,
              caption: 'Excluir',
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                            "Deseja realmente excluir a raça  ${raca[index].nome}!"),
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
                              excluirEspecie(raca[index].id!);
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
                      "Raça: ",
                      style: TextStyle(
                        color: Color.fromARGB(255, 73, 66, 2),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      raca[index].nome ?? "",
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
                      "Espécie: ",
                      style: TextStyle(
                        color: Color.fromARGB(255, 73, 66, 2),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      raca[index].especie ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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

  void excluirEspecie(id) {
    info.excluirRacaApi(id).then((value) {
      menssagem = value;

      setState(() {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(
                  menssagem,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              );
            });
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const Inicio(
                    index: 4,
                  )));
        });
      });
    });
  }

  void _ExibirNovaRaca({Raca? raca}) async {
    final gravaRaca = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => NovaRaca()));
    if (gravaRaca != null) {
      if (raca != null) {
        await info.atualizarRacaApi(gravaRaca);

        _obterTodasRaca();
      } else {
        await info.salvarRacaApi(gravaRaca);
      }
      _obterTodasRaca();
    }
  }

  Future _obterTodasRaca() async {
    await info.obterTodasRacaApi().then((dynamic list) {
      setState(() {
        raca = list;
        loading = false;
      });
    });
  }

  Future _pesquisaRaca(id) async {
    await info.pesquisarRacaApi(id).then((dynamic listaRaca) {
      setState(() {
        raca = listaRaca;
        loading = false;
      });
    });
  }

  Future _obterEspecie() async {
    await infoEspecie.obterTodasEspecieApi().then((dynamic listaEspecie) {
      setState(() {
        itensEspecie = listaEspecie;
      });
    });
  }
}
