import 'package:flutter/material.dart';
import 'package:pet_bosque/funcoes/info_coloborador.dart';
import 'package:pet_bosque/paginas/lista_colaborador.dart';

class NovoColaborador extends StatefulWidget {
  final Colaborador _colaborador;
  NovoColaborador({
    super.key,
    Colaborador? colaborador,
  }) : _colaborador = colaborador ?? Colaborador();

  @override
  _NovoColaboradorState createState() => _NovoColaboradorState();
}

//FirebaseFirestore db = FirebaseFirestore.instance;
InfoColaborador info = InfoColaborador();

class _NovoColaboradorState extends State<NovoColaborador> {
  final _nomeColaboradorController = TextEditingController();

  final _nomeColaboradorFocus = FocusNode();
  TextEditingController nomeColaboradorController = TextEditingController();
  TextEditingController porcenComissaoController = TextEditingController();
  TextEditingController porcenParticipanteController = TextEditingController();
  TextEditingController metaComissaoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final Colaborador _novoColaborador = Colaborador();
  bool _colaboradorEditado = false;
  late Colaborador _editarColaborador;
  String menssagem = "";
  @override
  void initState() {
    super.initState();
    _editarColaborador = Colaborador.fromMap(widget._colaborador.toMap());
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
            title: const Text("Novo Colaborador"),
            leading: BackButton(onPressed: () {
              if (_colaboradorEditado != true) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ListaColaborador()));
              }
              _retornaPop(context);
            }),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              _editarColaborador.status ??= "Ativo";
              _editarColaborador.porcenComissao ??= 0;
              _editarColaborador.porcenParticipante ??= 0;
              _editarColaborador.funcao ??= "Colaborador";
              _editarColaborador.metaComissao ??= 0;
              if (_editarColaborador.nomeColaborador != null &&
                  _editarColaborador.nomeColaborador!.isNotEmpty) {
                info.salvarColaboradorApi(_editarColaborador).then((value) {
                  menssagem = value;
                  setState(() {
                    showDialog(
                        context: context,
                        builder: (context) {
                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ListaColaborador()),
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
                ;

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ListaColaborador()));
              } else {
                FocusScope.of(context).requestFocus(_nomeColaboradorFocus);
              }
            },
            icon: const Icon(Icons.save),
            backgroundColor: Color.fromRGBO(35, 151, 166, 1),
            hoverColor: Color.fromRGBO(35, 151, 166, 50),
            foregroundColor: Colors.white,
            label: Text("Salvar"),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(children: <Widget>[
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: _nomeColaboradorController,
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
                  textCapitalization: TextCapitalization.words,
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
                  controller: porcenParticipanteController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "% Participante",
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(10),
                      )),
                  onChanged: (text) {
                    setState(() {
                      _editarColaborador.porcenParticipante =
                          double.tryParse(porcenParticipanteController.text) ??
                              0;
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
