import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:pet_bosque/funcoes/info_coloborador.dart';
import 'package:pet_bosque/paginas/lista_agendamentosColaborador.dart';
import 'package:pet_bosque/paginas/lista_colaborador.dart';
import 'package:pet_bosque/paginas/lista_contato.dart';
import 'package:pet_bosque/paginas/lista_pet.dart';

import '../funcoes/info_agendamento.dart';

enum OrderOption { orderaz, orderza }

InfoAgendamento info = InfoAgendamento();
InfoColaborador infoColaborador = InfoColaborador();

class DetalheColaborador extends StatefulWidget {
  const DetalheColaborador(
      {Key? key, required this.idColaborador, required this.nome})
      : super(key: key);

  final dynamic idColaborador;
  final String nome;

  @override
  State<DetalheColaborador> createState() => _DetalheColaboradorState();
}

late Colaborador colaborador = Colaborador();

class _DetalheColaboradorState extends State<DetalheColaborador> {
  List<Agendamento> agendamento = [];
  List<Colaborador> itens = [];
  String mesTexto = "Período";
  late DateTime dataInicio;
  late DateTime dataFinal;
  int ultimoDia = 0;
  int qtdAgendamentos = 0;
  double valorAgendamentos = 0;
  double valorAgendamentosParticipante = 0;
  double valorAgendamentosPlano = 0;
  double valorAgendamentosParticipantePlano = 0;
  double valorAgendamentosAvulso = 0;
  double valorAgendamentosParticipanteAvulso = 0;
  double valorComissaoPlano = 0;
  double valorComissaoAvulso = 0;
  double totalPagar = 0;
  double valorComissaoParticipanteAvulso = 0;
  double porcentComissao = 0;
  double porcentComissaoParticipante = 0;
  DateTime dataAtual = DateTime.now();
  late int mes;
  int vCarregando = 0;
  bool carregando = true;
  //FirebaseFirestore db = FirebaseFirestore.instance;
  String? mesSelecionado;
  List listaTotal = [];

  var meses = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _excutaFuncoes();

      dataInicio = DateTime(dataAtual.year, dataAtual.month, 01);
      mes = dataAtual.month;
      ultimoDia = DateTime(dataAtual.year, mes + 1, 0).day;
      dataFinal = DateTime(dataAtual.year, dataAtual.month, ultimoDia);
      switch (mes) {
        case 1:
          mesTexto = 'Janeiro';
          break;
        case 2:
          mesTexto = 'Fevereiro';
          break;
        case 3:
          mesTexto = 'Março';
          break;
        case 4:
          mesTexto = 'Abril';
          break;
        case 5:
          mesTexto = 'Maio';
          break;
        case 6:
          mesTexto = 'Junho';
          break;
        case 7:
          mesTexto = 'Julho';
          break;
        case 8:
          mesTexto = 'Agosto';
          break;
        case 9:
          mesTexto = 'Setembro';
          break;
        case 10:
          mesTexto = 'Outubro';
          break;
        case 11:
          mesTexto = 'Novembro';
          break;
        case 12:
          mesTexto = 'Dezembro';
          break;
        default:
          print('choose a different number!');
      }
    });
  }

  void _excutaFuncoes() async {
    await _obterColaboradores();
    await _obterQuantidadeAgendamentos(
        widget.idColaborador, dataInicio, dataFinal);
    await _totalAgendamentosAvulso(widget.idColaborador, dataInicio, dataFinal);
    await _totalAgendamentosColaborador(
        widget.idColaborador, dataInicio, dataFinal);
    _totalAgendamentosParticipanteAvulso(widget.idColaborador);

    carregando = false;
  }

  Colaborador? selectedValue;

  @override
  Widget build(BuildContext context) {
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
            leading: BackButton(onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ListaColaborador()));
            }),
            title: Text(
              widget.nome ?? "",
              style: const TextStyle(
                color: Color.fromARGB(255, 73, 66, 2),
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            actions: <Widget>[
              DropdownButtonHideUnderline(
                child: DropdownButton2(
                  value: mesSelecionado,
                  hint: Text(
                    mesTexto,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  items: meses.map((String items) {
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
                    mesSelecionado = newValue!;
                    switch (mesSelecionado!) {
                      case 'Janeiro':
                        mes = 01;
                        ultimoDia = DateTime(dataAtual.year, mes + 1, 0).day;
                        dataFinal = DateTime(dataAtual.year, mes, ultimoDia);
                        dataInicio = DateTime(dataAtual.year, mes, 01);
                        break;
                      case 'Fevereiro':
                        mes = 02;
                        ultimoDia = DateTime(dataAtual.year, mes + 1, 0).day;
                        dataFinal = DateTime(dataAtual.year, mes, ultimoDia);
                        dataInicio = DateTime(dataAtual.year, mes, 01);
                        break;
                      case 'Março':
                        mes = 03;
                        ultimoDia = DateTime(dataAtual.year, mes + 1, 0).day;
                        dataFinal = DateTime(dataAtual.year, mes, ultimoDia);
                        dataInicio = DateTime(dataAtual.year, mes, 01);
                        break;
                      case 'Abril':
                        mes = 04;
                        ultimoDia = DateTime(dataAtual.year, mes + 1, 0).day;
                        dataFinal = DateTime(dataAtual.year, mes, ultimoDia);
                        dataInicio = DateTime(dataAtual.year, mes, 01);
                        break;
                      case 'Maio':
                        mes = 05;
                        ultimoDia = DateTime(dataAtual.year, mes + 1, 0).day;
                        dataFinal = DateTime(dataAtual.year, mes, ultimoDia);
                        dataInicio = DateTime(dataAtual.year, mes, 01);
                        break;
                      case 'Junho':
                        mes = 06;
                        ultimoDia = DateTime(dataAtual.year, mes + 1, 0).day;
                        dataFinal = DateTime(dataAtual.year, mes, ultimoDia);
                        dataInicio = DateTime(dataAtual.year, mes, 01);
                        break;
                      case 'Julho':
                        mes = 07;
                        ultimoDia = DateTime(dataAtual.year, mes + 1, 0).day;
                        dataFinal = DateTime(dataAtual.year, mes, ultimoDia);
                        dataInicio = DateTime(dataAtual.year, mes, 01);
                        break;
                      case 'Agosto':
                        mes = 08;
                        ultimoDia = DateTime(dataAtual.year, mes + 1, 0).day;
                        dataFinal = DateTime(dataAtual.year, mes, ultimoDia);
                        dataInicio = DateTime(dataAtual.year, mes, 01);
                        break;
                      case 'Setembro':
                        mes = 09;
                        ultimoDia = DateTime(dataAtual.year, mes + 1, 0).day;
                        dataFinal = DateTime(dataAtual.year, mes, ultimoDia);
                        dataInicio = DateTime(dataAtual.year, mes, 01);
                        break;
                      case 'Outubro':
                        mes = 10;
                        ultimoDia = DateTime(dataAtual.year, mes + 1, 0).day;
                        dataFinal = DateTime(dataAtual.year, mes, ultimoDia);
                        dataInicio = DateTime(dataAtual.year, mes, 01);
                        break;
                      case 'Novembro':
                        mes = 11;
                        ultimoDia = DateTime(dataAtual.year, mes + 1, 0).day;
                        dataFinal = DateTime(dataAtual.year, mes, ultimoDia);
                        dataInicio = DateTime(dataAtual.year, mes, 01);
                        break;
                      case 'Dezembro':
                        mes = 12;
                        ultimoDia = DateTime(dataAtual.year, mes + 1, 0).day;
                        dataFinal = DateTime(dataAtual.year, mes, ultimoDia);
                        dataInicio = DateTime(dataAtual.year, mes, 01);
                        break;
                    }
                    setState(() {
                      _totalAgendamentosColaborador(
                          widget.idColaborador, dataInicio, dataFinal);
                      _totalAgendamentosAvulso(
                          widget.idColaborador, dataInicio, dataFinal);
                      _obterQuantidadeAgendamentos(
                          widget.idColaborador, dataInicio, dataFinal);
                    });
                  },
                ),
              )
            ]),
        body: !carregando
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: const Color.fromRGBO(204, 236, 247, 100),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            mesSelecionado ?? mesTexto.toString(),
                            style: const TextStyle(
                              color: Color.fromARGB(255, 73, 66, 2),
                              fontSize: 24,
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
                            "Nome: ",
                            style: TextStyle(
                              color: Color.fromARGB(255, 73, 66, 2),
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            colaborador.nomeColaborador ?? "",
                            style: const TextStyle(
                              fontSize: 24,
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
                            "Função: ",
                            style: TextStyle(
                              color: Color.fromARGB(255, 73, 66, 2),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            colaborador.funcao ?? "",
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
                      Row(children: [
                        const Text(
                          "Quantidade de Agendamentos:",
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
                          "$qtdAgendamentos",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.list),
                          color: Colors.blue,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ListaAgendamentosColaborador(
                                      idColaborador: colaborador.id!,
                                      taxaComissao: porcentComissao,
                                      dataInicial: dataInicio,
                                      dataFinal: dataFinal,
                                    )));
                          },
                        ),
                      ]),
                      Row(children: [
                        const Text(
                          "Valor total Agendamentos:",
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
                          "R\$ ${valorAgendamentos.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ]),
                      Row(children: [
                        const Text(
                          "Valor total Participações:",
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
                          "R\$ ${valorAgendamentosParticipante.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ]),
                      Row(children: [
                        const Text(
                          "Taxa Comissão: %",
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
                          colaborador.porcenComissao.toString() ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ]),
                      Row(children: [
                        const Text(
                          "Taxa Participante: %",
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
                          colaborador.porcenParticipante.toString() ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ]),
                      Row(children: [
                        const Text(
                          "Meta Comissão: R\$",
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
                          colaborador.metaComissao!.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ]),
                      const Divider(
                        color: Colors.black,
                        height: 10,
                      ),
                      const Row(children: [
                        Text(
                          "Comissão Plano:",
                          style: TextStyle(
                            color: Color.fromARGB(255, 73, 66, 2),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ]),
                      Container(
                        color: const Color.fromARGB(255, 228, 222, 222),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Principal:",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 73, 66, 2),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              ConstrainedBox(
                                constraints: const BoxConstraints.tightFor(
                                  width: 80,
                                ),
                                child: Text(
                                  "R\$ ${valorComissaoPlano!.toStringAsFixed(2)}" ??
                                      "",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            ]),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Participante:",
                              style: TextStyle(
                                color: Color.fromARGB(255, 73, 66, 2),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            ConstrainedBox(
                              constraints: const BoxConstraints.tightFor(
                                width: 80,
                              ),
                              child: Text(
                                "R\$ ${valorComissaoParticipanteAvulso!.toStringAsFixed(2)}" ??
                                    "",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ]),
                      const Divider(
                        color: Colors.black,
                        height: 10,
                      ),
                      const Row(children: [
                        Text(
                          "Comissão Avulso:",
                          style: TextStyle(
                            color: Color.fromARGB(255, 73, 66, 2),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ]),
                      Container(
                        color: const Color.fromARGB(255, 228, 222, 222),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Principal:",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 73, 66, 2),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              ConstrainedBox(
                                constraints: const BoxConstraints.tightFor(
                                  width: 80,
                                ),
                                child: Text(
                                  "R\$ ${valorComissaoAvulso!.toStringAsFixed(2)}" ??
                                      "",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            ]),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Participante:",
                              style: TextStyle(
                                color: Color.fromARGB(255, 73, 66, 2),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            ConstrainedBox(
                              constraints: const BoxConstraints.tightFor(
                                width: 80,
                              ),
                              child: Text(
                                "R\$ ${valorComissaoParticipanteAvulso!.toStringAsFixed(2)}" ??
                                    "",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ]),
                      const Divider(
                        color: Colors.black,
                        height: 10,
                      ),
                      Container(
                        color: const Color.fromARGB(255, 228, 222, 222),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total a pagar:",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 73, 66, 2),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              ConstrainedBox(
                                constraints: const BoxConstraints.tightFor(
                                  width: 90,
                                ),
                                child: Text(
                                  "R\$ ${totalPagar!.toStringAsFixed(2)}" ?? "",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            ]),
                      ),
                    ],
                  ),
                ))
            : Center(
                child: CircularProgressIndicator(
                  color: Colors.greenAccent,
                  backgroundColor: Colors.grey,
                ),
              ),
      ),
    );
  }

  Future _obterQuantidadeAgendamentos(
      String id, DateTime dataInicio, DateTime dataFinal) async {
    await info
        .quantidadeAgendamentosColaboradorApi(
            widget.idColaborador, dataInicio, dataFinal)
        .then((dynamic qtd) {
      setState(() {
        if (qtd['COUNT(*)'] != null) {
          qtdAgendamentos = int.parse(qtd['COUNT(*)']);
        }
      });
    });
  }

  Future _totalAgendamentosColaborador(
      String id, DateTime dataInicio, DateTime dataFinal) async {
    await info
        .totalAgendamentosColaboradorPlanoApi(
            widget.idColaborador, dataInicio, dataFinal)
        .then((dynamic result2) {
      setState(() {
        if (result2 != null && result2['total'] != null) {
          valorAgendamentosPlano = (double.parse((result2['total'])) / 4);
          valorComissaoPlano = (valorAgendamentosPlano * porcentComissao / 100);
          totalPagar = (valorComissaoPlano + valorComissaoAvulso);
          valorAgendamentos =
              valorAgendamentosAvulso + (valorAgendamentosPlano * 4);
        } else {
          valorAgendamentosPlano = 0;
          valorComissaoPlano = (valorAgendamentosPlano * porcentComissao / 100);
          totalPagar = (valorComissaoPlano + valorComissaoAvulso);
          valorAgendamentos =
              valorAgendamentosAvulso + (valorAgendamentosPlano * 4);
        }
      });
    });
  }

  Future _totalAgendamentosAvulso(
      String id, DateTime dataInicio, DateTime dataFinal) async {
    await info
        .totalAgendamentosColaboradorAvulsoApi(
            widget.idColaborador, dataInicio, dataFinal)
        .then((dynamic result) {
      setState(() {
        if (result != null && result['total'] != null) {
          valorAgendamentosAvulso = double.parse(result['total'].toString());
          valorComissaoAvulso =
              (valorAgendamentosAvulso * porcentComissao / 100);
          totalPagar = (valorComissaoPlano + valorComissaoAvulso);
          valorAgendamentos =
              valorAgendamentosAvulso + (valorAgendamentosPlano * 4);
        } else {
          valorAgendamentosAvulso = 0;
          valorComissaoAvulso =
              (valorAgendamentosAvulso * porcentComissao / 100);
          totalPagar = (valorComissaoPlano + valorComissaoAvulso);
          valorAgendamentos =
              valorAgendamentosAvulso + (valorAgendamentosPlano * 4);
        }
      });
    });
  }

  Future _totalAgendamentosParticipanteAvulso(String id) async {
    /* QuerySnapshot query = (await db
        .collection("agendamentos")
        .where('idParticipante', isEqualTo: id)
        .where('planoVencido', isEqualTo: 'P')
        .get());
    valorAgendamentosParticipanteAvulso = 0;
    query.docs.forEach((doc) {
      valorAgendamentosParticipanteAvulso =
          doc.get("valorTotal") + valorAgendamentosParticipanteAvulso;
    });
    valorComissaoParticipanteAvulso = (valorAgendamentosParticipanteAvulso *
        porcentComissaoParticipante /
        100);
    valorAgendamentosParticipante = (valorAgendamentosParticipantePlano +
        valorAgendamentosParticipanteAvulso);
    totalPagar = (valorComissaoAvulso + valorComissaoParticipanteAvulso);*/
  }

  Future _obterColaboradores() async {
    await infoColaborador
        .obterDadosColaboradorApi(widget.idColaborador)
        .then((dynamic listaColaborador) {
      setState(() {
        colaborador = listaColaborador;
        porcentComissao = double.parse(colaborador.porcenComissao) ?? 0;
        porcentComissaoParticipante =
            double.parse(colaborador.porcenParticipante) ?? 0;
        //vCarregando = vCarregando + 1;
      });
    });
  }
}

//Customizar ListTile do menu
