import 'package:flutter/material.dart';
import 'package:pet_bosque/funcoes/info_especie.dart';
import 'package:pet_bosque/paginas/inicio.dart';
import 'package:pet_bosque/paginas/lista_especie.dart';

class NovaEspecie extends StatefulWidget {
  final Especie _especie;
  NovaEspecie({
    super.key,
    Especie? especie,
  }) : _especie = especie ?? Especie(nome: null, id: null);

  @override
  _NovaEspecieState createState() => _NovaEspecieState();
}

InfoEspecie info = InfoEspecie();

class _NovaEspecieState extends State<NovaEspecie> {
  final _nomeController = TextEditingController();

  final _nomeFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  final Especie _novaEspecie = Especie(nome: null, id: null);
  bool _especieEditado = false;
  late Especie _editarEspecie;
  bool loading = false;
  String menssagem = "";
  //FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    _editarEspecie = Especie.fromMap(widget._especie.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _retornaPop(context),
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/imagens/back_app.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text("Nova Espécie"),
            leading: BackButton(onPressed: () {
              if (_especieEditado != true) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Inicio(
                          index: 4,
                        )));
              }
              _retornaPop(context);
            }),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              loading = true;
              if (loading = true) {
                const Center(
                  child: CircularProgressIndicator(
                    color: Colors.greenAccent,
                    backgroundColor: Colors.grey,
                  ),
                );
              }
              if (_editarEspecie.nome != null &&
                  _editarEspecie.nome!.isNotEmpty) {
                info.salvarEspecieApi(_editarEspecie).then((value) {
                  menssagem = value;
                  setState(() {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          Future.delayed(const Duration(seconds: 2), () {
                            loading = false;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const ListaEspecie()),
                            );
                          });
                          return AlertDialog(
                            content: Text(
                              menssagem,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 73, 66, 2),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            icon: const Icon(
                              Icons.check,
                              weight: 30,
                              color: Colors.green,
                            ),
                          );
                        });
                  });
                });
              } else {
                FocusScope.of(context).requestFocus(_nomeFocus);
              }
            },
            icon: const Icon(Icons.save),
            backgroundColor: const Color.fromRGBO(249, 94, 0, 1),
            hoverColor: const Color.fromRGBO(249, 94, 0, 100),
            foregroundColor: Colors.white,
            label: const Text("Salvar"),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(children: <Widget>[
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: _nomeController,
                  focusNode: _nomeFocus,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Nome da Espécie",
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(0),
                      )),
                  onChanged: (text) {
                    _especieEditado = true;
                    setState(() {
                      _editarEspecie.nome = text;
                    });
                  },
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _retornaPop(BuildContext context) {
    if (_especieEditado) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Descartar Alterações?"),
              content: const Text(
                  "Ao clicar em continuar as alterações serão perdidas."),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(120, 50),
                    backgroundColor: Colors.redAccent,
                    side: const BorderSide(width: 3, color: Colors.redAccent),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Voltar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(120, 50),
                    backgroundColor: Colors.blueAccent,
                    side: const BorderSide(width: 3, color: Colors.blueAccent),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Inicio(
                              index: 4,
                            )));
                  },
                  child: const Text(
                    "Continuar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
