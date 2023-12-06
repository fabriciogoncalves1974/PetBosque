import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pet_bosque/funcoes/info_especie.dart';
import 'package:pet_bosque/paginas/inicio.dart';
import 'package:pet_bosque/paginas/nova_especie.dart';

enum OrderOption { orderaz, orderza }

class ListaEspecie extends StatefulWidget {
  const ListaEspecie({Key? key}) : super(key: key);

  @override
  State<ListaEspecie> createState() => _ListaEspecieState();
}

//FirebaseFirestore db = FirebaseFirestore.instance;

class _ListaEspecieState extends State<ListaEspecie> {
  InfoEspecie info = InfoEspecie();
  bool loading = true;
  List<Especie> especie = [];

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
      _obterTodasEspecies();
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
          title: const Text("Espécies"),
          centerTitle: true,
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
                MaterialPageRoute(builder: (context) => NovaEspecie()));
          },
          icon: const Icon(Icons.add),
          backgroundColor: const Color.fromRGBO(249, 94, 0, 1),
          hoverColor: const Color.fromRGBO(249, 94, 0, 100),
          foregroundColor: Colors.white,
          label: const Text("Novo"),
        ),
        body: !loading
            ? ListView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: especie.length,
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
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                            "Deseja realmente excluir a espécie  ${especie[index].nome}!"),
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
                              excluirEspecie(especie[index].id!);
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
                      "Nome: ",
                      style: TextStyle(
                        color: Color.fromARGB(255, 73, 66, 2),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      especie[index].nome ?? "",
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
    info.excluirEspecieApi(id).then((value) {
      menssagem = value;

      setState(() {
        showDialog(
            barrierDismissible: false,
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

  void _ExibirNovaEspecie({Especie? especie}) async {
    final gravaEspecie = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => NovaEspecie()));
    if (gravaEspecie != null) {
      if (especie != null) {
        await info.atualizarEspecieApi(gravaEspecie);

        _obterTodasEspecies();
      } else {
        await info.salvarEspecieApi(gravaEspecie);
      }
      _obterTodasEspecies();
    }
  }

  Future _obterTodasEspecies() async {
    await info.obterTodasEspecieApi().then((dynamic list) {
      setState(() {
        especie = list;
        loading = false;
      });
    });
  }
}
