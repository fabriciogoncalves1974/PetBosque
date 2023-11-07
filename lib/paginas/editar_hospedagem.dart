import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_bosque/funcoes/info_hospedagem.dart';
import 'package:pet_bosque/paginas/lista_hospedagem.dart';

class EditarHospedagem extends StatefulWidget {
  final Hospedagem _hospedagem;

  EditarHospedagem({super.key, Hospedagem? hospedagem})
      : _hospedagem = hospedagem ?? Hospedagem();

  @override
  _EditarHospedagemState createState() => _EditarHospedagemState();
}

List<Hospedagem> hopedagem = [];
DateTime _dateTime = DateTime.now();
DateTime _dataCheckOut = DateTime.now();
TimeOfDay _time = TimeOfDay.now();
TimeOfDay _timeCheckOut = TimeOfDay.now();
TextEditingController valorDiariaController = TextEditingController();
TextEditingController valorTotalController = TextEditingController();
TextEditingController observacaoController = TextEditingController();
TextEditingController adicionalController = TextEditingController();

InfoHospedagem info = InfoHospedagem();

class _EditarHospedagemState extends State<EditarHospedagem> {
  final _formKey = GlobalKey<FormState>();

  late Hospedagem _editarHospedagem;
  late String portePet;

  bool _hospedagemEditada = false;
  int diaria = 0;
  double totalHospedagem = 0;
  //FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    _editarHospedagem = Hospedagem.fromMap(widget._hospedagem.toMap());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _dateTime = (DateFormat('dd/MM/yyyy')
          .parse(_editarHospedagem.dataCheckIn.toString()));
      _dataCheckOut = (DateFormat('dd/MM/yyyy')
          .parse(_editarHospedagem.dataCheckOut.toString()));
      _time = TimeOfDay.fromDateTime(
          DateTime.parse('0000-00-00 ${_editarHospedagem.horaCheckIn}:00Z'));
      _timeCheckOut = TimeOfDay.fromDateTime(
          DateTime.parse('0000-00-00 ${_editarHospedagem.horaCheckOut}:00Z'));
      diaria = _editarHospedagem.dia;
      valorDiariaController.text = _editarHospedagem.valorDia.toString();
      adicionalController.text = _editarHospedagem.adicional.toString();
      observacaoController.text = _editarHospedagem.observacao.toString();
      valorTotalController.text = _editarHospedagem.valorTotal.toString();

      _calculaDiaria();
    });
  }

  paginaHospedagem() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ListaHospedagem()),
    );
  }

  void _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    ).then((value) {
      setState(() {
        _dateTime = value!;
        _totalHospedagem();
        _hospedagemEditada = true;
      });
    });
  }

  void _showDatePicker2(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    ).then((value2) {
      setState(() {
        _dataCheckOut = value2!;
        _calculaDiaria();
        _totalHospedagem();
        _hospedagemEditada = true;
      });
    });
  }

  _limpaCampos() {
    setState(() {
      valorDiariaController.clear();
      valorTotalController.clear();
      observacaoController.clear();
      adicionalController.clear();
      _dateTime = DateTime.now();
      _dataCheckOut = DateTime.now().add(const Duration(days: 1));
      _time = TimeOfDay.now();
      _timeCheckOut = TimeOfDay.now();
      _calculaDiaria();
    });
  }

  _limpaDatas() {
    setState(() {
      _dateTime = DateTime.now();
      _dataCheckOut = DateTime.now().add(const Duration(days: 1));
      _time = TimeOfDay.now();
      _timeCheckOut = TimeOfDay.now();
      _calculaDiaria();
    });
  }

  void _totalHospedagem() {
    double valorDiaria = double.tryParse(valorDiariaController.text) ?? 0;
    double adicional = double.tryParse(adicionalController.text) ?? 0;
    totalHospedagem = (diaria * valorDiaria + adicional);
    valorTotalController.text = totalHospedagem.toString();
    _editarHospedagem.valorTotal = totalHospedagem;
    _editarHospedagem.dia = diaria;
    _editarHospedagem.adicional = adicional;
    _editarHospedagem.valorDia = valorDiaria;
  }

  void _calculaDiaria() {
    if (_dataCheckOut.compareTo(_dateTime) < 0) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Data Invalida!"),
              content: const Text("Check Out menor que Check In."),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(180, 50),
                    backgroundColor: Colors.redAccent,
                    alignment: Alignment.center,
                    side: const BorderSide(width: 3, color: Colors.redAccent),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    _limpaDatas();
                    _calculaDiaria();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Continuar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            );
          });
    }
    if (_dataCheckOut.compareTo(_dateTime) > 0) {
      setState(() {
        diaria =
            DateTimeRange(start: _dateTime, end: _dataCheckOut).duration.inDays;
      });
    }
  }

  late TimeOfDay picked;
  late TimeOfDay picked2;
  late String hora;
  final String _infoValor = "0,00";

  void _executaFuncoes() {}

  Future<void> selectTime(BuildContext context) async {
    picked = (await showTimePicker(
      context: context,
      initialTime: _time,
    ))!;
    setState(() {
      _time = picked;
      _hospedagemEditada = true;
    });
  }

  Future<void> selectTime2(BuildContext context) async {
    picked2 = (await showTimePicker(
      context: context,
      initialTime: _timeCheckOut,
    ))!;
    setState(() {
      _timeCheckOut = picked2;
      _hospedagemEditada = true;
    });
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
              title: const Text("Nova Hospedagem"),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                _editarHospedagem.dataCheckIn = _dateTime;
                _editarHospedagem.horaCheckIn = _time.format(context);
                _editarHospedagem.horaCheckOut = _timeCheckOut.format(context);
                _editarHospedagem.dataCheckOut = _dataCheckOut;

                _editarHospedagem.fotoPet = _editarHospedagem.fotoPet;
                if (_dataCheckOut.compareTo(_dateTime) < 0) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Data Invalida!"),
                          content: const Text("Check In maior que Check Out."),
                          actions: <Widget>[
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(180, 50),
                                backgroundColor: Colors.redAccent,
                                alignment: Alignment.center,
                                side: const BorderSide(
                                    width: 3, color: Colors.redAccent),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {
                                _limpaDatas();
                                _calculaDiaria();
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Continuar",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                          ],
                        );
                      });
                } else {
                  _totalHospedagem();
                  // info.salvarHospedagem(_editarHospedagem);

                  /*  db.collection("hospedagem").doc(_editarHospedagem.id).set({
                    "idHospedagem": _editarHospedagem.id,
                    "idPet": _editarHospedagem.idPet,
                    "nomeContato": _editarHospedagem.nomeContato,
                    "fotoPet": _editarHospedagem.fotoPet,
                    "nomePet": _editarHospedagem.nomePet,
                    "dataCheckIn": _editarHospedagem.dataCheckIn,
                    "horaCheckIn": _editarHospedagem.horaCheckIn,
                    "dataCheckOut": _editarHospedagem.dataCheckOut,
                    "horaCheckOut": _editarHospedagem.horaCheckOut,
                    "dia": _editarHospedagem.dia,
                    "valorDia": _editarHospedagem.valorDia,
                    "adicional": _editarHospedagem.adicional,
                    "valorTotal": totalHospedagem,
                    "observacao": _editarHospedagem.observacao,
                    "status": _editarHospedagem.status,
                    "colaborador": _editarHospedagem.colaborador,
                    "idColaborador": _editarHospedagem.idColaborador,
                    "genero": _editarHospedagem.genero,
                    "porte": _editarHospedagem.porte
                  });*/

                  _limpaCampos();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ListaHospedagem()));
                }
              },
              icon: const Icon(Icons.edit),
              backgroundColor: Color.fromRGBO(35, 151, 166, 1),
              hoverColor: Color.fromRGBO(35, 151, 166, 50),
              foregroundColor: Colors.white,
              label: Text("Alterar"),
            ),
            body: SingleChildScrollView(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Check In :   ",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 73, 66, 2),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      _showDatePicker(context);
                                    },
                                    child: Text(
                                        DateFormat("dd/MM/yyyy")
                                            .format(_dateTime),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color:
                                              Color.fromRGBO(46, 139, 87, 100),
                                          fontSize: 20,
                                        )),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      selectTime(context);
                                    },
                                    child: Text(_time.format(context),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color:
                                              Color.fromRGBO(46, 139, 87, 100),
                                          fontSize: 20,
                                        )),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Check Out :",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 73, 66, 2),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      _showDatePicker2(context);
                                    },
                                    //color: Colors.blue,

                                    child: Text(
                                        DateFormat("dd/MM/yyyy")
                                            .format(_dataCheckOut),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color:
                                              Color.fromRGBO(178, 34, 34, 100),
                                          fontSize: 20,
                                        )),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      selectTime2(context);
                                    },
                                    child: Text(_timeCheckOut.format(context),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color:
                                              Color.fromRGBO(178, 34, 34, 100),
                                          fontSize: 20,
                                        )),
                                  ),
                                ],
                              ),
                              Row(children: [
                                const Text(
                                  "Cliente: ",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 73, 66, 2),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  _editarHospedagem.nomeContato.toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ]),
                              Row(
                                children: [
                                  const Text(
                                    "Pet: ",
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
                                    _editarHospedagem.nomePet.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Porte: ",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 73, 66, 2),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    _editarHospedagem.porte.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Genero: ",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 73, 66, 2),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    _editarHospedagem.genero.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Diarias: ",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 73, 66, 2),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    diaria.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(children: [
                                ConstrainedBox(
                                  constraints: const BoxConstraints.tightFor(
                                    width: 150,
                                  ),
                                  child: TextFormField(
                                    controller: valorDiariaController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(),
                                    autofocus: false,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Diaria: R\$",
                                      labelStyle: TextStyle(
                                        color: Color.fromARGB(255, 73, 66, 2),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onChanged: (text) {
                                      _hospedagemEditada = true;
                                      _totalHospedagem();
                                      _calculaDiaria();
                                    },
                                  ),
                                ),
                              ]),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(children: [
                                ConstrainedBox(
                                  constraints: const BoxConstraints.tightFor(
                                    width: 150,
                                  ),
                                  child: TextFormField(
                                    controller: adicionalController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(),
                                    autofocus: false,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Adicional: R\$",
                                      labelStyle: TextStyle(
                                        color: Color.fromARGB(255, 73, 66, 2),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onChanged: (text) {
                                      _hospedagemEditada = true;
                                      _totalHospedagem();
                                      _calculaDiaria();
                                    },
                                  ),
                                ),
                              ]),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(children: [
                                ConstrainedBox(
                                  constraints: const BoxConstraints.tightFor(
                                    width: 350,
                                  ),
                                  child: TextFormField(
                                    controller: observacaoController,
                                    autofocus: false,
                                    textInputAction: TextInputAction.newline,
                                    minLines: 4,
                                    maxLines: 10,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Observação",
                                      labelStyle: TextStyle(
                                        color: Color.fromARGB(255, 73, 66, 2),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onChanged: (text) {
                                      _hospedagemEditada = true;
                                      _editarHospedagem.observacao = text;
                                    },
                                  ),
                                ),
                              ]),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(children: [
                                ConstrainedBox(
                                  constraints: const BoxConstraints.tightFor(
                                    width: 150,
                                  ),
                                  child: TextFormField(
                                    controller: valorTotalController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(),
                                    autofocus: false,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Valor: R\$",
                                      labelStyle: TextStyle(
                                        color: Color.fromARGB(255, 73, 66, 2),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onChanged: (text) {
                                      _hospedagemEditada = true;
                                      _editarHospedagem.valorTotal =
                                          totalHospedagem;
                                    },
                                  ),
                                ),
                              ])
                            ]),
                      )
                    ]))),
          ),
        ));
  }

  Future<bool> _retornaPop(BuildContext context) {
    if (_hospedagemEditada) {
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
                    _limpaCampos();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ListaHospedagem()));
                  },
                  child: const Text(
                    "Continuar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  void _SalvarHospedagem() async {
    final gravaHospedagem = _editarHospedagem;
    await info.salvarHospedagem(gravaHospedagem);
    paginaHospedagem();
  }
}
