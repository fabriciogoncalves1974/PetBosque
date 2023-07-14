import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pet_bosque/funcoes/info_pet.dart';
import 'package:pet_bosque/funcoes/info_plano.dart';
import 'package:pet_bosque/paginas/lista_pet_contato.dart';
import 'package:uuid/uuid.dart';

class NovoPet extends StatefulWidget {
  final Pet _pet;
  NovoPet(
      {super.key, Pet? pet, required this.idContato, required this.nomeContato})
      : _pet = pet ?? Pet();

  final String idContato;
  final String nomeContato;

  @override
  _NovoPetState createState() => _NovoPetState();
}

InfoPet info = InfoPet();
InfoPlano infoPlano = InfoPlano();
List<Pet> pet = [];
List<Plano> itens = [];

enum Genero {
  Macho,
  Femea,
}

final String dataContrato = DateFormat("dd/MM/yyyy").format(DateTime.now());

class _NovoPetState extends State<NovoPet> {
  Genero? _genero = Genero.Macho;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _nomePetController = TextEditingController();

  final _nomeFocus = FocusNode();

  late Pet _editarPet;

  bool _petEditado = false;

  get formatado => null;

  Plano? selectedValue;

  String? porteSelecionado;

  var itemsPorte = [
    'Pequeno',
    'Medio',
    'Grande',
  ];

  @override
  void initState() {
    super.initState();
    _obterPlanos();
    _editarPet = Pet.fromMap(widget._pet.toMap());
    _editarPet.idContato = widget.idContato;
    _editarPet.genero = "Macho";
    _nomePetController.text = _editarPet.nomePet ?? '';
  }

  DateTime _dateTime = DateTime.now();

  void _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    ).then((value) {
      setState(() {
        _editarPet.dtNasc = DateFormat("dd/MM/yyyy").format(value!);
        _dateTime = value;
        _petEditado = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var imagemPet = _editarPet.foto;
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
            title: Text(_editarPet.nomePet ?? "Novo Pet"),
            leading: BackButton(onPressed: () {
              if (_petEditado != true) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ListaPetContato(
                          idContato: widget.idContato.toString(),
                          nomeContato: widget.nomeContato.toString(),
                        )));
              }
              _retornaPop(context);
            }),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              if (_editarPet.nomePet != null &&
                  _editarPet.nomePet!.isNotEmpty) {
                _editarPet.dtNasc = DateFormat("dd/MM/yyyy").format(_dateTime);
                // info.salvarPet(_editarPet);
                String id = Uuid().v1();
                db.collection("pet").doc(id).set({
                  "idPet": id,
                  "idContato": _editarPet.idContato,
                  "nomePet": _editarPet.nomePet,
                  "raca": _editarPet.raca,
                  "peso": _editarPet.peso,
                  "genero": _editarPet.genero,
                  "dtNasc": _editarPet.dtNasc,
                  "especie": _editarPet.especie,
                  "cor": _editarPet.cor,
                  "foto": _editarPet.foto,
                  "nomeContato": _editarPet.nomeContato,
                  "contaPlano": _editarPet.contaPlano,
                  "nomePlano": _editarPet.nomePlano,
                  "idPlano": _editarPet.idPlano,
                  "valorPlano": _editarPet.valorPlano,
                  "porte": _editarPet.porte,
                  "dataContrato": _editarPet.dataContrato,
                  "planoVencido": _editarPet.planoVencido,
                });
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ListaPetContato(
                          idContato: widget.idContato.toString(),
                          nomeContato: widget.nomeContato.toString(),
                        )));
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
                            Image.asset("assets/imagens/pet.png"),
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
                                TextButton(
                                  onPressed: () {
                                    ImagePicker.platform
                                        .pickImage(source: ImageSource.gallery)
                                        .then((file) {
                                      if (File == null) return;
                                      setState(() {
                                        _editarPet.foto = file?.path;
                                      });
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Galeria"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    ImagePicker.platform
                                        .pickImage(source: ImageSource.camera)
                                        .then((file) {
                                      if (File == null) return;
                                      setState(() {
                                        _editarPet.foto = file?.path;
                                      });
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Camera"),
                                ),
                              ]);
                        });
                  },
                ),
                TextFormField(
                  controller: _nomePetController,
                  focusNode: _nomeFocus,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Nome do Pet",
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(0),
                      )),
                  onChanged: (text) {
                    _petEditado = true;
                    setState(() {
                      _editarPet.nomePet = text;
                      _editarPet.idContato = widget.idContato;
                      _editarPet.nomeContato = widget.nomeContato;
                      _editarPet.nomePlano = "N";
                      _editarPet.planoVencido = "P";
                      _editarPet.idPlano = "0";
                      _editarPet.contaPlano = 0;
                    });
                  },
                  validator: (valor) {
                    if (valor == null || valor.isEmpty) {
                      return "Nome precisa estar preenchido";
                    }

                    return null;
                  },
                ),
                Row(children: [
                  const SizedBox(
                    width: 35,
                  ),
                  const Text(
                    "Plano:",
                    style: TextStyle(
                      color: Color.fromARGB(255, 73, 66, 2),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      hint: Text(
                        '   Selecione',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      items: itens
                          .map((item) => DropdownMenuItem<Plano>(
                                value: item,
                                child: Text(
                                  item.nomePlano.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      value: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value as Plano;
                          _editarPet.nomePlano = selectedValue!.nomePlano;
                          _editarPet.planoVencido = "N";
                          _editarPet.idPlano = selectedValue!.id.toString();
                          _editarPet.contaPlano = 4;
                          _editarPet.dataContrato = dataContrato;
                          _editarPet.valorPlano =
                              selectedValue!.valor.toString();
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
                ]),
                const SizedBox(
                  //Use of SizedBox
                  height: 20,
                ),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      //Fundo do textfield branco
                      //filled: true,
                      //fillColor: Colors.white,
                      labelText: "Raça",
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(10),
                      )),
                  onChanged: (text) {
                    _petEditado = true;
                    _editarPet.raca = text;
                  },
                ),
                Row(children: [
                  const SizedBox(
                    width: 35,
                  ),
                  const Text(
                    "Porte:",
                    style: TextStyle(
                      color: Color.fromARGB(255, 73, 66, 2),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      value: porteSelecionado,
                      hint: Text(
                        'Selecione',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      items: itemsPorte.map((String items) {
                        return DropdownMenuItem(
                            value: items,
                            child: Text(
                              items,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ));
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          porteSelecionado = newValue!;
                          _editarPet.porte = porteSelecionado;
                        });
                      },
                    ),
                  )
                ]),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Cor",
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(10),
                      )),
                  onChanged: (text) {
                    _petEditado = true;
                    _editarPet.cor = text;
                  },
                ),
                const SizedBox(
                  //Use of SizedBox
                  height: 20,
                ),
                const Padding(
                    padding: EdgeInsets.only(left: 45.0),
                    child: Row(
                      children: [
                        Text(
                          "Genero: ",
                          style: TextStyle(
                            color: Color.fromARGB(255, 73, 66, 2),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )),
                ListTile(
                  title: const Text("Macho"),
                  leading: Radio<Genero>(
                    value: Genero.Macho,
                    groupValue: _genero,
                    onChanged: (value) {
                      setState(() {
                        _genero = value;
                        _petEditado = true;
                        _editarPet.genero = "Macho";
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text("Femea"),
                  leading: Radio<Genero>(
                    value: Genero.Femea,
                    groupValue: _genero,
                    onChanged: (value) {
                      setState(() {
                        _genero = value;
                        _petEditado = true;
                        _editarPet.genero = "Femea";
                      });
                    },
                  ),
                ),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Especie",
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(0),
                      )),
                  onChanged: (text) {
                    _petEditado = true;
                    _editarPet.especie = text;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),

                          //color: const Color.fromARGB(255, 123, 132, 123)
                        ),
                        child: const Text(
                          "Data de Nascimento",
                          style: TextStyle(
                            color: Color.fromARGB(255, 73, 66, 2),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50.0),
                  child: Row(
                    children: [
                      MaterialButton(
                        onPressed: () => _showDatePicker(context),
                        //color: Colors.blue,
                        child: Text(DateFormat("dd/MM/yyyy").format(_dateTime),
                            style: const TextStyle(
                              color: Color.fromARGB(182, 66, 61, 61),
                              fontSize: 25,
                            )),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _retornaPop(BuildContext context) {
    if (_petEditado) {
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
                        builder: (context) => ListaPetContato(
                              idContato: widget.idContato.toString(),
                              nomeContato: widget.nomeContato.toString(),
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

  void _obterPlanos() {
    infoPlano.obterTodosPlanosFirestore().then((dynamic listaPlano) {
      setState(() {
        itens = listaPlano;
      });
    });
  }
}
