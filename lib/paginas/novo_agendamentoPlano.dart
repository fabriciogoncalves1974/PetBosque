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
String data = DateFormat("dd/MM/yyyy").format(DateTime.now());
InfoAgendamento info = InfoAgendamento();
InfoPlano infoPlano = InfoPlano();
InfoPet infoPet = InfoPet();

class _NovoAgendamentoPlanoState extends State<NovoAgendamentoPlano> {
  TextEditingController valorAdicionalController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final Agendamento _novoAgendamento = Agendamento();

  bool _agendamentoEditado = false;

  late String _dataAgendamento;
  late int contadorPlano;
  String planoVencido = "N";

  @override
  void initState() {
    super.initState();
    _obterPlanos();
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
    infoPet.contaPlanoPet(widget.idPet, contadorPlano);
  }

  void _total() {
    setState(() {
      double valorAdicional =
          double.tryParse(valorAdicionalController.text) ?? 0;
      //double? valorPlano = itens?.valor ?? 0;

      //double valorTotal = (valorPlano + valorAdicional);

      // _novoAgendamento.valorTotal = valorTotal;
      _novoAgendamento.data = DateFormat("dd/MM/yyyy").format(_dateTime);
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
                  int idPet = int.parse(widget.idPet);
                  _novoAgendamento.planoVencido = planoVencido;
                  if (widget.idPlano != 0 &&
                      contadorPlano == 0 &&
                      widget.renovaPlano == "N") {
                    planoVencido = "S";
                    _novoAgendamento.planoVencido = planoVencido;
                    _alteraPlanoVencido(idPet, planoVencido);
                  }
                  if (widget.renovaPlano == "S") {
                    planoVencido = "N";
                    _contadorPLano();
                    _renovaPlano(int.parse(widget.idPet), contadorPlano);
                    _alteraPlanoVencido(idPet, planoVencido);
                  }
                  info.salvarAgendamento(_novoAgendamento);

                  _executaFuncoes();
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
                            "Valor: ",
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
                            },
                          ),
                        ),
                      ]),
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
    await info.salvarAgendamento(gravaAgendamento);
    paginaAgendamentos();
  }

  void _alteraPlanoVencido(int id, String planoVencido) {
    infoPet.atualizaPlanoVencido(id, planoVencido);
  }

  void _renovaPlano(int id, int contadorPlano) {
    infoPet.renovaPlano(id, contadorPlano);
  }

  void _obterPlanos() async {
    infoPlano
        .obterPlanosPet2(int.parse(widget.idPlano))
        .then((dynamic listaPlano) {
      setState(() {
        itens = listaPlano[0]!;
      });
    });
  }
}
