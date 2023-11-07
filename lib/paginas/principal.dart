import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pet_bosque/funcoes/info_agendamento.dart';
import 'package:pet_bosque/funcoes/info_hospedagem.dart';
import 'package:pet_bosque/paginas/inicio.dart';
import 'package:pet_bosque/paginas/lista_agendamentos.dart';
import 'package:pet_bosque/paginas/lista_agendamentosPendentes.dart';
import 'package:pet_bosque/paginas/lista_colaborador.dart';
import 'package:pet_bosque/paginas/lista_contato.dart';
import 'package:pet_bosque/paginas/lista_hospedagem.dart';
import 'package:pet_bosque/paginas/lista_hospedagemDia.dart';
import 'package:pet_bosque/paginas/lista_pet.dart';
import 'package:pet_bosque/paginas/lista_planos.dart';

InfoAgendamento info = InfoAgendamento();
InfoHospedagem infoHospedagem = InfoHospedagem();

class Principal extends StatefulWidget {
  const Principal({Key? key}) : super(key: key);

  @override
  _PrincipalState createState() => _PrincipalState();
}

DateTime now = DateTime.now();
String formattedDate = DateFormat.yMMMMEEEEd().format(DateTime.now());

class _PrincipalState extends State<Principal> {
  List<Agendamento> agendamento = [];
  List<Hospedagem> hospedagem = [];
  String contatoPrimeiroAgendamento = "";
  String petPrimeiroAgendamento = "";
  String horaPrimeiroAgendamento = "";
  String contatoPrimeiroHospedagem = "";
  String petPrimeiroHospedagem = "";
  String horaPrimeiroHospedagem = "";
  String statusHospedagem = 'Pendente';
  final String data = DateFormat("dd/MM/yyyy").format(DateTime.now());
  String dataAgendamento = DateFormat("dd/MM/yyyy").format(DateTime.now());
  int qtdAgendamentos = 0;
  int qtdHospedagem = 0;
  int index = 0;
  int index2 = 0;
  String _apiResponse = '';
  List<Cliente> _clientes = [];

  @override
  void initState() {
    super.initState();
    // fetchClientes();
    // formatFirestoreTimestamp();
    _obterTodosAgendamentos(data);
    //_obterQuantidadeAgendamentos();
    //_obterQuantidadeHospedagem();
    _obterTodasHospedagens(statusHospedagem);
  }

  paginaInicial() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => const Inicio(
                index: 0,
              )),
    );
  }

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

  paginaPlanos() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ListaPlanos()),
    );
  }

  paginaColaboradores() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ListaColaborador()),
    );
  }

  paginaPet() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ListaPet()),
    );
  }

  paginaHospedagem() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ListaHospedagem()),
    );
  }

  paginaAgendamentos() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ListaAgendamentos(
                data: dataAgendamento,
              )),
    );
  }

  paginaAgendamentosPendentes() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => const ListaAgendamentosPendentes()),
    );
  }

  paginaConfig() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const Principal()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _retornaPop,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/imagens/back_app.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Agendamentos do dia! ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.teal.shade100,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  if (contatoPrimeiroAgendamento != "")
                    Row(
                      children: [
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          "Banho e tosa possui ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          qtdAgendamentos.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const Text(
                          " agendamentos para hoje!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (contatoPrimeiroAgendamento != "")
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: InkWell(
                            child: Container(
                                padding: const EdgeInsets.all(2.0),
                                height: 115,
                                width: 360,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                  color:
                                      const Color.fromRGBO(204, 236, 247, 100),
                                ),
                                child: Column(children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(children: [
                                    const Text(
                                      "1° Agendamento do dia para  ",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      horaPrimeiroAgendamento.toString() ?? "",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    const Text(
                                      " Horas",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ]),
                                  Row(children: [
                                    const Text(
                                      "Pet: ",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      petPrimeiroAgendamento.toString() ?? "",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Text(
                                      "contato: ",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        //fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      contatoPrimeiroAgendamento.toString() ??
                                          "",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ]),
                                  Row(children: [
                                    const SizedBox(
                                      width: 250,
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.blueAccent,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ListaAgendamentos(
                                                      data: dataAgendamento,
                                                    )));
                                      },
                                      child: const Text('ver todos...'),
                                    )
                                  ]),
                                ])),
                            onTap: () {},
                          ),
                        )
                      ],
                    ),
                  if (contatoPrimeiroAgendamento == "")
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: InkWell(
                            child: Container(
                                height: 115,
                                width: 380,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                  color:
                                      const Color.fromRGBO(204, 236, 247, 100),
                                ),
                                child: const Column(children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(children: [
                                    Text(
                                      "Sem agendamentos para hoje!  ",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ]),
                                ])),
                            onTap: () {},
                          ),
                        )
                      ],
                    ),
                  const SizedBox(
                    height: 25,
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.teal.shade100,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  if (contatoPrimeiroHospedagem != "")
                    Row(
                      children: [
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          "Hospedagem possui ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          qtdHospedagem.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const Text(
                          " agendamentos para hoje!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (contatoPrimeiroHospedagem != "")
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: InkWell(
                            child: Container(
                                padding: const EdgeInsets.all(2.0),
                                height: 115,
                                width: 360,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                  color:
                                      const Color.fromRGBO(204, 236, 247, 100),
                                ),
                                child: Column(children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(children: [
                                    const Text(
                                      "1° Hospedagem check in para  ",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      horaPrimeiroHospedagem.toString() ?? "",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    const Text(
                                      " Horas",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ]),
                                  Row(children: [
                                    const Text(
                                      "Pet: ",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    Text(
                                      petPrimeiroHospedagem.toString() ?? "",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Text(
                                      "contato: ",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      contatoPrimeiroHospedagem.toString() ??
                                          "",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ]),
                                  Row(children: [
                                    const SizedBox(
                                      width: 250,
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.blueAccent,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ListaHospedagemDia()));
                                      },
                                      child: const Text('ver todos...'),
                                    )
                                  ]),
                                ])),
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  if (contatoPrimeiroHospedagem == "")
                    Row(
                      children: [
                        InkWell(
                          child: Container(
                              height: 120,
                              width: 380,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                                color: const Color.fromRGBO(204, 236, 247, 100),
                              ),
                              child: const Column(children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Row(children: [
                                  Text(
                                    "Sem hospedagem para hoje!  ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ]),
                              ])),
                          onTap: () {},
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<bool> _retornaPop() {
    return Future.value(false);
  }

  /* void _obterQuantidadeAgendamentos() {
    info.quantidadeAgendamentosDia(data).then((dynamic result) {
      setState(() {
        qtdAgendamentos = result;
      });
    });
  }*/
  void salvar() {
    /*
    DateTime data = DateTime.now();
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("teste").doc().set({
      "data": data,
    });*/
  }

  //final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /* Future<void> formatFirestoreTimestamp() async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      QuerySnapshot query = await db.collection('teste').get();
      List listaDatas = [];

      query.docs.forEach((doc) {
        Timestamp timestamp = doc.get('data');
        String formattedDate =
            DateFormat('dd/MM/yyyy').format(timestamp.toDate());
        print("Formatted Date: $formattedDate");
        setState(() {
          listaDatas.add(timestamp);
        });
      });

      // Get the Timestamp from Firestore
      // Timestamp timestamp = documentSnapshot.data() as Timestamp;

      // Format the Timestamp as a string
    } catch (e) {
      print("Error fetching document: $e");
    }
  }*/

  void _obterTodasHospedagens(String data) {
    /* infoHospedagem
        .obterTodasHospedagemDiaFirestore(dataAgendamento)
        .then((dynamic list) {
      setState(() {
        hospedagem = list;
        if (hospedagem.isEmpty) {
          contatoPrimeiroHospedagem = "";
          petPrimeiroHospedagem = "";
          horaPrimeiroHospedagem = "";
          index2 = 1;
        }
        if (hospedagem.isNotEmpty) {
          contatoPrimeiroHospedagem = hospedagem[index2].nomeContato!;
          petPrimeiroHospedagem = hospedagem[index2].nomePet!;
          horaPrimeiroHospedagem = hospedagem[index2].horaCheckIn.toString()!;
        }
      });
    });*/
  }

  void _obterTodosAgendamentos(String dataAgendamento) {
    /* info.obterTodosAgendamentosFirestore(data).then((dynamic list) {
      setState(() {
        agendamento = list;
        if (agendamento.isEmpty) {
          contatoPrimeiroAgendamento = "";
          petPrimeiroAgendamento = "";
          horaPrimeiroAgendamento = "";
          index = 1;
        }
        if (agendamento.isNotEmpty) {
          contatoPrimeiroAgendamento = agendamento[index].nomeContato!;
          petPrimeiroAgendamento = agendamento[index].nomePet!;
          horaPrimeiroAgendamento = agendamento[index].hora!;
          index = index + 1;
        }
      });
    });*/
  }

  /* Future<void> fetchClientes() async {
    final response =
        await http.get(Uri.parse('http://sys.jrpdv.com.br:9810/api/Clientes'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        _clientes = responseData.map((item) => Cliente.fromJson(item)).toList();
      });
    } else {
      // Manejar error en la consulta a la API
    }
  }*/

  /* void _obterQuantidadeHospedagem() {
    infoHospedagem.quantidadeHospedagemDia(data).then((dynamic result) {
      setState(() {
        qtdHospedagem = result;
      });
    });
  }*/
}

class Cliente {
  final String codigo;
  final String descricao;

  Cliente({required this.codigo, required this.descricao});
  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      codigo: json['Codigo'],
      descricao: json['Nome'],
    );
  }
}
