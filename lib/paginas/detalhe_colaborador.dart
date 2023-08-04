import 'package:cloud_firestore/cloud_firestore.dart';
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

class _DetalheColaboradorState extends State<DetalheColaborador> {
  List<Agendamento> agendamento = [];
  List<Colaborador> colaborador = [];
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
  double valorComissao = 0;
  double valorComissaoAvulso = 0;
  double totalPagar = 0;
  double valorComissaoParticipanteAvulso = 0;
  double porcentComissao = 0;
  double porcentComissaoParticipante = 0;
  late int mes;
  FirebaseFirestore db = FirebaseFirestore.instance;
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

      final dataAtual = DateTime.now();

      dataInicio = DateTime(dataAtual.year, dataAtual.month, 01);
      mes = dataAtual.month;
      ultimoDia = DateTime(dataAtual.year, dataAtual.month + 1, 0).day;
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

  void _excutaFuncoes() {
    _obterColaboradores();
    _obterQuantidadeAgendamentos(widget.idColaborador);
    _totalAgendamentosAvulso(widget.idColaborador);
    _totalAgendamentosColaborador(widget.idColaborador);
    _totalAgendamentosParticipanteAvulso(widget.idColaborador);
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
                    setState(() {
                      mesSelecionado = newValue!;
                    });
                  },
                ),
              )
            ]),
        body: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _detalhes(context, index);
                },
                childCount: colaborador.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detalhes(BuildContext context, int index) {
    //qtdAgendamentos = int.parse(colaborador.length.toString());
    return Padding(
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
                  colaborador[index].nomeColaborador ?? "",
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
                  colaborador[index].funcao ?? "",
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
                      builder: (context) => ListaAgendamentosColaborador(
                            idColaborador: colaborador[index].id!,
                            taxaComissao: porcentComissao,
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
                colaborador[index].porcenComissao.toString() ?? "",
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
                colaborador[index].porcenParticipante.toString() ?? "",
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
                colaborador[index].metaComissao!.toStringAsFixed(2),
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
                        "R\$ ${valorComissao!.toStringAsFixed(2)}" ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ]),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                  "R\$ ${valorComissao!.toStringAsFixed(2)}" ?? "",
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
                        "R\$ ${valorComissaoAvulso!.toStringAsFixed(2)}" ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ]),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                          fontSize: 24,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Future _obterQuantidadeAgendamentos(String id) async {
    await db
        .collection("agendamentos")
        .where('idColaborador', isEqualTo: id)
        .count()
        .get()
        .then(
          (res) => qtdAgendamentos = res.count,
        );
  }

  Future _totalAgendamentosColaborador(String id) async {
    QuerySnapshot query = (await db
        .collection("agendamentos")
        .where('idColaborador', isEqualTo: id)
        .where('planoVencido', isEqualTo: 'N')
        .get());
    valorAgendamentosPlano = 0;
    query.docs.forEach((doc) {
      valorAgendamentosPlano =
          (doc.get("valorTotal") * 25 / 100) + valorAgendamentosPlano;
    });
    valorComissao = (valorAgendamentosPlano * porcentComissao / 100);
    valorAgendamentos = (valorAgendamentosPlano + valorAgendamentosAvulso);
    /*info.totalAgendamentosColaborador(
        int.parse(widget.idColaborador).then((dynamic result2) {
      setState(() {
        if (result2[0]['total'] != null) {
          valorAgendamentosPlano = (result2[0]['total'] * 25 / 100);
        }
        valorComissao = (valorAgendamentosPlano * porcentComissao / 100);
        valorAgendamentos = (valorComissao + valorComissaoAvulso);
      });
    }));*/
  }

  Future _totalAgendamentosAvulso(String id) async {
    QuerySnapshot query = (await db
        .collection("agendamentos")
        .where('idColaborador', isEqualTo: id)
        .where('planoVencido', isEqualTo: 'P')
        .get());
    valorAgendamentosAvulso = 0;
    query.docs.forEach((doc) {
      valorAgendamentosAvulso = doc.get("valorTotal") + valorAgendamentosAvulso;
    });
    valorComissaoAvulso = (valorAgendamentosAvulso * porcentComissao / 100);
    valorAgendamentos = (valorAgendamentosPlano + valorAgendamentosAvulso);
    totalPagar = (valorComissaoAvulso + valorComissaoParticipanteAvulso);
/*
    info.totalAgendamentosColaboradorAvulso(
        int.parse(widget.idColaborador).then((dynamic result2) {
      setState(() {
        if (result2[0]['total'] != null) {
          valorAgendamentosAvulso = result2[0]['total'];
        }
        valorComissaoAvulso = (valorAgendamentosAvulso * porcentComissao / 100);
        valorAgendamentos = (valorComissao + valorComissaoAvulso);
      });
    }));*/
  }

  Future _totalAgendamentosParticipanteAvulso(String id) async {
    QuerySnapshot query = (await db
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
    totalPagar = (valorComissaoAvulso + valorComissaoParticipanteAvulso);
/*
    info.totalAgendamentosColaboradorAvulso(
        int.parse(widget.idColaborador).then((dynamic result2) {
      setState(() {
        if (result2[0]['total'] != null) {
          valorAgendamentosAvulso = result2[0]['total'];
        }
        valorComissaoAvulso = (valorAgendamentosAvulso * porcentComissao / 100);
        valorAgendamentos = (valorComissao + valorComissaoAvulso);
      });
    }));*/
  }

  Future _obterColaboradores() async {
    await infoColaborador
        .obterDadosColaboradorFirestore(widget.idColaborador)
        .then((dynamic listaColaborador) {
      setState(() {
        colaborador = listaColaborador;
        porcentComissao = colaborador[0].porcenComissao as double;
        porcentComissaoParticipante =
            colaborador[0].porcenParticipante as double;
      });
    });
  }
}

//Customizar ListTile do menu
