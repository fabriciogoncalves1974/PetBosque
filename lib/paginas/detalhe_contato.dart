import 'package:flutter/material.dart';
import 'package:pet_bosque/funcoes/info_coloborador.dart';
import 'package:pet_bosque/funcoes/info_contato.dart';
import 'package:pet_bosque/paginas/lista_contato.dart';
import 'package:pet_bosque/paginas/lista_pet.dart';

enum OrderOption { orderaz, orderza }

InfoContato info = InfoContato();

class DetalheContato extends StatefulWidget {
  const DetalheContato({
    Key? key,
    required this.idContato,
  }) : super(key: key);

  final int idContato;

  @override
  State<DetalheContato> createState() => _DetalheContatoState();
}

class _DetalheContatoState extends State<DetalheContato> {
  List<Contato> contato = [];

  late String status;
  late int idContato;
  late int contatoId;

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

    _obterContato();
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
          title: const Text("Detalhe do Contato"),
          centerTitle: true,
        ),
        body: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _detalhes(context, index);
                },
                childCount: contato.length,
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
                  "Cliente: ",
                  style: TextStyle(
                    color: Color.fromARGB(255, 73, 66, 2),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  contato[index].nome ?? "",
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
                  "Telefone: ",
                  style: TextStyle(
                    color: Color.fromARGB(255, 73, 66, 2),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  contato[index].telefone ?? "",
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
                  "Email: ",
                  style: TextStyle(
                    color: Color.fromARGB(255, 73, 66, 2),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  contato[index].email ?? "",
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
                  "Endereço: ",
                  style: TextStyle(
                    color: Color.fromARGB(255, 73, 66, 2),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  contato[index].endereco ?? "",
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
                  "Complemento: ",
                  style: TextStyle(
                    color: Color.fromARGB(255, 73, 66, 2),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  contato[index].complemento ?? "",
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
                  "Bairro: ",
                  style: TextStyle(
                    color: Color.fromARGB(255, 73, 66, 2),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  contato[index].bairro ?? "",
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
                  "Cidade: ",
                  style: TextStyle(
                    color: Color.fromARGB(255, 73, 66, 2),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  contato[index].cidade ?? "",
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
          ],
        ),
      ),
    );
    onTap:
    () {};
  }

  void _obterContato() {
    info.obterDadosContato(widget.idContato).then((dynamic list) {
      setState(() {
        contato = list;
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