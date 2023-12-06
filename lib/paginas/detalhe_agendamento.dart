import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:pet_bosque/funcoes/info_agendamento.dart';
import 'package:pet_bosque/funcoes/info_coloborador.dart';
import 'package:pet_bosque/paginas/lista_agendamentos.dart';
import 'package:pet_bosque/paginas/lista_agendamentosPendentes.dart';
import 'package:pet_bosque/paginas/lista_contato.dart';
import 'package:pet_bosque/paginas/lista_pet.dart';

enum OrderOption { orderaz, orderza }

InfoAgendamento info = InfoAgendamento();
InfoColaborador infoColaborador = InfoColaborador();

class DetalheAgendamentos extends StatefulWidget {
  const DetalheAgendamentos(
      {Key? key, required this.idAgendamento, required this.pendente})
      : super(key: key);

  final String idAgendamento;
  final bool pendente;

  @override
  State<DetalheAgendamentos> createState() => _DetalheAgendamentosState();
}

late Agendamento agendamento = Agendamento();

class _DetalheAgendamentosState extends State<DetalheAgendamentos> {
  List<Colaborador> colaborador = [];
  List<Colaborador> itens = [];
  List<Colaborador> itens2 = [];
  DateTime data = DateTime.now();

  late String status;
  late String idAgendamento;
  late String agendamentoId;
  String nomeColaborador = "Geral";
  String idColaborador = "1";
  String nomeParticipante = "Geral";
  String idParticipante = "1";
  late String valorBanho;
  late String valoradicional;
  late String observacao;
  bool informarPagamento = false;
  String participante = "";
  String nomecolaborador = "";

  paginaContatos() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ListaContatos()),
    );
  }

  paginaPets() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ListaPet()),
    );
  }

  paginaPet() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ListaPet()),
    );
  }

  //FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _obterAgendamentos();
      _obterColaboradores();
    });
  }

  void _alteraPlanoVencido(
    String planoVencido,
    idPet,
  ) {
    infoPet.atualizaPlanoVencidoApi(planoVencido, idPet);
    // db.collection('pet').doc(idPet).update({'planoVencido': planoVencido});
  }

  void _alteraPlanoVencidoAgendamento(idAgendamento, String planoVencido) {
    info.atualizaPlanoVencidoApi(idAgendamento, planoVencido);
    /* db
        .collection('agendamentos')
        .doc(idAgendamento)
        .update({'planoVencido': planoVencido});*/
  }

  void _renovaPlano(contadorPlano, idPet) {
    infoPet.renovaPlanoApi(contadorPlano, idPet);
  }

  Colaborador? selectedValue;
  Colaborador? selectedValue2;

  @override
  Widget build(BuildContext context) {
    agendamentoId = agendamento.id ?? "";
    status = agendamento.status ?? "";
    participante = agendamento.participante ?? "";
    nomeColaborador = agendamento.colaborador ?? "";
    if (agendamento.valorAdicional == null) {
      valoradicional = "0.00";
    } else {
      valoradicional = agendamento.valorAdicional!.toString();
    }
    if (agendamento.observacao == null) {
      observacao = "Sem observação";
    } else {
      observacao = agendamento.observacao.toString();
    }
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/imagens/back_app.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text("Detalhe do Agendamento"),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey[200],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 120.0,
                    height: 120.0,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,

                      // border: Border.all(
                      //   width: 2,
                      //   color: Colors.red,
                      // ),
                    ),
                    child: Image.file(File(agendamento.fotoPet ?? ''),
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset("assets/imagens/pet.png"),
                        fit: BoxFit.cover),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Text(
                        "Data: ",
                        style: TextStyle(
                          color: Color.fromARGB(255, 73, 66, 2),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        agendamento.data ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        "Hora: ",
                        style: TextStyle(
                          color: Color.fromARGB(255, 73, 66, 2),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        agendamento.hora ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const Text(
                        "Cliente: ",
                        style: TextStyle(
                          color: Color.fromARGB(255, 73, 66, 2),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        agendamento.nomeContato ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Icon(
                          color: Color.fromARGB(255, 73, 66, 2), Icons.pets),
                      Text(
                        agendamento.nomePet ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Row(children: [
                    Text(
                      "Serviços: ",
                      style: TextStyle(
                        color: Color.fromARGB(255, 73, 66, 2),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ]),
                  if (agendamento.svBanho == "S")
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                Text(
                                  "Banho",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(height: 2, fontSize: 15),
                                ),
                              ],
                            ),
                            ConstrainedBox(
                              constraints: const BoxConstraints.tightFor(
                                width: 150,
                              ),
                              child: Text(
                                agendamento.valorBanho.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(height: 2, fontSize: 15),
                              ),
                            ),
                          ]),
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (agendamento.svTosa == "S")
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                Text(
                                  "Tosa",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(height: 2, fontSize: 15),
                                ),
                              ],
                            ),
                            ConstrainedBox(
                              constraints: const BoxConstraints.tightFor(
                                width: 150,
                              ),
                              child: Text(
                                agendamento.valorTosa.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(height: 2, fontSize: 15),
                              ),
                            ),
                          ]),
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (agendamento.svTosaHigienica == "S")
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                Text(
                                  "Tosa Higienica",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(height: 2, fontSize: 15),
                                ),
                              ],
                            ),
                            ConstrainedBox(
                              constraints: const BoxConstraints.tightFor(
                                width: 150,
                              ),
                              child: Text(
                                agendamento.valorTosaHigienica.toString() ?? "",
                                textAlign: TextAlign.center,
                                style: const TextStyle(height: 2, fontSize: 15),
                              ),
                            ),
                          ]),
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (agendamento.svCorteUnha == "S")
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                Text(
                                  "Corte de Unha",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(height: 2, fontSize: 15),
                                ),
                              ],
                            ),
                            ConstrainedBox(
                              constraints: const BoxConstraints.tightFor(
                                width: 150,
                              ),
                              child: Text(
                                agendamento.valorCorteUnha.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(height: 2, fontSize: 15),
                              ),
                            ),
                          ]),
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (agendamento.svHidratacao == "S")
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                Text(
                                  "Hidratação",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(height: 2, fontSize: 15),
                                ),
                              ],
                            ),
                            ConstrainedBox(
                              constraints: const BoxConstraints.tightFor(
                                width: 150,
                              ),
                              child: Text(
                                agendamento.valorHidratacao.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(height: 2, fontSize: 15),
                              ),
                            ),
                          ]),
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (agendamento.svPintura == "S")
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                Text(
                                  "Pintura",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(height: 2, fontSize: 15),
                                ),
                              ],
                            ),
                            ConstrainedBox(
                              constraints: const BoxConstraints.tightFor(
                                width: 150,
                              ),
                              child: Text(
                                agendamento.valorPintura.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(height: 2, fontSize: 15),
                              ),
                            ),
                          ]),
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (agendamento.svHospedagem == "S")
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                Text(
                                  "Hospedagem",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(height: 2, fontSize: 15),
                                ),
                              ],
                            ),
                            ConstrainedBox(
                              constraints: const BoxConstraints.tightFor(
                                width: 150,
                              ),
                              child: Text(
                                agendamento.valorHospedagem.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(height: 2, fontSize: 15),
                              ),
                            ),
                          ]),
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (agendamento.svTransporte == "S")
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                Text(
                                  "Transporte",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(height: 2, fontSize: 15),
                                ),
                              ],
                            ),
                            ConstrainedBox(
                              constraints: const BoxConstraints.tightFor(
                                width: 150,
                              ),
                              child: Text(
                                agendamento.valorTransporte.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(height: 2, fontSize: 15),
                              ),
                            ),
                          ]),
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Text(
                                "Adicional",
                                textAlign: TextAlign.center,
                                style: TextStyle(height: 2, fontSize: 15),
                              ),
                            ],
                          ),
                          ConstrainedBox(
                            constraints: const BoxConstraints.tightFor(
                              width: 150,
                            ),
                            child: Text(
                              valoradicional ?? "",
                              textAlign: TextAlign.center,
                              style: const TextStyle(height: 2, fontSize: 20),
                            ),
                          ),
                        ]),
                  ),
                  const SizedBox(
                    height: 5,
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
                              "R\$ ${agendamento.valorTotal}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(height: 2, fontSize: 20),
                            ),
                          ),
                        ]),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Row(children: [
                    Expanded(
                      child: Text(
                        "Observação:",
                        style: TextStyle(
                          color: Color.fromARGB(255, 73, 66, 2),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ]),
                  Row(children: [
                    Flexible(
                      child: Text(
                        observacao ?? "",
                        textAlign: TextAlign.center,
                        style: const TextStyle(height: 2, fontSize: 15),
                      ),
                    )
                  ]),
                  if (agendamento.planoVencido == "S" && status == "Pendente")
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(color: Colors.green, Icons.money),
                                Text(
                                  " Informar Pagamento ",
                                  style: TextStyle(
                                    backgroundColor: Colors.green,
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            ConstrainedBox(
                              constraints: const BoxConstraints.tightFor(
                                width: 150,
                              ),
                              child: Checkbox(
                                  value: informarPagamento,
                                  onChanged: (checked) {
                                    setState(() {
                                      informarPagamento = checked!;
                                    });
                                  }),
                            ),
                          ]),
                    ),
                  Row(children: [
                    const Text(
                      "Colaborador:",
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
                      nomeColaborador,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (status == "Pendente")
                      DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          hint: Text(
                            '  Selecione',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: itens
                              .map((item) => DropdownMenuItem<Colaborador>(
                                    value: item,
                                    child: Text(
                                      item.nomeColaborador.toString(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          value: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as Colaborador;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            height: 40,
                            width: 213,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                          ),
                        ),
                      ),
                  ]),
                  Row(children: [
                    const Text(
                      "Participante:",
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
                      participante,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (status == "Pendente")
                      DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          hint: Text(
                            '  Selecione',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: itens2
                              .map((item) => DropdownMenuItem<Colaborador>(
                                    value: item,
                                    child: Text(
                                      item.nomeColaborador.toString(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          value: selectedValue2,
                          onChanged: (value) {
                            setState(() {
                              selectedValue2 = value as Colaborador;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            height: 40,
                            width: 213,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                          ),
                        ),
                      ),
                  ]),
                  if (status == "Pendente")
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10.0),
                          width: 150,
                          height: 50,
                          child: TextButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(120, 50),
                              backgroundColor: Colors.redAccent,
                              side: const BorderSide(
                                  width: 3, color: Colors.redAccent),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title:
                                          const Text("Cancelar Agendamento?"),
                                      content: const Text(
                                          "Ao clicar em finalizar não sera possivel alterar o status."),
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
                                            status = "Cancelado";
                                            idAgendamento = agendamentoId;
                                            _alterarStatus(idAgendamento,
                                                status, "0", "0", "0", "0");
                                            if (widget.pendente == false) {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ListaAgendamentos(
                                                              data: agendamento
                                                                  .data
                                                                  .toString())));
                                            }
                                            if (widget.pendente == true) {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const ListaAgendamentosPendentes()));
                                            }
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
                            },
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 35,
                        ),
                        Container(
                            margin: const EdgeInsets.all(10.0),
                            width: 150,
                            height: 50,
                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(120, 50),
                                backgroundColor: Colors.blueAccent,
                                side: const BorderSide(
                                    width: 3, color: Colors.blueAccent),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                            "Finalizar Agendamento?"),
                                        content: const Text(
                                            "Ao clicar em finalizar não sera possivel alterar o status."),
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
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              "Não",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              fixedSize: const Size(120, 50),
                                              backgroundColor:
                                                  Colors.blueAccent,
                                              side: const BorderSide(
                                                  width: 3,
                                                  color: Colors.blueAccent),
                                              elevation: 3,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                            onPressed: () {
                                              status = "Finalizado";
                                              idAgendamento = agendamentoId;
                                              if (informarPagamento == true) {
                                                _renovaPlano(
                                                    3, agendamento.idPet);
                                                _alteraPlanoVencido(
                                                  "N",
                                                  agendamento.idPet,
                                                );
                                                _alteraPlanoVencidoAgendamento(
                                                    idAgendamento, "N");
                                              }
                                              _alterarStatus(
                                                  idAgendamento,
                                                  status,
                                                  nomeColaborador,
                                                  idColaborador,
                                                  nomeParticipante,
                                                  idParticipante);
                                              if (selectedValue != null) {
                                                nomeColaborador = selectedValue!
                                                    .nomeColaborador
                                                    .toString();
                                                idColaborador = selectedValue!
                                                    .id
                                                    .toString();
                                              }
                                              if (selectedValue2 != null) {
                                                nomeParticipante =
                                                    selectedValue2!
                                                        .nomeColaborador
                                                        .toString();
                                                idParticipante = selectedValue2!
                                                    .id
                                                    .toString();
                                              }

                                              if (widget.pendente == false) {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ListaAgendamentos(
                                                                data: agendamento
                                                                    .data
                                                                    .toString())));
                                              }
                                              if (widget.pendente == true) {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const ListaAgendamentosPendentes()));
                                              }
                                            },
                                            child: const Text(
                                              "Sim",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: const Text(
                                'Finalizar',
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                      ],
                    ),
                  if (agendamento.status == "Finalizado")
                    Row(
                      children: [
                        const Icon(color: Colors.blue, Icons.check_box),
                        Text(
                          agendamento.status ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  if (agendamento.status == "Cancelado")
                    Row(
                      children: [
                        const Icon(color: Colors.red, Icons.cancel),
                        Text(
                          agendamento.status ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          )),
    );
  }

  void _alterarStatus(String id, String status, String colaborador,
      String idColaborador, String nomeParticipante, String idParticipante) {
    if (selectedValue != null) {
      nomeColaborador = selectedValue!.nomeColaborador.toString();
      idColaborador = selectedValue!.id.toString();
    }
    if (selectedValue2 != null) {
      nomeParticipante = selectedValue2!.nomeColaborador.toString();
      idParticipante = selectedValue2!.id.toString();
    }
    info.atualizarStatusApi(idAgendamento, status, nomeColaborador,
        idColaborador, nomeParticipante, idParticipante);
    /* db.collection('agendamentos').doc(idAgendamento).update({
      'status': status,
      'colaborador': nomeColaborador,
      'idColaborador': idColaborador,
      'participante': nomeParticipante,
      'idParticipante': idParticipante
    });*/
    Navigator.pop(context);
  }

  void _obterAgendamentos() {
    info.obterDetalheAgendamentoApi(widget.idAgendamento).then((dynamic list) {
      setState(() {
        agendamento = list;
      });
    });
  }

  void _obterColaboradores() {
    infoColaborador
        .obterTodosColaboradoresApi()
        .then((dynamic listaColaborador) {
      setState(() {
        itens = listaColaborador;
        itens2 = listaColaborador;
      });
    });
  }
}

//Customizar ListTile do menu
class CustomListTile extends StatelessWidget {
  final IconData icone;
  final String texto;
  final void Function()? onTap;

  //CustomListTile(this.icone, this.texto);
  const CustomListTile({
    super.key,
    required this.icone,
    required this.texto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade400))),
        child: InkWell(
          splashColor: Colors.lightBlue,
          onTap: onTap,
          child: SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(icone),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        texto,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.arrow_right)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
