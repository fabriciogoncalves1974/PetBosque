import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_bosque/funcoes/info_coloborador.dart';
import 'package:pet_bosque/paginas/lista_colaborador.dart';

class EditarColaborador extends StatefulWidget {
  final Colaborador _colaborador;
  EditarColaborador({
    super.key,
    Colaborador? colaborador,
  }) : _colaborador = colaborador ?? Colaborador();

  @override
  _EditarColaboradorState createState() => _EditarColaboradorState();
}

InfoColaborador info = InfoColaborador();
FirebaseFirestore db = FirebaseFirestore.instance;

class _EditarColaboradorState extends State<EditarColaborador> {
  final _nomeColaboradorFocus = FocusNode();
  TextEditingController nomeColaboradorController = TextEditingController();
  TextEditingController porcenComissaoController = TextEditingController();
  TextEditingController metaComissaoController = TextEditingController();
  TextEditingController funcaoColaboradorController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final Colaborador _novoColaborador = Colaborador();
  bool _colaboradorEditado = false;
  late Colaborador _editarColaborador;

  @override
  void initState() {
    super.initState();
    _editarColaborador = Colaborador.fromMap(widget._colaborador.toMap());

    nomeColaboradorController.text = _editarColaborador.nomeColaborador ?? "";
    funcaoColaboradorController.text = _editarColaborador.funcao ?? "";
    porcenComissaoController.text =
        _editarColaborador.porcenComissao.toString() ?? "";
    metaComissaoController.text =
        _editarColaborador.metaComissao.toString() ?? "";
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
            title: Text(
              _editarColaborador.nomeColaborador ?? "",
              style: TextStyle(
                color: Color.fromARGB(255, 73, 66, 2),
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: BackButton(onPressed: () {
              if (_colaboradorEditado != true) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ListaColaborador()));
              }
              _retornaPop(context);
            }),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              _editarColaborador.status ??= "Ativo";
              _editarColaborador.porcenComissao ??= 0;
              _editarColaborador.metaComissao ??= 0;
              if (_editarColaborador.nomeColaborador != null &&
                  _editarColaborador.nomeColaborador!.isNotEmpty) {
                //info.atualizarColaborador(_editarColaborador);
                db.collection("colaborador").doc(_editarColaborador.id).set({
                  "idColaborador": _editarColaborador.id,
                  "nomeColaborador": _editarColaborador.nomeColaborador,
                  "funcao": _editarColaborador.funcao,
                  "porcenComissao": _editarColaborador.porcenComissao,
                  "metaComissao": _editarColaborador.metaComissao,
                  "status": _editarColaborador.status
                });
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ListaColaborador()));
              } else {
                FocusScope.of(context).requestFocus(_nomeColaboradorFocus);
              }
            },
            child: const Icon(Icons.save),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(children: <Widget>[
                TextFormField(
                  controller: nomeColaboradorController,
                  focusNode: _nomeColaboradorFocus,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Nome do Colaborador",
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(0),
                      )),
                  onChanged: (text) {
                    _colaboradorEditado = true;
                    setState(() {
                      _editarColaborador.nomeColaborador = text;
                    });
                  },
                ),
                const SizedBox(
                  //Use of SizedBox
                  height: 20,
                ),
                TextFormField(
                  controller: funcaoColaboradorController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Função",
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(10),
                      )),
                  onChanged: (text) {
                    setState(() {
                      _editarColaborador.funcao = text;
                    });
                  },
                ),
                const SizedBox(
                  //Use of SizedBox
                  height: 20,
                ),
                TextFormField(
                  keyboardType: const TextInputType.numberWithOptions(),
                  controller: porcenComissaoController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "% Comissão",
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(10),
                      )),
                  onChanged: (text) {
                    setState(() {
                      _editarColaborador.porcenComissao =
                          double.tryParse(porcenComissaoController.text) ?? 0;
                    });
                  },
                ),
                const SizedBox(
                  //Use of SizedBox
                  height: 20,
                ),
                TextFormField(
                  keyboardType: const TextInputType.numberWithOptions(),
                  controller: metaComissaoController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Valor Meta",
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(10),
                      )),
                  onChanged: (text) {
                    setState(() {
                      _editarColaborador.metaComissao =
                          double.tryParse(metaComissaoController.text) ?? 0;
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
    if (_colaboradorEditado) {
      showDialog(
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
                        builder: (context) => ListaColaborador()));
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
