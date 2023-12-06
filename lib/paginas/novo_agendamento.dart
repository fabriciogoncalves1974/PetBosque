import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_bosque/funcoes/info_agendamento.dart';
import 'package:pet_bosque/funcoes/info_pet.dart';
import 'package:pet_bosque/paginas/lista_agendamentos.dart';
import 'package:pet_bosque/paginas/lista_pet.dart';

class NovoAgendamento extends StatefulWidget {
  final Agendamento _agendamento;

  var contaPlano;
  NovoAgendamento(
      {super.key,
      Agendamento? agendamento,
      required this.fotoPet,
      required this.idPet,
      required this.nomePet,
      required this.contaPlano,
      required this.nomeContato})
      : _agendamento = agendamento ?? Agendamento();

  late String fotoPet;
  late String nomeContato;
  late String nomePet;
  late String idPet;

  @override
  _NovoAgendamentoState createState() => _NovoAgendamentoState();
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

class _NovoAgendamentoState extends State<NovoAgendamento> {
  TextEditingController valorBanhoController = TextEditingController();
  TextEditingController valorTosaController = TextEditingController();
  TextEditingController valorTosaHigienicaController = TextEditingController();
  TextEditingController valorCorteUnhaController = TextEditingController();
  TextEditingController valorHidratacaoController = TextEditingController();
  TextEditingController valorPinturaController = TextEditingController();
  TextEditingController valorHospedagemController = TextEditingController();
  TextEditingController valorTransporteController = TextEditingController();
  TextEditingController valorAdicionalController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final Agendamento _novoAgendamento = Agendamento();

  bool _agendamentoEditado = false;
  String data = DateFormat("yyyy-MM-dd").format(DateTime.now());
  late String _dataAgendamento;
  late int contadorPlano;

  @override
  void initState() {
    super.initState();
    _novoAgendamento.nomeContato = widget.nomeContato;
    _novoAgendamento.nomePet = widget.nomePet;
    _novoAgendamento.fotoPet = widget.fotoPet;
    _novoAgendamento.idPet = widget.idPet;
    contadorPlano = int.parse(widget.contaPlano);
  }

  paginaAgendamentos() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ListaAgendamentos(
                data: data,
              )),
    );
  }

  DateTime _dateTime = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();

  void _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    ).then((value) {
      setState(() {
        _dataAgendamento = DateFormat("yyyy-MM-dd").format(value!);
        _dateTime = value;
      });
    });
  }

  late TimeOfDay picked;
  late String hora;
  String _infoValor = "0,00";
  //FirebaseFirestore db = FirebaseFirestore.instance;
  void _executaFuncoes() {
    verificaNull();
    _total();
    _limpaCheck();
    if (contadorPlano != 0) {
      _contadorPLano();
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

  void _contadorPLano() {
    contadorPlano = (contadorPlano - 1);
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
      _infoValor = "R\$ $valor";
      //_novoAgendamento.svBanho = banho;
      _novoAgendamento.valorBanho = vBanho;
      //_novoAgendamento.svTosa = tosa;
      _novoAgendamento.valorTosa = vTosa;
      //_novoAgendamento.svTosaHigienica = tosaHigienica;
      _novoAgendamento.valorTosaHigienica = vTosaHigienica;
      //_novoAgendamento.svCorteUnha = corteUnha;
      _novoAgendamento.valorCorteUnha = vCorteUnha;
      //_novoAgendamento.svHidratacao = hidratacao;
      _novoAgendamento.valorHidratacao = vHidratacao;
      //_novoAgendamento.svPintura = pintura;
      _novoAgendamento.valorPintura = vPintura;
      //_novoAgendamento.svHospedagem = hospedagem;
      _novoAgendamento.valorHospedagem = vHospedagem;
      //_novoAgendamento.svTransporte = transporte;
      _novoAgendamento.valorTransporte = vTransporte;
      _novoAgendamento.valorTotal = valor;
      _novoAgendamento.data = DateFormat("yyyy-MM-dd").format(_dateTime);
      _novoAgendamento.hora = _time.format(context);
      _novoAgendamento.status = status;
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
            title: const Text("Novo Agendamento"),
            leading: BackButton(onPressed: () {
              if (_agendamentoEditado != true) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ListaPet()));
              }
              _retornaPop(context);
            }),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              _executaFuncoes();
              _novoAgendamento.planoVencido = planoVencido;
              info.salvarAgendamentoApi(_novoAgendamento);
              //info.salvarAgendamento(_novoAgendamento);

              /* String id = Uuid().v1();
              db.collection("agendamentos").doc(id).set({
                "idAgendamento": id,
                "idPet": _novoAgendamento.idPet,
                "nomeContato": _novoAgendamento.nomeContato,
                "fotoPet": _novoAgendamento.fotoPet,
                "nomePet": _novoAgendamento.nomePet,
                "data": _novoAgendamento.data,
                "hora": _novoAgendamento.hora,
                "svBanho": _novoAgendamento.svBanho,
                "valorBanho": _novoAgendamento.valorBanho,
                "svTosa": _novoAgendamento.svTosa,
                "valorTosa": _novoAgendamento.valorTosa,
                "svCorteUnha": _novoAgendamento.svCorteUnha,
                "valorCorteUnha": _novoAgendamento.valorCorteUnha,
                "svHidratacao": _novoAgendamento.svHidratacao,
                "valorHidratacao": _novoAgendamento.valorHidratacao,
                "svTosaHigienica": _novoAgendamento.svTosaHigienica,
                "valorTosaHigienica": _novoAgendamento.valorTosaHigienica,
                "svPintura": _novoAgendamento.svPintura,
                "valorPintura": _novoAgendamento.valorPintura,
                "svHospedagem": _novoAgendamento.svHospedagem,
                "valorHospedagem": _novoAgendamento.valorHospedagem,
                "svTransporte": _novoAgendamento.svTransporte,
                "valorTransporte": _novoAgendamento.valorTransporte,
                "valorAdicional": _novoAgendamento.valorAdicional,
                "valorTotal": _novoAgendamento.valorTotal,
                "observacao": _novoAgendamento.observacao,
                "status": _novoAgendamento.status,
                "colaborador": _novoAgendamento.colaborador,
                "idColaborador": _novoAgendamento.idColaborador,
                "idParticipante": _novoAgendamento.id,
                "participante": _novoAgendamento.participante,
                "planoVencido": _novoAgendamento.planoVencido
              });*/
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListaAgendamentos(
                            data: data,
                          )));
            },
            icon: const Icon(Icons.save),
            backgroundColor: const Color.fromRGBO(249, 94, 0, 1),
            hoverColor: const Color.fromRGBO(249, 94, 0, 100),
            foregroundColor: Colors.white,
            label: Text("Salvar"),
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
                      width: 10,
                    ),
                    Text(
                      widget.nomeContato,
                      textAlign: TextAlign.center,
                      style: const TextStyle(height: 2, fontSize: 15),
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
                    widget.nomePet,
                    textAlign: TextAlign.center,
                    style: const TextStyle(height: 2, fontSize: 15),
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
                                  print(checked);
                                  setState(() {
                                    svcBanho = checked!;
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
                              autofocus: true,
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
                                _novoAgendamento.svBanho = "S";
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
                                  print(checked);
                                  setState(() {
                                    svcTosa = checked!;
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
                              autofocus: true,
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
                                _novoAgendamento.svTosa = "S";
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
                                  print(checked);
                                  setState(() {
                                    svcTosaHigienica = checked!;
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
                              autofocus: true,
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
                                _novoAgendamento.svTosaHigienica = "S";
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
                                  print(checked);
                                  setState(() {
                                    svcCorteUnha = checked!;
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
                              autofocus: true,
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
                                _novoAgendamento.svCorteUnha = "S";
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
                                  print(checked);
                                  setState(() {
                                    svcHidratacao = checked!;
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
                              autofocus: true,
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
                                _novoAgendamento.svHidratacao = "S";
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
                                  print(checked);
                                  setState(() {
                                    svcPintura = checked!;
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
                              autofocus: true,
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
                                _novoAgendamento.svPintura = "S";
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
                                  print(checked);
                                  setState(() {
                                    svcHospedagem = checked!;
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
                              autofocus: true,
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
                                _novoAgendamento.svHospedagem = "S";
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
                                  print(checked);
                                  setState(() {
                                    svcTransporte = checked!;
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
                              autofocus: true,
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
                                _novoAgendamento.svTransporte = "S";
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
                        _novoAgendamento.valorAdicional =
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
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Text(
                              "Total",
                              textAlign: TextAlign.center,
                              style: TextStyle(height: 2, fontSize: 20),
                            ),
                          ],
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints.tightFor(
                            width: 150,
                          ),
                          child: Text(
                            _infoValor,
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
                    _novoAgendamento.observacao = text;
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
                        builder: (context) => const ListaPet()));
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

  void verificaNull() {
    _novoAgendamento.svBanho ??= "N";
    _novoAgendamento.svCorteUnha ??= "N";
    _novoAgendamento.svHidratacao ??= "N";
    _novoAgendamento.svHospedagem ??= "N";
    _novoAgendamento.svPintura ??= "N";
    _novoAgendamento.svTosa ??= "N";
    _novoAgendamento.svTosaHigienica ??= "N";
    _novoAgendamento.svTransporte ??= "N";
    _novoAgendamento.observacao ??= "";
    _novoAgendamento.colaborador ??= "";
    _novoAgendamento.idColaborador ??= "";
    _novoAgendamento.idParticipante ??= "";
    _novoAgendamento.participante ??= "";
  }

  void _SalvarAgendamento() async {
    final gravaAgendamento = _novoAgendamento;
    await info.salvarAgendamentoApi(gravaAgendamento);
    paginaAgendamentos();
  }
}
