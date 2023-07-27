import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pet_bosque/funcoes/info_pet.dart';
import 'package:pet_bosque/funcoes/info_plano.dart';
import 'package:pet_bosque/paginas/lista_pet_contato.dart';

class EditarPet extends StatefulWidget {
  final Pet _pet;
  EditarPet({
    super.key,
    Pet? pet,
  }) : _pet = pet ?? Pet();

  @override
  _EditarPetState createState() => _EditarPetState();
}

InfoPet info = InfoPet();

InfoPlano infoPlano = InfoPlano();
List<Plano> itens = [];
List<Pet> pet = [];

enum Genero {
  Macho,
  Femea,
}

final String dataContrato = DateFormat("dd/MM/yyyy").format(DateTime.now());

class _EditarPetState extends State<EditarPet> {
  Genero? _genero = Genero.Macho;

  final _formKey = GlobalKey<FormState>();
  final _nomePetController = TextEditingController();
  final _corPetController = TextEditingController();
  final _racaPetController = TextEditingController();
  final _especiePetController = TextEditingController();

  final _nomeFocus = FocusNode();
  DateTime _dateTime = DateTime.now();
  FirebaseFirestore db = FirebaseFirestore.instance;
  late Pet _editarPet;

  bool _petEditado = false;
  bool planoExcluido = false;

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

    if (_editarPet.genero == "Macho") {
      _genero = Genero.Macho;
      _editarPet.genero = "Macho";
    }
    if (_editarPet.genero == "Femea") {
      _genero = Genero.Femea;
      _editarPet.genero = "Femea";
    }

    _nomePetController.text = _editarPet.nomePet ?? '';
    _corPetController.text = _editarPet.cor ?? '';
    _especiePetController.text = _editarPet.especie ?? '';
    _racaPetController.text = _editarPet.raca ?? '';
  }

  void _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
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
            leading: BackButton(onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ListaPetContato(
                        idContato: _editarPet.idContato.toString(),
                        nomeContato: _editarPet.nomeContato.toString(),
                      )));
            }),
            title: Text(
              _editarPet.nomePet ?? "",
              style: TextStyle(
                color: Color.fromARGB(255, 73, 66, 2),
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              if (_editarPet.nomePet != null &&
                  _editarPet.nomePet!.isNotEmpty) {
                await info.atualizarFotoPet(
                    _editarPet.id.toString(), _editarPet.foto.toString());
                // info.atualizarPet(_editarPet);
                db.collection("pet").doc(_editarPet.id).set({
                  "idPet": _editarPet.id,
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

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListaPetContato(
                              idContato: _editarPet.idContato.toString(),
                              nomeContato: _editarPet.nomeContato.toString(),
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
                                        _editarPet.foto = file?.path;
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
                                        _editarPet.foto = file?.path;
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
                      _editarPet.idContato = _editarPet.idContato;
                    });
                  },
                  validator: (valor) {
                    if (valor == null || valor.isEmpty) {
                      return "Nome precisa estar preenchido";
                    }

                    return null;
                  },
                ),
                const SizedBox(
                  //Use of SizedBox
                  height: 20,
                ),
                // ignore: unrelated_type_equality_checks
                if (_editarPet.idPlano == '0')
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
                            setState(() {
                              selectedValue = value as Plano;
                              _editarPet.nomePlano = selectedValue!.nomePlano;
                              _editarPet.planoVencido = "N";
                              _editarPet.idPlano = selectedValue!.id.toString();
                              //_editarPet.contaPlano = 4;
                              _editarPet.dataContrato = dataContrato;
                              _editarPet.valorPlano =
                                  selectedValue!.valor.toString();
                            });
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
                if (_editarPet.idPlano != '0' && planoExcluido == false)
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
                    Text(
                      _editarPet.nomePlano ?? '',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Excluir Plano?"),
                                content: const Text(
                                    "Ao clicar em excluir o Pet perderá todos os agendamentos restantes."),
                                actions: <Widget>[
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(120, 50),
                                      backgroundColor: Colors.redAccent,
                                      side: const BorderSide(
                                          width: 3, color: Colors.redAccent),
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
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _editarPet.idPlano = '0';
                                        planoExcluido = true;
                                        db
                                            .collection('pet')
                                            .doc(_editarPet.id)
                                            .update({
                                          'idPlano': '0',
                                          'nomePlano': 'N',
                                          'planoVencido': 'P',
                                          'contaPlano': 0
                                        });
                                        //_excluirPetPlano(_editarPet.id!);
                                      });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditarPet(
                                                    pet: _editarPet,
                                                  )));
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
                  ]),
                const SizedBox(
                  //Use of SizedBox
                  height: 20,
                ),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: _racaPetController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Raça",
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(10),
                      )),
                  onChanged: (text) {
                    _petEditado = true;
                    _editarPet.raca = text;
                  },
                ),
                const SizedBox(
                  //Use of SizedBox
                  height: 20,
                ),
                if (_editarPet.porte != null)
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
                    Text(
                      _editarPet.porte ?? '',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ]),
                if (_editarPet.porte == null)
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
                  //Use of SizedBox
                  height: 20,
                ),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: _corPetController,
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
                          "Genero",
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
                  controller: _especiePetController,
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
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Color.fromARGB(255, 73, 66, 2),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
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
                        child: Text(_editarPet.dtNasc!,
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
                  "Ao clicar em voltar as alterações serão perdidas."),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text("Sim"),
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  void _excluirPetPlano(int id) {
    info.excluirPetPlano(_editarPet.id!);
  }

  void _obterPlanos() {
    infoPlano.obterTodosPlanosFirestore().then((dynamic listaPlano) {
      setState(() {
        itens = listaPlano;
      });
    });
  }
}
