import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:pet_bosque/funcoes/info_especie.dart';
import 'package:pet_bosque/funcoes/info_raca.dart';
import 'package:pet_bosque/paginas/inicio.dart';
import 'package:pet_bosque/paginas/lista_raca.dart';

class NovaRaca extends StatefulWidget {
  final Raca _raca;
  NovaRaca({
    super.key,
    Raca? raca,
  }) : _raca = raca ?? Raca(nome: null, id: null, especie: null);

  @override
  _NovaRacaState createState() => _NovaRacaState();
}

InfoRaca info = InfoRaca();
InfoEspecie infoEspecie = InfoEspecie();

class _NovaRacaState extends State<NovaRaca> {
  final _nomeController = TextEditingController();

  final _nomeFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  final Raca _novaRaca = Raca(nome: null, id: null, especie: null);
  bool _racaEditado = false;
  late Raca _editarRaca;
  bool loading = false;
  String menssagem = "";
  List<Especie> itens = [];
  Especie? selectedValue;

  @override
  void initState() {
    super.initState();
    _obterEspecie();
    _editarRaca = Raca.fromMap(widget._raca.toMap());
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
            title: const Text("Nova Raça"),
            leading: BackButton(onPressed: () {
              if (_racaEditado != true) {
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
              if (_editarRaca.nome != null && _editarRaca.nome!.isNotEmpty) {
                info.salvarRacaApi(_editarRaca).then((value) {
                  menssagem = value;
                  setState(() {
                    showDialog(
                        context: context,
                        builder: (context) {
                          Future.delayed(const Duration(seconds: 2), () {
                            loading = false;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const ListaRaca()),
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
                Row(children: [
                  const SizedBox(
                    width: 35,
                  ),
                  const Text(
                    "Espécie:",
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
                          selectedValue = value as Especie;
                          _editarRaca.especie = selectedValue!.nome;
                          _editarRaca.idEspecie = selectedValue!.id.toString();
                          print(_editarRaca.idEspecie);
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
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: _nomeController,
                  focusNode: _nomeFocus,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Nome da Raça",
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(0),
                      )),
                  onChanged: (text) {
                    _racaEditado = true;
                    setState(() {
                      _editarRaca.nome = text;
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
    if (_racaEditado) {
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
                        builder: (context) => Inicio(
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

  void _obterEspecie() {
    infoEspecie.obterTodasEspecieApi().then((dynamic listaEspecie) {
      setState(() {
        itens = listaEspecie;
      });
    });
  }
}
