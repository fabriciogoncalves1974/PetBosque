import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pet_bosque/funcoes/info_plano.dart';
import 'package:pet_bosque/paginas/inicio.dart';
import 'package:pet_bosque/paginas/novo_plano.dart';

enum OrderOption { orderaz, orderza }

class ListaPlanos extends StatefulWidget {
  const ListaPlanos({Key? key}) : super(key: key);

  @override
  State<ListaPlanos> createState() => _ListaPlanosState();
}

FirebaseFirestore db = FirebaseFirestore.instance;

class _ListaPlanosState extends State<ListaPlanos> {
  InfoPlano info = InfoPlano();
  bool loading = true;
  List<Plano> plano = [];

  paginaInicial() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => const Inicio(
                index: 2,
              )),
    );
  }

  @override
  void initState() {
    super.initState();
    db.collection('planos').snapshots().listen(
      (event) {
        setState(() {
          _obterTodosPlanos();
          loading = false;
        });
      },
    );
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
          title: const Text("Planos"),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => NovoPlano()));
          },
          icon: const Icon(Icons.add),
          backgroundColor: Color.fromRGBO(35, 151, 166, 1),
          hoverColor: Color.fromRGBO(35, 151, 166, 50),
          foregroundColor: Colors.white,
          label: Text("Novo"),
        ),
        body: !loading
            ? ListView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: plano.length,
                itemBuilder: (context, index) {
                  return _cartaoPet(context, index);
                })
            : Center(
                child: CircularProgressIndicator(),
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
              color: Colors.red,
              icon: Icons.add,
              caption: 'Excluir',
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Deseja realmente excluir o plano  " +
                            plano[index].nomePlano.toString() +
                            "!"),
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
                              info.deletarPlanoFirestore(plano[index].id!);
                              setState(() {
                                plano.removeAt(index);
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
                      "Plano: ",
                      style: TextStyle(
                        color: Color.fromARGB(255, 73, 66, 2),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      plano[index].nomePlano ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Row(children: [
                  Text(
                    "Serviços: ",
                    style: TextStyle(
                      color: Color.fromARGB(255, 73, 66, 2),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ]),
                Row(children: [
                  if (plano[index].svBanho == "S")
                    const Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                  if (plano[index].svBanho == "S")
                    const Text(
                      "Banho",
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  if (plano[index].svTosa == "S")
                    const Icon(color: Colors.green, Icons.check),
                  if (plano[index].svTosa == "S")
                    const Text(
                      "Tosa",
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  if (plano[index].svTosaHigienica == "S")
                    const Icon(color: Colors.green, Icons.check),
                  if (plano[index].svTosaHigienica == "S")
                    const Text(
                      "Tosa Hig",
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  if (plano[index].svHidratacao == "S")
                    const Icon(color: Colors.green, Icons.check),
                  if (plano[index].svHidratacao == "S")
                    const Text(
                      "Hidratação",
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                ]),
                Row(children: [
                  if (plano[index].svPintura == "S")
                    const Icon(color: Colors.green, Icons.check),
                  if (plano[index].svPintura == "S")
                    const Text(
                      "Pintura",
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  if (plano[index].svCorteUnha == "S")
                    const Icon(color: Colors.green, Icons.check),
                  if (plano[index].svCorteUnha == "S")
                    const Text(
                      "Corte Unha",
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  if (plano[index].svHospedagem == "S")
                    const Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                  if (plano[index].svHospedagem == "S")
                    const Text(
                      "Hospedagem",
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  if (plano[index].svTransporte == "S")
                    const Icon(color: Colors.green, Icons.check),
                  if (plano[index].svTransporte == "S")
                    const Text(
                      "Transporte",
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                ]),
                Row(
                  children: [
                    const Text(
                      "Valor: ",
                      style: TextStyle(
                        color: Color.fromARGB(255, 73, 66, 2),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      plano[index].valor.toString() ?? "",
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

  void _ExibirNovoPlano({Plano? plano}) async {
    final gravaPlano = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NovoPlano(
                  plano: plano,
                )));
    if (gravaPlano != null) {
      if (plano != null) {
        await info.atualizarPlano(gravaPlano);

        _obterTodosPlanos();
      } else {
        await info.salvarPlano(gravaPlano);
      }
      _obterTodosPlanos();
    }
  }

  void _obterTodosPlanos() {
    info.obterTodosPlanosFirestore().then((dynamic list) {
      setState(() {
        plano = list;
      });
    });
  }
}
