import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_bosque/funcoes/info_agendamento.dart';
import 'package:pet_bosque/funcoes/info_pet.dart';
import 'package:pet_bosque/funcoes/info_plano.dart';
import 'package:pet_bosque/paginas/editar_hospedagem.dart';
import 'package:pet_bosque/paginas/lista_agendamentos.dart';
import 'package:pet_bosque/paginas/novo_agendamento.dart';

class EditarAgendamentoPlano extends StatefulWidget {
  final Agendamento _agendamento;

  var contaPlano;
  EditarAgendamentoPlano({
    super.key,
    Agendamento? agendamento,
  }) : _agendamento = agendamento ?? Agendamento();

  @override
  _EditarAgendamentoPlanoState createState() => _EditarAgendamentoPlanoState();
}

Plano? itens;
String data = DateFormat("dd/MM/yyyy").format(DateTime.now());
InfoAgendamento info = InfoAgendamento();
InfoPlano infoPlano = InfoPlano();
InfoPet infoPet = InfoPet();

class _EditarAgendamentoPlanoState extends State<EditarAgendamentoPlano> {
  TextEditingController valorAdicionalController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late Agendamento _editarAgendamento;

  bool _agendamentoEditado = false;

  late String _dataAgendamento;
  late int contadorPlano;
  String planoVencido = "N";
  bool loading = false;
  double valorPlano = 0;
  double valorAdicional = 0;
  double valorTotal = 0;

  FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    _editarAgendamento = Agendamento.fromMap(widget._agendamento.toMap());
    valorAdicional = _editarAgendamento.valorAdicional ?? 0;
    valorTotal = _editarAgendamento.valorTotal ?? 0;
    valorPlano = (valorTotal - valorAdicional);
    valorAdicionalController.text =
        _editarAgendamento.valorAdicional.toString() ?? '0';

    observacaoController.text = _editarAgendamento.observacao.toString();
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
        _dataAgendamento = DateFormat("dd/MM/yyyy").format(value!);
        _dateTime = _dateTime;
        _dateTime = value;
      });
    });
  }

  late TimeOfDay picked;
  late String hora;
  final String _infoValor = "0,00";

  void _executaFuncoes() {
    //_total();
  }

  void _total() {
    setState(() {
      valorAdicional = double.tryParse(valorAdicionalController.text) ?? 0;
      //valorPlano = _editarAgendamento.valorAdicional ?? 0;

      valorTotal = (valorPlano + valorAdicional);

      _editarAgendamento.valorTotal = valorTotal;
      _editarAgendamento.data = DateFormat("dd/MM/yyyy").format(_dateTime);
      _editarAgendamento.hora = _time.format(context);
      _editarAgendamento.status = status;
      if (itens?.svBanho.toString() == "S") {
        _editarAgendamento.svBanho = "S";
        _editarAgendamento.valorBanho = 0;
      }
      if (itens?.svTosa.toString() == "S") {
        _editarAgendamento.svTosa = "S";
        _editarAgendamento.valorTosa = 0;
      }
      if (itens?.svTosaHigienica.toString() == "S") {
        _editarAgendamento.valorTosaHigienica = 0;
      }
      if (itens?.svHidratacao.toString() == "S") {
        _editarAgendamento.svHidratacao = "S";
        _editarAgendamento.valorHidratacao = 0;
      }
      if (itens?.svPintura.toString() == "S") {
        _editarAgendamento.svPintura = "S";
        _editarAgendamento.valorPintura = 0;
      }
      if (itens?.svCorteUnha.toString() == "S") {
        _editarAgendamento.svCorteUnha = "S";
        _editarAgendamento.valorCorteUnha = 0;
      }
      if (itens?.svTransporte.toString() == "S") {
        _editarAgendamento.svTransporte = "S";
        _editarAgendamento.valorTransporte = 0;
      }
      if (itens?.svHospedagem.toString() == "S") {
        _editarAgendamento.svHospedagem = "S";
        _editarAgendamento.valorHospedagem = 0;
      }
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ListaAgendamentos(data: data)));
                  }
                  _retornaPop(context);
                }),
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  loading = true;
                  if (loading = true) {
                    Center(
                      child: CircularProgressIndicator(
                        color: Colors.greenAccent,
                        backgroundColor: Colors.grey,
                      ),
                    );
                  }

                  //info.salvarAgendamento(_editarAgendamento);
                  _executaFuncoes();
                  if (_editarAgendamento.valorAdicional == null) {
                    _editarAgendamento.valorAdicional = 0;
                  }

                  db.collection("agendamentos").doc(_editarAgendamento.id).set({
                    "idAgendamento": _editarAgendamento.id,
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
                  loading = false;
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

                              child: Text(
                                  DateFormat("dd/MM/yyyy").format(_dateTime),
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
                            _editarAgendamento.nomeContato.toString(),
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
                          _editarAgendamento.nomePet.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(height: 2, fontSize: 15),
                        ),
                      ])),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Text(
                            "Valor do Plano: ",
                            style: TextStyle(
                              color: Color.fromARGB(255, 73, 66, 2),
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            valorPlano.toString() ?? "",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
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
                      Row(children: [
                        if (_editarAgendamento.svBanho.toString() == "S")
                          const Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                        if (_editarAgendamento.svBanho.toString() == "S")
                          const Text(
                            "Banho",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                      ]),
                      Row(children: [
                        if (_editarAgendamento.svTosa.toString() == "S")
                          const Icon(color: Colors.green, Icons.check),
                        if (_editarAgendamento.svTosa == "S")
                          const Text(
                            "Tosa",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                      ]),
                      Row(children: [
                        if (_editarAgendamento.svTosaHigienica.toString() ==
                            "S")
                          const Icon(color: Colors.green, Icons.check),
                        if (_editarAgendamento.svTosaHigienica == "S")
                          const Text(
                            "Tosa Higienica",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                      ]),
                      Row(children: [
                        if (_editarAgendamento.svHidratacao == "S")
                          const Icon(color: Colors.green, Icons.check),
                        if (_editarAgendamento.svHidratacao == "S")
                          const Text(
                            "Hidratação",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                      ]),
                      Row(children: [
                        if (_editarAgendamento.svPintura == "S")
                          const Icon(color: Colors.green, Icons.check),
                        if (_editarAgendamento.svPintura == "S")
                          const Text(
                            "Pintura",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                      ]),
                      Row(children: [
                        if (_editarAgendamento.svCorteUnha == "S")
                          const Icon(color: Colors.green, Icons.check),
                        if (_editarAgendamento.svCorteUnha == "S")
                          const Text(
                            "Corte Unha",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                      ]),
                      Row(children: [
                        if (_editarAgendamento.svHospedagem == "S")
                          const Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                        if (_editarAgendamento.svHospedagem == "S")
                          const Text(
                            "Hospedagem",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                      ]),
                      Row(children: [
                        if (_editarAgendamento.svTransporte == "S")
                          const Icon(color: Colors.green, Icons.check),
                        if (_editarAgendamento.svTransporte == "S")
                          const Text(
                            "Transporte",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                      ]),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints.tightFor(
                            width: 350,
                          ),
                          child: TextFormField(
                            autofocus: false,
                            controller: observacaoController,
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
                              _agendamentoEditado = true;
                              _editarAgendamento.observacao = text;
                            },
                          ),
                        ),
                      ]),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints.tightFor(
                            width: 200,
                          ),
                          child: TextFormField(
                            keyboardType:
                                const TextInputType.numberWithOptions(),
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
                        height: 5,
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
                                  "R\$ ${_editarAgendamento.valorTotal!.toStringAsFixed(2)}" ??
                                      "",
                                  textAlign: TextAlign.center,
                                  style:
                                      const TextStyle(height: 2, fontSize: 20),
                                ),
                              ),
                            ]),
                      ),
                    ])),
              )),
        ));
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
      return Future.value(true);
    }
  }

  void _SalvarAgendamento() async {
    final gravaAgendamento = _editarAgendamento;
    await info.salvarAgendamento(gravaAgendamento);
    paginaAgendamentos();
  }
}
