import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_bosque/funcoes/info_plano.dart';
import 'package:pet_bosque/paginas/inicio.dart';
import 'package:pet_bosque/paginas/lista_planos.dart';
import 'package:uuid/uuid.dart';

class NovoPlano extends StatefulWidget {
  final Plano _plano;
  NovoPlano({
    super.key,
    Plano? plano,
  }) : _plano = plano ??
            Plano(
                nomePlano: null,
                svBanho: null,
                svCorteUnha: null,
                svHidratacao: null,
                svHospedagem: null,
                svPintura: null,
                svTosa: null,
                svTosaHigienica: null,
                svTransporte: null,
                valor: null,
                id: null);

  @override
  _NovoPlanoState createState() => _NovoPlanoState();
}

bool svcBanho = false;
bool svcTosa = false;
bool svcTosaHigienica = false;
bool svcCorteUnha = false;
bool svcHidratacao = false;
bool svcPintura = false;
bool svcHospedagem = false;
bool svcTransporte = false;

InfoPlano info = InfoPlano();

class _NovoPlanoState extends State<NovoPlano> {
  final _nomeController = TextEditingController();

  final _nomeFocus = FocusNode();
  TextEditingController svBanhoController = TextEditingController();
  TextEditingController svTosaController = TextEditingController();
  TextEditingController svTosaHigienicaController = TextEditingController();
  TextEditingController svCorteUnhaController = TextEditingController();
  TextEditingController svHidratacaoController = TextEditingController();
  TextEditingController svPinturaController = TextEditingController();
  TextEditingController svrHospedagemController = TextEditingController();
  TextEditingController svTransporteController = TextEditingController();
  TextEditingController valorController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final Plano _novoPlano = Plano(
      nomePlano: null,
      svBanho: null,
      svCorteUnha: null,
      svHidratacao: null,
      svPintura: null,
      svHospedagem: null,
      svTosa: null,
      svTosaHigienica: null,
      svTransporte: null,
      valor: null,
      id: null);
  bool _planoEditado = false;
  late Plano _editarPlano;
  bool loading = false;

  FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    _editarPlano = Plano.fromMap(widget._plano.toMap());
  }

  void _limpaCheck() {
    svcBanho = false;
    svcTosa = false;
    svcTosaHigienica = false;
    svcCorteUnha = false;
    svcHidratacao = false;
    svcPintura = false;
    svcHospedagem = false;
    svcTransporte = false;
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
            title: const Text("Novo Plano"),
            leading: BackButton(onPressed: () {
              if (_planoEditado != true) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ListaPlanos()));
              }
              _retornaPop(context);
            }),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              loading = true;
              if (loading = true) {
                Center(
                  child: CircularProgressIndicator(
                    color: Colors.greenAccent,
                    backgroundColor: Colors.grey,
                  ),
                );
              }
              if (_editarPlano.nomePlano != null &&
                  _editarPlano.nomePlano!.isNotEmpty) {
                // info.salvarPlano(_editarPlano);
                String id = Uuid().v1();
                db.collection("planos").doc(id).set({
                  "idPlano": id,
                  "nomePlano": _editarPlano.nomePlano,
                  "svBanho": _editarPlano.svBanho,
                  "svTosa": _editarPlano.svTosa,
                  "svCorteUnha": _editarPlano.svCorteUnha,
                  "svHidratacao": _editarPlano.svHidratacao,
                  "svTosaHigienica": _editarPlano.svTosaHigienica,
                  "svPintura": _editarPlano.svPintura,
                  "svHospedagem": _editarPlano.svHospedagem,
                  "svTransporte": _editarPlano.svTransporte,
                  "valor": _editarPlano.valor,
                });
                _limpaCheck();
                loading = false;
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const Inicio(
                            index: 4,
                          )),
                );
              } else {
                FocusScope.of(context).requestFocus(_nomeFocus);
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
                  controller: _nomeController,
                  focusNode: _nomeFocus,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Nome do Plano",
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(0),
                      )),
                  onChanged: (text) {
                    _planoEditado = true;
                    setState(() {
                      _editarPlano.nomePlano = text;
                    });
                  },
                ),
                const SizedBox(
                  //Use of SizedBox
                  height: 20,
                ),
                Row(children: [
                  Checkbox(
                      value: svcBanho,
                      onChanged: (checked) {
                        print(checked);
                        setState(() {
                          svcBanho = checked!;
                          _editarPlano.svBanho = "S";
                        });
                      }),
                  const Text(
                    "Banho",
                    textAlign: TextAlign.center,
                    style: TextStyle(height: 2, fontSize: 15),
                  ),
                ]),
                Row(children: [
                  Checkbox(
                      value: svcTosa,
                      onChanged: (checked) {
                        print(checked);
                        setState(() {
                          svcTosa = checked!;
                          _editarPlano.svTosa = "S";
                        });
                      }),
                  const Text(
                    "Tosa",
                    textAlign: TextAlign.center,
                    style: TextStyle(height: 2, fontSize: 15),
                  ),
                ]),
                Row(children: [
                  Checkbox(
                      value: svcTosaHigienica,
                      onChanged: (checked) {
                        print(checked);
                        setState(() {
                          svcTosaHigienica = checked!;
                          _editarPlano.svTosaHigienica = "S";
                        });
                      }),
                  const Text(
                    "Tosa Higiênica",
                    textAlign: TextAlign.center,
                    style: TextStyle(height: 2, fontSize: 15),
                  ),
                ]),
                Row(children: [
                  Checkbox(
                      value: svcCorteUnha,
                      onChanged: (checked) {
                        print(checked);
                        setState(() {
                          svcCorteUnha = checked!;
                          _editarPlano.svCorteUnha = "S";
                        });
                      }),
                  const Text(
                    "Corte Unha",
                    textAlign: TextAlign.center,
                    style: TextStyle(height: 2, fontSize: 15),
                  ),
                ]),
                Row(children: [
                  Checkbox(
                      value: svcHidratacao,
                      onChanged: (checked) {
                        print(checked);
                        setState(() {
                          svcHidratacao = checked!;
                          _editarPlano.svHidratacao = "S";
                        });
                      }),
                  const Text(
                    "Hidratação",
                    textAlign: TextAlign.center,
                    style: TextStyle(height: 2, fontSize: 15),
                  ),
                ]),
                Row(children: [
                  Checkbox(
                      value: svcPintura,
                      onChanged: (checked) {
                        print(checked);
                        setState(() {
                          svcPintura = checked!;
                          _editarPlano.svPintura = "S";
                        });
                      }),
                  const Text(
                    "Pintura",
                    textAlign: TextAlign.center,
                    style: TextStyle(height: 2, fontSize: 15),
                  ),
                ]),
                Row(children: [
                  Checkbox(
                      value: svcHospedagem,
                      onChanged: (checked) {
                        print(checked);
                        setState(() {
                          svcHospedagem = checked!;
                          _editarPlano.svHospedagem = "S";
                        });
                      }),
                  const Text(
                    "Hospedagem",
                    textAlign: TextAlign.center,
                    style: TextStyle(height: 2, fontSize: 15),
                  ),
                ]),
                Row(children: [
                  Checkbox(
                      value: svcTransporte,
                      onChanged: (checked) {
                        print(checked);
                        setState(() {
                          svcTransporte = checked!;
                          _editarPlano.svTransporte = "S";
                        });
                      }),
                  const Text(
                    "Transporte",
                    textAlign: TextAlign.center,
                    style: TextStyle(height: 2, fontSize: 15),
                  ),
                ]),
                const SizedBox(
                  //Use of SizedBox
                  height: 20,
                ),
                TextFormField(
                  keyboardType: const TextInputType.numberWithOptions(),
                  controller: valorController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Valor",
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(10),
                      )),
                  onChanged: (text) {
                    setState(() {
                      _planoEditado = true;
                      _editarPlano.valor =
                          double.tryParse(valorController.text) ?? 0;
                    });
                  },
                ),
                const SizedBox(
                  //Use of SizedBox
                  height: 20,
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _retornaPop(BuildContext context) {
    if (_planoEditado) {
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
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ListaPlanos()));
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
