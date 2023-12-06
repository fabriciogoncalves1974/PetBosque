//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_bosque/funcoes/info_agendamento.dart';
import 'package:pet_bosque/funcoes/info_pet.dart';
import 'package:pet_bosque/funcoes/info_plano.dart';
import 'package:pet_bosque/paginas/lista_agendamentos.dart';
import 'package:pet_bosque/paginas/lista_pet.dart';
import 'package:pet_bosque/paginas/novo_agendamento.dart';

class NovoAgendamentoPlano extends StatefulWidget {
  final Agendamento _agendamento;

  var contaPlano;
  NovoAgendamentoPlano(
      {super.key,
      Agendamento? agendamento,
      required this.fotoPet,
      required this.idPet,
      required this.nomePet,
      required this.contaPlano,
      required this.nomeContato,
      required this.renovaPlano,
      required this.idPlano})
      : _agendamento = agendamento ?? Agendamento();

  late String fotoPet;
  late String nomeContato;
  late String nomePet;
  late String idPet;
  late String idPlano;
  late String renovaPlano;
  String status = "Pendente";

  @override
  _NovoAgendamentoPlanoState createState() => _NovoAgendamentoPlanoState();
}

Plano? itens;
String data = DateFormat("yyyy-MM-dd").format(DateTime.now());
InfoAgendamento info = InfoAgendamento();
InfoPlano infoPlano = InfoPlano();
InfoPet infoPet = InfoPet();
double? valorPlano = 0;
double valorAdicional = 0;
double valorTotal = 0;

class _NovoAgendamentoPlanoState extends State<NovoAgendamentoPlano> {
  TextEditingController valorAdicionalController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final Agendamento _novoAgendamento = Agendamento();

  bool _agendamentoEditado = false;

  late String _dataAgendamento;
  late int contadorPlano;
  String planoVencido = "N";
  bool loading = false;
  //FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _obterPlanos();
      _novoAgendamento.nomeContato = widget.nomeContato;
      _novoAgendamento.nomePet = widget.nomePet;
      _novoAgendamento.fotoPet = widget.fotoPet;
      _novoAgendamento.idPet = widget.idPet;
      contadorPlano = int.parse(widget.contaPlano);
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
        _dateTime = _dateTime;
        _dateTime = value;
      });
    });
  }

  late TimeOfDay picked;
  late String hora;

  void _executaFuncoes() {
    verificaNull();
    _total();

    if (contadorPlano != 0) {
      _contadorPLano();
    }
  }

  void _contadorPLano() {
    if (widget.renovaPlano == "S") {
      contadorPlano = 4;
    }
    contadorPlano = (contadorPlano - 1);
    infoPet.contaPlanoPetApi(
      contadorPlano,
      widget.idPet,
    );
    /* db
        .collection('pet')
        .doc(widget.idPet)
        .update({'contaPlano': contadorPlano});*/
  }

  void _total() {
    setState(() {
      valorAdicional = double.tryParse(valorAdicionalController.text) ?? 0;
      valorPlano = double.tryParse(itens?.valor) ?? 0;

      valorTotal = (valorPlano! + valorAdicional);

      _novoAgendamento.valorTotal = valorTotal;
      _novoAgendamento.data = DateFormat("yyyy-MM-dd").format(_dateTime);
      _novoAgendamento.hora = _time.format(context);
      _novoAgendamento.status = status;
      if (itens?.svBanho.toString() == "S") {
        _novoAgendamento.svBanho = "S";
        _novoAgendamento.valorBanho = 0;
      }
      if (itens?.svTosa.toString() == "S") {
        _novoAgendamento.svTosa = "S";
        _novoAgendamento.valorTosa = 0;
      }
      if (itens?.svTosaHigienica.toString() == "S") {
        _novoAgendamento.svTosaHigienica = "S";
        _novoAgendamento.valorTosaHigienica = 0;
      }
      if (itens?.svHidratacao.toString() == "S") {
        _novoAgendamento.svHidratacao = "S";
        _novoAgendamento.valorHidratacao = 0;
      }
      if (itens?.svPintura.toString() == "S") {
        _novoAgendamento.svPintura = "S";
        _novoAgendamento.valorPintura = 0;
      }
      if (itens?.svCorteUnha.toString() == "S") {
        _novoAgendamento.svCorteUnha = "S";
        _novoAgendamento.valorCorteUnha = 0;
      }
      if (itens?.svTransporte.toString() == "S") {
        _novoAgendamento.svTransporte = "S";
        _novoAgendamento.valorTransporte = 0;
      }
      if (itens?.svHospedagem.toString() == "S") {
        _novoAgendamento.svHospedagem = "S";
        _novoAgendamento.valorHospedagem = 0;
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
                        builder: (context) => const ListaPet()));
                  }
                  _retornaPop(context);
                }),
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  loading = true;
                  if (loading = true) {
                    const Center(
                      child: CircularProgressIndicator(
                        color: Colors.greenAccent,
                        backgroundColor: Colors.grey,
                      ),
                    );
                  }
                  String idPet = widget.idPet;
                  _novoAgendamento.planoVencido = planoVencido;
                  if (widget.idPlano != "" &&
                      contadorPlano == 0 &&
                      widget.renovaPlano == "N") {
                    planoVencido = "S";
                    _novoAgendamento.planoVencido = planoVencido;
                    _alteraPlanoVencido(planoVencido, idPet);
                  }
                  if (widget.renovaPlano == "S") {
                    planoVencido = "N";
                    _contadorPLano();
                    _renovaPlano(contadorPlano, widget.idPet);
                    _alteraPlanoVencido(planoVencido, idPet);
                  }
                  //info.salvarAgendamento(_novoAgendamento);
                  //salvaAdendamentoFirestore();
                  _executaFuncoes();
                  _novoAgendamento.valorAdicional ??= 0;
                  _novoAgendamento.observacao ??= "";
                  info.salvarAgendamentoApi(_novoAgendamento);
                  loading = false;
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
                label: const Text("Salvar"),
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
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Text(
                            "Plano: ",
                            style: TextStyle(
                              color: Color.fromARGB(255, 73, 66, 2),
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            itens?.nomePlano.toString() ?? "",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ],
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
                            itens?.valor.toString() ?? "",
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
                        if (itens?.svBanho.toString() == "S")
                          const Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                        if (itens?.svBanho.toString() == "S")
                          const Text(
                            "Banho",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                      ]),
                      Row(children: [
                        if (itens?.svTosa.toString() == "S")
                          const Icon(color: Colors.green, Icons.check),
                        if (itens?.svTosa == "S")
                          const Text(
                            "Tosa",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                      ]),
                      Row(children: [
                        if (itens?.svTosaHigienica.toString() == "S")
                          const Icon(color: Colors.green, Icons.check),
                        if (itens?.svTosaHigienica == "S")
                          const Text(
                            "Tosa Higienica",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                      ]),
                      Row(children: [
                        if (itens?.svHidratacao.toString() == "S")
                          const Icon(color: Colors.green, Icons.check),
                        if (itens?.svHidratacao == "S")
                          const Text(
                            "Hidratação",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                      ]),
                      Row(children: [
                        if (itens?.svPintura.toString() == "S")
                          const Icon(color: Colors.green, Icons.check),
                        if (itens?.svPintura == "S")
                          const Text(
                            "Pintura",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                      ]),
                      Row(children: [
                        if (itens?.svCorteUnha.toString() == "S")
                          const Icon(color: Colors.green, Icons.check),
                        if (itens?.svCorteUnha.toString() == "S")
                          const Text(
                            "Corte Unha",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                      ]),
                      Row(children: [
                        if (itens?.svHospedagem.toString() == "S")
                          const Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                        if (itens?.svHospedagem.toString() == "S")
                          const Text(
                            "Hospedagem",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                      ]),
                      Row(children: [
                        if (itens?.svTransporte.toString() == "S")
                          const Icon(color: Colors.green, Icons.check),
                        if (itens?.svTransporte.toString() == "S")
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
                              _novoAgendamento.observacao = text;
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
                              _novoAgendamento.valorAdicional =
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
                                  valorTotal.toString(),
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
      return Future.value(true);
    }
  }

  void _SalvarAgendamento() async {
    final gravaAgendamento = _novoAgendamento;
    await info.salvarAgendamentoApi(gravaAgendamento);
    paginaAgendamentos();
  }

  void salvaAgendamentoFirestore() {
    /*
                  String id = Uuid().v1();
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
  }

  void _alteraPlanoVencido(planoVencido, id) {
    infoPet.atualizaPlanoVencidoApi(planoVencido, id);
    /* db
        .collection('pet')
        .doc(widget.idPet)
        .update({'planoVencido': planoVencido});*/
  }

  void _renovaPlano(id, contadorPlano) {
    infoPet.renovaPlanoApi(id, contadorPlano);
    /* db
        .collection('pet')
        .doc(widget.idPet)
        .update({'contaPlano': contadorPlano});*/
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

  void _obterPlanos() async {
    infoPlano.obterPlanosPetApi(widget.idPlano).then((Plano? plano) {
      setState(() {
        itens = plano!;
        valorTotal = double.parse(itens!.valor);
      });
    });
  }
}
