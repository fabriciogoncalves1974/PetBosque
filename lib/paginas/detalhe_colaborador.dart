import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:pet_bosque/funcoes/info_coloborador.dart';
import 'package:pet_bosque/paginas/lista_agendamentosColaborador.dart';
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

  final int idColaborador;
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
  double valorAgendamentosPlano = 0;
  double valorAgendamentosAvulso = 0;
  double valorComissao = 0;
  double valorComissaoAvulso = 0;
  late double porcentComissao;
  late int mes;

  String? mesSelecionado;

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
    final dataAtual = DateTime.now();

    dataInicio = DateTime(dataAtual.year, dataAtual.month, 01);
    mes = dataAtual.month;
    ultimoDia = DateTime(dataAtual.year, dataAtual.month + 1, 0).day;
    dataFinal = DateTime(dataAtual.year, dataAtual.month, ultimoDia);
    print(dataInicio);
    print(ultimoDia);
    print(dataFinal);
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
      default:
        print('choose a different number!');
    }
    _obterColaboradores();
    _obterQuantidadeAgendamentos(int);
    _totalAgendamentosColaborador(int);
    _totalAgendamentosAvulso(int);
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
            title: Text(
              widget.nome ?? "",
              style: TextStyle(
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
                "Valor Total:",
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
                "R\$ " + valorAgendamentos.toStringAsFixed(2),
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
            Row(children: [
              const Text(
                "Comissão Plano: R\$",
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
                valorComissao!.toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ]),
            Row(children: [
              const Text(
                "Comissão Avulso: R\$",
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
                valorComissaoAvulso!.toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  void _obterQuantidadeAgendamentos(int) {
    info.quantidadeAgendamentosColaborador(
        int.parse(widget.idColaborador).then((dynamic result) {
      setState(() {
        qtdAgendamentos = result;
      });
    }));
  }

  void _totalAgendamentosColaborador(int) {
    info.totalAgendamentosColaborador(
        int.parse(widget.idColaborador).then((dynamic result2) {
      setState(() {
        if (result2[0]['total'] != null) {
          valorAgendamentosPlano = (result2[0]['total'] * 25 / 100);
        }
        valorComissao = (valorAgendamentosPlano * porcentComissao / 100);
        valorAgendamentos = (valorComissao + valorComissaoAvulso);
      });
    }));
  }

  void _totalAgendamentosAvulso(int) {
    info.totalAgendamentosColaboradorAvulso(
        int.parse(widget.idColaborador).then((dynamic result2) {
      setState(() {
        if (result2[0]['total'] != null) {
          valorAgendamentosAvulso = result2[0]['total'];
        }
        valorComissaoAvulso = (valorAgendamentosAvulso * porcentComissao / 100);
        valorAgendamentos = (valorComissao + valorComissaoAvulso);
      });
    }));
  }

  void _obterColaboradores() {
    infoColaborador
        .obterDadosColaborador(widget.idColaborador)
        .then((dynamic listaColaborador) {
      setState(() {
        colaborador = listaColaborador;
        porcentComissao = colaborador[0].porcenComissao as double;
      });
    });
  }
}

//Customizar ListTile do menu
