import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pet_bosque/funcoes/info_agendamento.dart';
import 'package:pet_bosque/funcoes/info_contato.dart';
import 'package:pet_bosque/funcoes/info_pet.dart';
import 'package:pet_bosque/paginas/inicio.dart';
import 'package:pet_bosque/paginas/novo_pet.dart';
import 'package:uuid/uuid.dart';

InfoPet infoPet = InfoPet();
InfoContato info = InfoContato();

class NovoContato extends StatefulWidget {
  final Contato _contato;
  NovoContato({
    super.key,
    Contato? contato,
    Agendamento? Agendamento,
  }) : _contato = contato ??
            Contato(
                bairro: null,
                cidade: null,
                complemento: null,
                email: null,
                id: '',
                endereco: null,
                nome: null,
                telefone: null);

  @override
  _NovoContatoState createState() => _NovoContatoState();
}

FirebaseFirestore db = FirebaseFirestore.instance;

class _NovoContatoState extends State<NovoContato> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _idContatoController = TextEditingController();
  final _complementoController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();

  final _nomeFocus = FocusNode();
  String menssagem = "";
  late Contato _editarContato;
  bool salvo = false;
  bool _contatoEditado = false;
  bool _novoContato = true;
  var mascaraFone = MaskTextInputFormatter(mask: '(##) # ####-####');
  @override
  void initState() {
    super.initState();

    _editarContato = Contato.fromMap(widget._contato.toMap());
    if (_editarContato.id != "") {
      _novoContato = false;
    }

    _nomeController.text = _editarContato.nome ??= "";
    _emailController.text = _editarContato.email ??= "";
    _telefoneController.text = _editarContato.telefone ??= "";
    _enderecoController.text = _editarContato.endereco ??= "";
    _idContatoController.text = _editarContato.id.toString();
    _complementoController.text = _editarContato.complemento ??= "";
    _bairroController.text = _editarContato.bairro ??= "";
    _cidadeController.text = _editarContato.cidade ??= "";
  }

  @override
  Widget build(BuildContext context) {
    var imagemPet = _editarContato.idPet;
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
            leading: BackButton(onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Inicio(
                        index: 1,
                      )));
            }),
            title: Text(_editarContato.nome ?? "Novo Contato"),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              if (_editarContato.nome != null &&
                  _editarContato.nome!.isNotEmpty) {
                //await infoPet.atualizarNomeContato(_editarContato.id.toString(),
                //  _editarContato.nome.toString());

                if (_novoContato == true) {
                  /*  String id = Uuid().v1();
                  _editarContato.id = id;
                  db.collection("contato").doc(id).set({
                    "idContato": id,
                    "nome": _editarContato.nome,
                    "telefone": _editarContato.telefone,
                    "email": _editarContato.email,
                    "endereco": _editarContato.endereco,
                    "complemento": _editarContato.complemento,
                    "bairro": _editarContato.bairro,
                    "cidade": _editarContato.cidade,
                    "uf": _editarContato.uf
                  });*/
                  _editarContato.idContato = const Uuid().v1();
                  await info.salvarClienteApi(_editarContato).then((value) {
                    menssagem = value;
                  });
                  // ignore: use_build_context_synchronously
                  setState(() {
                    showDialog(
                        context: context,
                        builder: (context) {
                          Future.delayed(const Duration(seconds: 3), () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const Inicio(
                                        index: 1,
                                      )),
                            );
                            salvo = true;
                            if (salvo == true) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Cadastrar Pet?"),
                                      content: const Text(
                                          "Ja é possivel cadastrar um Pet para esse contato."),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: const Size(120, 50),
                                            backgroundColor: Colors.redAccent,
                                            side: const BorderSide(
                                                width: 3,
                                                color: Colors.redAccent),
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            "Não",
                                            style:
                                                TextStyle(color: Colors.white),
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
                                                width: 3,
                                                color: Colors.blueAccent),
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            NovoPet(
                                                              idContato:
                                                                  _editarContato
                                                                      .idContato
                                                                      .toString(),
                                                              nomeContato:
                                                                  _editarContato
                                                                      .nome
                                                                      .toString(),
                                                            )));
                                          },
                                          child: const Text(
                                            "Sim",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            }
                          });

                          return AlertDialog(
                            content: Text(
                              menssagem,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          );
                        });
                  });
                }

                if (_novoContato == false) {
                  /* db.collection("contato").doc(_editarContato.id).set({
                    "idContato": _editarContato.id,
                    "nome": _editarContato.nome,
                    "telefone": _editarContato.telefone,
                    "email": _editarContato.email,
                    "endereco": _editarContato.endereco,
                    "complemento": _editarContato.complemento,
                    "bairro": _editarContato.bairro,
                    "cidade": _editarContato.cidade,
                    "uf": _editarContato.uf
                  });*/

                  await info.atualizarClienteApi(_editarContato).then((value) {
                    menssagem = value;
                  });
                  // ignore: use_build_context_synchronously
                  setState(() {
                    showDialog(
                        context: context,
                        builder: (context) {
                          Future.delayed(const Duration(seconds: 3), () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const Inicio(
                                        index: 1,
                                      )),
                            );
                          });

                          return AlertDialog(
                            content: Text(
                              menssagem,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          );
                        });
                  });
                }
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
                GestureDetector(
                  child: Container(
                    width: 140.0,
                    height: 140.0,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,

                      // border: Border.all(
                      //   width: 2,
                      //   color: Colors.red,
                      // ),
                    ),
                    child: Image.file(File("$imagemPet"),
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset("assets/imagens/contato.png"),
                        fit: BoxFit.cover),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              title: const Text("Atualizar imagem"),
                              content: const Text("Selecione a opção."),
                              actions: <Widget>[
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(300, 50),
                                    backgroundColor: Colors.redAccent,
                                    side: const BorderSide(
                                        width: 3, color: Colors.redAccent),
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  onPressed: () {
                                    ImagePicker.platform
                                        .pickImage(source: ImageSource.gallery)
                                        .then((file) {
                                      if (File == null) return;
                                      setState(() {
                                        _editarContato.idPet = file?.path;
                                      });
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Galeria",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  //Use of SizedBox
                                  height: 20,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(300, 50),
                                    backgroundColor: Colors.blueAccent,
                                    side: const BorderSide(
                                        width: 3, color: Colors.blueAccent),
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  onPressed: () {
                                    ImagePicker.platform
                                        .pickImage(source: ImageSource.camera)
                                        .then((file) {
                                      if (File == null) return;
                                      setState(() {
                                        _editarContato.idPet = file?.path;
                                      });
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Camera",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                      )),
                                ),
                              ]);
                        });
                  },
                ),
                const SizedBox(
                  //Use of SizedBox
                  height: 20,
                ),
                TextFormField(
                  controller: _nomeController,
                  focusNode: _nomeFocus,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(gapPadding: 2.0),
                      labelText: "Nome",
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(10),
                      )),
                  onChanged: (text) {
                    _contatoEditado = true;
                    setState(() {
                      _editarContato.nome = text;
                    });
                  },
                  validator: (valor) {
                    if (valor == null || valor.isEmpty) {
                      return "Valor precisa estar preenchido";
                    }

                    return null;
                  },
                ),
                const SizedBox(
                  //Use of SizedBox
                  height: 20,
                ),
                TextFormField(
                  inputFormatters: [mascaraFone],
                  controller: _telefoneController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Telefone",
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(10),
                      )),
                  onChanged: (text) {
                    _contatoEditado = true;
                    _editarContato.telefone = text;
                  },
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(
                  //Use of SizedBox
                  height: 20,
                ),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: _enderecoController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Endereço",
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(10),
                      )),
                  onChanged: (text) {
                    _contatoEditado = true;
                    _editarContato.endereco = text;
                  },
                ),
                const SizedBox(
                  //Use of SizedBox
                  height: 20,
                ),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: _complementoController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Complemento",
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(10),
                      )),
                  onChanged: (text) {
                    _contatoEditado = true;
                    _editarContato.complemento = text;
                  },
                ),
                const SizedBox(
                  //Use of SizedBox
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: _bairroController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Bairro",
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(10),
                          )),
                      onChanged: (text) {
                        _contatoEditado = true;
                        _editarContato.bairro = text;
                      },
                    )),
                    const SizedBox(
                      width: 20,
                      height: 10,
                    ),
                    const SizedBox(
                      //Use of SizedBox
                      height: 20,
                    ),
                    Expanded(
                        child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: _cidadeController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Cidade",
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(10),
                          )),
                      onChanged: (text) {
                        _contatoEditado = true;
                        _editarContato.cidade = text;
                      },
                    )),
                  ],
                ),
                const SizedBox(
                  //Use of SizedBox
                  height: 20,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email",
                      hintText: "email@email.com",
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(10),
                      )),
                  onChanged: (text) {
                    _contatoEditado = true;
                    _editarContato.email = text;
                  },
                  keyboardType: TextInputType.emailAddress,
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
    if (_contatoEditado) {
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
                    Navigator.pop(context);
                    Navigator.pop(context);
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
