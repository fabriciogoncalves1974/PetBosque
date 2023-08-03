import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_bosque/funcoes/info_agendamento.dart';
import 'package:pet_bosque/funcoes/info_pet.dart';
import 'package:pet_bosque/paginas/lista_agendamentos.dart';

class EditarAgendamento extends StatefulWidget {
  final Agendamento _agendamento;

  var contaPlano;
  EditarAgendamento({
    super.key,
    Agendamento? agendamento,
  }) : _agendamento = agendamento ?? Agendamento();

  String fotoPet = "";
  String nomeContato = "";
  String nomePet = "";
  String idPet = "";

  @override
  _EditarAgendamentoState createState() => _EditarAgendamentoState();
}

String planoVencido = "P";

bool svcBanho = false;
bool svcTosa = false;
bool svcTosaHigienica = false;
bool svcCorteUnha = false;
bool svcHidratacao = false;
bool svcPintura = false;
bool svcHospedagem = false;
bool svcTransporte = false;

DateTime _dateTime = DateTime.now();
TimeOfDay _time = TimeOfDay.now();
DateTime _dataAgendamento = DateTime.now();
String banho = "N";
String tosa = "N";
String tosaHigienica = "N";
String corteUnha = "N";
String hidratacao = "N";
String pintura = "N";
String hospedagem = "N";
String transporte = "N";
String status = "Pendente";

InfoAgendamento info = InfoAgendamento();
InfoPet infoPet = InfoPet();

class _EditarAgendamentoState extends State<EditarAgendamento> {
  TextEditingController valorBanhoController = TextEditingController();
  TextEditingController valorTosaController = TextEditingController();
  TextEditingController valorTosaHigienicaController = TextEditingController();
  TextEditingController valorCorteUnhaController = TextEditingController();
  TextEditingController valorHidratacaoController = TextEditingController();
  TextEditingController valorPinturaController = TextEditingController();
  TextEditingController valorHospedagemController = TextEditingController();
  TextEditingController valorTransporteController = TextEditingController();
  TextEditingController valorAdicionalController = TextEditingController();
  TextEditingController observacaoController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late Agendamento _editarAgendamento;

  bool _agendamentoEditado = false;
  String data = DateFormat("dd/MM/yyyy").format(DateTime.now());
  String infoValor = "0,00";

  @override
  void initState() {
    super.initState();

    _editarAgendamento = Agendamento.fromMap(widget._agendamento.toMap());
    _habilitaCheck();
    infoValor = _editarAgendamento.valorTotal.toString();
    observacaoController.text = _editarAgendamento.observacao.toString();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _dateTime =
          (DateFormat('dd/MM/yyyy').parse(_editarAgendamento.data.toString()));
      _dataAgendamento =
          (DateFormat('dd/MM/yyyy').parse(_editarAgendamento.data.toString()));
      _time = TimeOfDay.fromDateTime(
          DateTime.parse('0000-00-00 ${_editarAgendamento.hora}:00Z'));

      _editarAgendamento.nomeContato =
          _editarAgendamento.nomeContato.toString();
      _editarAgendamento.nomePet = _editarAgendamento.nomePet.toString();
      _editarAgendamento.fotoPet = _editarAgendamento.fotoPet.toString();
      _editarAgendamento.idPet = _editarAgendamento.idPet.toString();
    });
  }

  paginaAgendamentos() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ListaAgendamentos(
                data: data,
              )),
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
        _dataAgendamento = value!;
        _dateTime = value;
      });
    });
  }

  late TimeOfDay picked;
  late String hora;

  FirebaseFirestore db = FirebaseFirestore.instance;
  void _executaFuncoes() {
    _editarCheck();
    _total();
    _limpaCheck();
  }

  void _habilitaCheck() {
    if (_editarAgendamento.svBanho == "S") {
      svcBanho = true;
      valorBanhoController.text = _editarAgendamento.valorBanho.toString();
    }
    if (_editarAgendamento.svTosa == "S") {
      svcTosa = true;
      valorTosaController.text = _editarAgendamento.valorTosa.toString();
    }
    if (_editarAgendamento.svTosaHigienica == "S") {
      svcTosaHigienica = true;
      valorTosaHigienicaController.text =
          _editarAgendamento.valorTosaHigienica.toString();
    }
    if (_editarAgendamento.svCorteUnha == "S") {
      svcCorteUnha = true;
      valorCorteUnhaController.text =
          _editarAgendamento.valorCorteUnha.toString();
    }
    if (_editarAgendamento.svHidratacao == "S") {
      svcHidratacao = true;
      valorHidratacaoController.text =
          _editarAgendamento.valorHidratacao.toString();
    }
    if (_editarAgendamento.svPintura == "S") {
      svcPintura = true;
      valorPinturaController.text = _editarAgendamento.valorPintura.toString();
    }
    if (_editarAgendamento.svHospedagem == "S") {
      svcHospedagem = true;
      valorHospedagemController.text =
          _editarAgendamento.valorHospedagem.toString();
    }
    if (_editarAgendamento.svTransporte == "S") {
      svcTransporte = true;
      valorTransporteController.text =
          _editarAgendamento.valorTransporte.toString();
    }
    if (_editarAgendamento.valorAdicional != null) {
      valorAdicionalController.text =
          _editarAgendamento.valorAdicional.toString();
    }
  }

  void _editarCheck() {
    if (svcBanho == false) {
      _editarAgendamento.svBanho = "";
      valorBanhoController.text = "0";
    }
    if (svcTosa == false) {
      _editarAgendamento.svTosa = "";
      valorTosaController.text = "0";
    }
    if (svcTosaHigienica == false) {
      _editarAgendamento.svTosaHigienica = "";
      valorTosaHigienicaController.text = "0";
    }
    if (svcCorteUnha == false) {
      _editarAgendamento.svCorteUnha = "";
      valorCorteUnhaController.text = "0";
    }
    if (svcHidratacao == false) {
      _editarAgendamento.svHidratacao = "";
      valorHidratacaoController.text = "0";
    }
    if (svcPintura == false) {
      _editarAgendamento.svPintura = "";
      valorPinturaController.text = "0";
    }
    if (svcHospedagem == false) {
      _editarAgendamento.svHospedagem = "";
      valorHospedagemController.text = "0";
    }
    if (svcTransporte == false) {
      _editarAgendamento.svTransporte = "";
      valorTransporteController.text = "0";
    }
    if (valorAdicionalController.text == null) {
      valorAdicionalController.text = "0";
    }
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

  void _total() {
    setState(() {
      double valorAdicional =
          double.tryParse(valorAdicionalController.text) ?? 0;
      double vBanho = double.tryParse(valorBanhoController.text) ?? 0;
      double vTosa = double.tryParse(valorTosaController.text) ?? 0;
      double vTosaHigienica =
          double.tryParse(valorTosaHigienicaController.text) ?? 0;
      double vCorteUnha = double.tryParse(valorCorteUnhaController.text) ?? 0;
      double vHidratacao = double.tryParse(valorHidratacaoController.text) ?? 0;
      double vPintura = double.tryParse(valorPinturaController.text) ?? 0;
      double vHospedagem = double.tryParse(valorHospedagemController.text) ?? 0;
      double vTransporte = double.tryParse(valorTransporteController.text) ?? 0;

      double valor = (vBanho +
          valorAdicional +
          vTosa +
          vTosaHigienica +
          vCorteUnha +
          vHidratacao +
          vPintura +
          vHospedagem +
          vTransporte);
      infoValor = "R\$ $valor";
      //_editarAgendamento.svBanho = banho;
      _editarAgendamento.valorBanho = vBanho;
      //_editarAgendamento.svTosa = tosa;
      _editarAgendamento.valorTosa = vTosa;
      //_editarAgendamento.svTosaHigienica = tosaHigienica;
      _editarAgendamento.valorTosaHigienica = vTosaHigienica;
      //_editarAgendamento.svCorteUnha = corteUnha;
      _editarAgendamento.valorCorteUnha = vCorteUnha;
      //_editarAgendamento.svHidratacao = hidratacao;
      _editarAgendamento.valorHidratacao = vHidratacao;
      //_editarAgendamento.svPintura = pintura;
      _editarAgendamento.valorPintura = vPintura;
      //_editarAgendamento.svHospedagem = hospedagem;
      _editarAgendamento.valorHospedagem = vHospedagem;
      //_editarAgendamento.svTransporte = transporte;
      _editarAgendamento.valorTransporte = vTransporte;
      _editarAgendamento.valorTotal = valor;
      _editarAgendamento.data = DateFormat("dd/MM/yyyy").format(_dateTime);
      _editarAgendamento.hora = _time.format(context);
      _editarAgendamento.status = status;
    });
  }

  Future<void> selectTime(BuildContext context) async {
    picked = (await showTimePicker(
      context: context,
      initialTime: _time,
    ))!;
    setState(() {
      _time = picked;
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
            title: const Text("Editar Agendamento"),
            leading: BackButton(onPressed: () {
              if (_agendamentoEditado != true) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ListaAgendamentos(
                          data: data,
                        )));
              }
              _retornaPop(context);
            }),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              _editarAgendamento.planoVencido = planoVencido;
              //info.salvarAgendamento(_editarAgendamento);
              _executaFuncoes();
              String id = _editarAgendamento.id.toString();
              db.collection("agendamentos").doc(id).set({
                "idAgendamento": id,
                "idPet": _editarAgendamento.idPet,
                "nomeContato": _editarAgendamento.nomeContato,
                "fotoPet": _editarAgendamento.fotoPet,
                "nomePet": _editarAgendamento.nomePet,
                "data": _editarAgendamento.data,
                "hora": _editarAgendamento.hora,
                "svBanho": _editarAgendamento.svBanho,
                "valorBanho": _editarAgendamento.valorBanho,
                "svTosa": _editarAgendamento.svTosa,
                "valorTosa": _editarAgendamento.valorTosa,
                "svCorteUnha": _editarAgendamento.svCorteUnha,
                "valorCorteUnha": _editarAgendamento.valorCorteUnha,
                "svHidratacao": _editarAgendamento.svHidratacao,
                "valorHidratacao": _editarAgendamento.valorHidratacao,
                "svTosaHigienica": _editarAgendamento.svTosaHigienica,
                "valorTosaHigienica": _editarAgendamento.valorTosaHigienica,
                "svPintura": _editarAgendamento.svPintura,
                "valorPintura": _editarAgendamento.valorPintura,
                "svHospedagem": _editarAgendamento.svHospedagem,
                "valorHospedagem": _editarAgendamento.valorHospedagem,
                "svTransporte": _editarAgendamento.svTransporte,
                "valorTransporte": _editarAgendamento.valorTransporte,
                "valorAdicional": _editarAgendamento.valorAdicional,
                "valorTotal": _editarAgendamento.valorTotal,
                "observacao": _editarAgendamento.observacao,
                "status": _editarAgendamento.status,
                "colaborador": _editarAgendamento.colaborador,
                "idColaborador": _editarAgendamento.idColaborador,
                "idParticipante": _editarAgendamento.id,
                "participante": _editarAgendamento.participante,
                "planoVencido": _editarAgendamento.planoVencido
              });

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListaAgendamentos(
                            data: data,
                          )));
            },
            icon: const Icon(Icons.save),
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
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    children: [
                      Container(
                        child: const Text(
                          "Data: ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromARGB(255, 73, 66, 2),
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () => _showDatePicker(context),
                        //color: Colors.blue,

                        child: Text(DateFormat("dd/MM/yyyy").format(_dateTime),
                            style: const TextStyle(
                              color: Color.fromARGB(182, 66, 61, 61),
                              fontSize: 25,
                            )),
                      ),
                      MaterialButton(
                        onPressed: () {
                          selectTime(context);
                        },
                        child: Text(_time.format(context),
                            style: const TextStyle(
                              color: Color.fromARGB(182, 66, 61, 61),
                              fontSize: 25,
                            )),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: Row(children: [
                    const Text(
                      "Cliente:",
                      style: TextStyle(
                        color: Color.fromARGB(255, 73, 66, 2),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      _editarAgendamento.nomeContato ?? "",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        height: 2,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ]),
                ),
                Container(
                    child: Row(children: [
                  const Text(
                    "Pet:",
                    style: TextStyle(
                      color: Color.fromARGB(255, 73, 66, 2),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    _editarAgendamento.nomePet ?? "",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      height: 2,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ])),
                const Row(children: [
                  Text(
                    "Serviços: ",
                    style: TextStyle(
                      color: Color.fromARGB(255, 73, 66, 2),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ]),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                                value: svcBanho,
                                onChanged: (checked) {
                                  setState(() {
                                    svcBanho = checked!;
                                    if (svcBanho == false) {
                                      valorBanhoController.text = "";
                                      _total();
                                    }
                                  });
                                }),
                            const Text(
                              "Banho",
                              textAlign: TextAlign.center,
                              style: TextStyle(height: 2, fontSize: 15),
                            ),
                          ],
                        ),
                        if (svcBanho == true)
                          ConstrainedBox(
                            constraints: const BoxConstraints.tightFor(
                              width: 150,
                            ),
                            child: TextFormField(
                              keyboardType:
                                  const TextInputType.numberWithOptions(),
                              controller: valorBanhoController,
                              decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15.0),
                                  border: OutlineInputBorder(),
                                  labelText: "R\$",
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(2),
                                  )),
                              onChanged: (text) {
                                _agendamentoEditado = true;
                                _editarAgendamento.svBanho = "S";
                                _total();
                              },
                            ),
                          ),
                      ]),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                                value: svcTosa,
                                onChanged: (checked) {
                                  setState(() {
                                    svcTosa = checked!;
                                    if (svcTosa == false) {
                                      valorTosaController.text = "";
                                      _total();
                                    }
                                  });
                                }),
                            const Text(
                              "Tosa",
                              textAlign: TextAlign.center,
                              style: TextStyle(height: 2, fontSize: 15),
                            ),
                          ],
                        ),
                        if (svcTosa == true)
                          ConstrainedBox(
                            constraints: const BoxConstraints.tightFor(
                              width: 150,
                            ),
                            child: TextFormField(
                              keyboardType:
                                  const TextInputType.numberWithOptions(),
                              controller: valorTosaController,
                              decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15.0),
                                  border: OutlineInputBorder(),
                                  labelText: "R\$",
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(2),
                                  )),
                              onChanged: (text) {
                                _agendamentoEditado = true;
                                _editarAgendamento.svTosa = "S";
                                _total();
                              },
                            ),
                          ),
                      ]),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                                value: svcTosaHigienica,
                                onChanged: (checked) {
                                  setState(() {
                                    svcTosaHigienica = checked!;
                                    if (svcTosaHigienica == false) {
                                      valorTosaHigienicaController.text = "";
                                      _total();
                                    }
                                  });
                                }),
                            const Text(
                              "Tosa Higiênica",
                              textAlign: TextAlign.center,
                              style: TextStyle(height: 2, fontSize: 15),
                            ),
                          ],
                        ),
                        if (svcTosaHigienica == true)
                          ConstrainedBox(
                            constraints: const BoxConstraints.tightFor(
                              width: 150,
                            ),
                            child: TextFormField(
                              keyboardType:
                                  const TextInputType.numberWithOptions(),
                              controller: valorTosaHigienicaController,
                              decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15.0),
                                  border: OutlineInputBorder(),
                                  labelText: "R\$",
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(2),
                                  )),
                              onChanged: (text) {
                                _agendamentoEditado = true;
                                _editarAgendamento.svTosaHigienica = "S";
                                _total();
                              },
                            ),
                          ),
                      ]),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                                value: svcCorteUnha,
                                onChanged: (checked) {
                                  setState(() {
                                    svcCorteUnha = checked!;
                                    if (svcCorteUnha == false) {
                                      valorCorteUnhaController.text = "";
                                      _total();
                                    }
                                  });
                                }),
                            const Text(
                              "Corte de unha",
                              textAlign: TextAlign.center,
                              style: TextStyle(height: 2, fontSize: 15),
                            ),
                          ],
                        ),
                        if (svcCorteUnha == true)
                          ConstrainedBox(
                            constraints: const BoxConstraints.tightFor(
                              width: 150,
                            ),
                            child: TextFormField(
                              keyboardType:
                                  const TextInputType.numberWithOptions(),
                              controller: valorCorteUnhaController,
                              decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15.0),
                                  border: OutlineInputBorder(),
                                  labelText: "R\$",
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(2),
                                  )),
                              onChanged: (text) {
                                _agendamentoEditado = true;
                                _editarAgendamento.svCorteUnha = "S";
                                _total();
                              },
                            ),
                          ),
                      ]),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                                value: svcHidratacao,
                                onChanged: (checked) {
                                  setState(() {
                                    svcHidratacao = checked!;
                                    if (svcHidratacao == false) {
                                      valorHidratacaoController.text = "";
                                      _total();
                                    }
                                  });
                                }),
                            const Text(
                              "Hidratação",
                              textAlign: TextAlign.center,
                              style: TextStyle(height: 2, fontSize: 15),
                            ),
                          ],
                        ),
                        if (svcHidratacao == true)
                          ConstrainedBox(
                            constraints: const BoxConstraints.tightFor(
                              width: 150,
                            ),
                            child: TextFormField(
                              keyboardType:
                                  const TextInputType.numberWithOptions(),
                              controller: valorHidratacaoController,
                              decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15.0),
                                  border: OutlineInputBorder(),
                                  labelText: "R\$",
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(2),
                                  )),
                              onChanged: (text) {
                                _agendamentoEditado = true;
                                _editarAgendamento.svHidratacao = "S";
                                _total();
                              },
                            ),
                          ),
                      ]),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                                value: svcPintura,
                                onChanged: (checked) {
                                  setState(() {
                                    svcPintura = checked!;
                                    if (svcPintura == false) {
                                      valorPinturaController.text = "";
                                      _total();
                                    }
                                  });
                                }),
                            const Text(
                              "Pintura",
                              textAlign: TextAlign.center,
                              style: TextStyle(height: 2, fontSize: 15),
                            ),
                          ],
                        ),
                        if (svcPintura == true)
                          ConstrainedBox(
                            constraints: const BoxConstraints.tightFor(
                              width: 150,
                            ),
                            child: TextFormField(
                              keyboardType:
                                  const TextInputType.numberWithOptions(),
                              controller: valorPinturaController,
                              decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15.0),
                                  border: OutlineInputBorder(),
                                  labelText: "R\$",
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(2),
                                  )),
                              onChanged: (text) {
                                _agendamentoEditado = true;
                                _editarAgendamento.svPintura = "S";
                                _total();
                              },
                            ),
                          ),
                      ]),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                                value: svcHospedagem,
                                onChanged: (checked) {
                                  setState(() {
                                    svcHospedagem = checked!;
                                    if (svcHospedagem == false) {
                                      valorHospedagemController.text = "";
                                      _total();
                                    }
                                  });
                                }),
                            const Text(
                              "Hospedagem",
                              textAlign: TextAlign.center,
                              style: TextStyle(height: 2, fontSize: 15),
                            ),
                          ],
                        ),
                        if (svcHospedagem == true)
                          ConstrainedBox(
                            constraints: const BoxConstraints.tightFor(
                              width: 150,
                            ),
                            child: TextFormField(
                              keyboardType:
                                  const TextInputType.numberWithOptions(),
                              controller: valorHospedagemController,
                              decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15.0),
                                  border: OutlineInputBorder(),
                                  labelText: "R\$",
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(2),
                                  )),
                              onChanged: (text) {
                                _agendamentoEditado = true;
                                _editarAgendamento.svHospedagem = "S";
                                _total();
                              },
                            ),
                          ),
                      ]),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                                value: svcTransporte,
                                onChanged: (checked) {
                                  setState(() {
                                    svcTransporte = checked!;
                                    if (svcTransporte == false) {
                                      valorTransporteController.text = "";
                                      _total();
                                    }
                                  });
                                }),
                            const Text(
                              "Transporte",
                              textAlign: TextAlign.center,
                              style: TextStyle(height: 2, fontSize: 15),
                            ),
                          ],
                        ),
                        if (svcTransporte == true)
                          ConstrainedBox(
                            constraints: const BoxConstraints.tightFor(
                              width: 150,
                            ),
                            child: TextFormField(
                              keyboardType:
                                  const TextInputType.numberWithOptions(),
                              controller: valorTransporteController,
                              decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15.0),
                                  border: OutlineInputBorder(),
                                  labelText: "R\$",
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(2),
                                  )),
                              onChanged: (text) {
                                _agendamentoEditado = true;
                                _editarAgendamento.svTransporte = "S";
                                _total();
                              },
                            ),
                          ),
                      ]),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(
                      width: 200,
                    ),
                    child: TextFormField(
                      keyboardType: const TextInputType.numberWithOptions(),
                      controller: valorAdicionalController,
                      autofocus: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Valor adicional: R\$",
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 73, 66, 2),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onChanged: (text) {
                        _agendamentoEditado = true;
                        _editarAgendamento.valorAdicional =
                            double.tryParse(text) ?? 0;
                        _total();
                      },
                    ),
                  ),
                ]),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  color: const Color.fromARGB(255, 228, 222, 222),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Text(
                              "Total",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromARGB(255, 73, 66, 2),
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints.tightFor(
                            width: 150,
                          ),
                          child: Text(
                            "R\$ ${_editarAgendamento.valorTotal!.toStringAsFixed(2)}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(height: 2, fontSize: 20),
                          ),
                        ),
                      ]),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  textInputAction: TextInputAction.newline,
                  controller: observacaoController,
                  minLines: 4,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),

                    //Fundo do textfield branco
                    //filled: true,
                    //fillColor: Colors.white,
                    labelText: "Observação",
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(10),
                    ),
                  ),
                  onChanged: (text) {
                    _editarAgendamento.observacao = text;
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
    if (_agendamentoEditado) {
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
                    _limpaCheck();
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
                    _limpaCheck();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ListaAgendamentos(
                              data: data,
                            )));
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
      _limpaCheck();
      return Future.value(true);
    }
  }

  void _SalvarAgendamento() async {
    final gravaAgendamento = _editarAgendamento;
    await info.salvarAgendamento(gravaAgendamento);
    paginaAgendamentos();
  }
}
