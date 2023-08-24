import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart'
    show Sqflite, getDatabasesPath, openDatabase;
import 'package:sqflite/sqlite_api.dart';

import '../database/sqflite/db.dart';

const String tabelaContato = "tabelaContato";
const String idColuna = "id";
const String idContatoColuna = "idContato";
const String idPetColuna = "idPet";
const String nomeColuna = "nome";
const String emailColuna = "email";
const String telefoneColuna = "telefone";
const String enderecoColuna = "endereco";
const String bairroColuna = "bairro";
const String complementoColuna = "complemento";
const String cidadeColuna = "cidade";
const String ufColuna = "uf";

class InfoContato {
  static final InfoContato _instance = InfoContato.internal();

  factory InfoContato() => _instance;

  InfoContato.internal();

//FUNÇÕES MYSQL

  Future<Contato> salvarContato(Contato contato) async {
    Database? db = await DB.instance.database;
    Database? dbContato = db;
    contato.id = await dbContato!.insert(tabelaContato, contato.toMap());
    return contato;
  }

  Future<Contato?> obterContato(int id) async {
    Database? db = await DB.instance.database;
    Database? dbContato = db;
    List<Map> maps = await dbContato!.query(tabelaContato,
        columns: [
          idColuna,
          idContatoColuna,
          idPetColuna,
          nomeColuna,
          emailColuna,
          enderecoColuna,
          bairroColuna,
          cidadeColuna,
          complementoColuna,
          ufColuna
        ],
        where: "$idColuna = ?",
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Contato.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deletarContato(int id) async {
    Database? db = await DB.instance.database;
    Database? dbContato = db;
    return await dbContato!
        .delete(tabelaContato, where: "$idColuna = ?", whereArgs: [id]);
  }

  Future<int> atualizarContato(Contato contato) async {
    Database? db = await DB.instance.database;
    Database? dbContato = db;
    return dbContato!.update(tabelaContato, contato.toMap(),
        where: "$idColuna = ?", whereArgs: [contato.id]);
  }

  Future<List> obterTodosContatos() async {
    Database? db = await DB.instance.database;
    Database? dbContato = db;
    List listMap = await dbContato!.rawQuery("SELECT * FROM $tabelaContato");
    List<Contato> listaContato = [];
    for (Map m in listMap) {
      listaContato.add(Contato.fromMap(m));
    }
    return listaContato;
  }

  Future<List> obterDadosContato(int id) async {
    Database? db = await DB.instance.database;
    Database? dbContato = db;
    List listMap = await dbContato!
        .rawQuery("SELECT * FROM $tabelaContato WHERE id = $id");
    List<Contato> listaContato = [];
    for (Map m in listMap) {
      listaContato.add(Contato.fromMap(m));
    }
    return listaContato;
  }

  Future<List<Contato>> pesquisarTodosContatos(String teclado) async {
    Database? db = await DB.instance.database;
    Database? dbContato = db;
    List listMap = await dbContato!.rawQuery(
        "SELECT * FROM $tabelaContato WHERE nome  LIKE '%$teclado%' OR cidade LIKE '%$teclado%'");
    List<Contato> listaContato = [];
    for (Map m in listMap) {
      listaContato.add(Contato.fromMap(m));
    }
    return listaContato;
  }

  Future<int?> quantidadeContatos() async {
    Database? db = await DB.instance.database;
    Database? dbContato = db;
    return Sqflite.firstIntValue(
        await dbContato!.rawQuery("SELECT COUNT(*) FROM $tabelaContato"));
  }

  Future close() async {
    Database? db = await DB.instance.database;
    Database? dbContato = db;
    dbContato!.close();
  }

  //=========================================================================

  //FUNÇÕES API

  Future<List> obterTodosClientesApi() async {
    final url = Uri.http(
        'fb.servicos.ws', '/petBosque/clientes/lista', {'q': '{http}'});

    final response = await http.get(url);
    final map = await jsonDecode(response.body);
    List<Contato> listaContato = [];

    if (map.containsKey("dados") && map["dados"] is List) {
      List listMap = map["dados"];
      for (Map m in listMap) {
        listaContato.add(Contato.fromJson(m));
      }
    }
    return listaContato;
  }

  Future<Contato?> obterDadosClientesApi(id) async {
    final url = Uri.http(
        'fb.servicos.ws', '/petBosque/clientes/lista/$id', {'q': '{http}'});

    final response = await http.get(url);
    final map = await jsonDecode(response.body);
    //List<dynamic> listMap = map["dados"];

    // Map<String, dynamic> primeiroMap = listMap.first;

    Contato primeiroContato = Contato.fromJson(map["dados"]);
    return primeiroContato;
  }

  Future<String> salvarClienteApi(Contato contato) async {
    final url = Uri.http(
        'fb.servicos.ws', '/petBosque/clientes/adiciona', {'q': '{http}'});

    final response = await http.post(
      Uri.parse("$url"),
      body: {
        "nome": contato.nome.toString(),
        "idCliente": contato.idContato.toString(),
        "email": contato.email.toString(),
        "telefone": contato.telefone.toString(),
        "endereco": contato.endereco.toString(),
        "bairro": contato.bairro.toString(),
        "complemento": contato.complemento.toString(),
        "cidade": contato.cidade.toString(),
      },
    );
    String retorno = "";

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      retorno = jsonResponse['dados'];
    } else {
      retorno = "Erro na requisição: ${response.statusCode}";
    }

    return retorno;
  }

  Future<String> atualizarClienteApi(Contato contato) async {
    final url = Uri.http(
        'fb.servicos.ws',
        // ignore: prefer_interpolation_to_compose_strings
        '/petBosque/clientes/update/' + contato.id,
        {'q': '{http}'});

    final response = await http.post(
      Uri.parse("$url"),
      body: {
        "_method": "PUT",
        "nome": contato.nome.toString(),
        "idCliente": contato.idContato.toString(),
        "email": contato.email.toString(),
        "telefone": contato.telefone.toString(),
        "endereco": contato.endereco.toString(),
        "bairro": contato.bairro.toString(),
        "complemento": contato.complemento.toString(),
        "cidade": contato.cidade.toString(),
      },
    );
    String retorno = "";

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      retorno = jsonResponse['dados'];
    } else {
      retorno = "Erro na requisição: ${response.statusCode}";
    }

    return retorno;
  }

  Future<String> excluirClienteApi(id) async {
    final url = Uri.http(
        'fb.servicos.ws',
        // ignore: prefer_interpolation_to_compose_strings
        '/petBosque/clientes/delete/' + id,
        {'q': '{http}'});

    final response = await http.post(
      Uri.parse("$url"),
      body: {
        "_method": "DELETE",
      },
    );
    String retorno = "";

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      retorno = jsonResponse['dados'];
    } else {
      retorno = "Erro na requisição: ${response.statusCode}";
    }

    return retorno;
  }

//=========================================================================

  //FUNÇÕES FIRESTORE

  Future<List> obterTodosContatosFirestore() async {
    CollectionReference contatoCollection =
        FirebaseFirestore.instance.collection('contato');
    var result = await contatoCollection.orderBy('nome').get();
    return result.docs
        .map((doc) => Contato(
            id: doc['idContato'],
            nome: doc['nome'],
            email: doc['email'],
            telefone: doc['telefone'],
            bairro: doc['bairro'],
            endereco: doc['endereco'],
            complemento: doc['complemento'],
            cidade: doc['cidade'],
            uf: doc['uf']))
        .toList();
  }

  Future<List> obterDadosContatosFirestore(id) async {
    CollectionReference contatoCollection =
        FirebaseFirestore.instance.collection('contato');
    var result =
        await contatoCollection.where('idContato', isEqualTo: '$id').get();
    return result.docs
        .map((doc) => Contato(
            id: doc['idContato'],
            nome: doc['nome'],
            email: doc['email'],
            telefone: doc['telefone'],
            bairro: doc['bairro'],
            endereco: doc['endereco'],
            complemento: doc['complemento'],
            cidade: doc['cidade'],
            uf: doc['uf']))
        .toList();
  }

  Future<List<Contato>> pesquisarTodosContatosFirestore(teclado) async {
    CollectionReference contatoCollection =
        FirebaseFirestore.instance.collection('contato');
    // List lst = [];
    //lst.add('$teclado');
    var result = await contatoCollection
        .orderBy('nome')
        .startAt([teclado])
        .endAt([teclado + '\uf8ff'])
        //.where('nome', arrayContains: teclado)
        //.where('nome', arrayContainsAny: lst)
        .where('nome', isLessThan: teclado + 'z')
        .get();
    return result.docs
        .map((doc) => Contato(
            id: doc['idContato'],
            nome: doc['nome'],
            email: doc['email'],
            telefone: doc['telefone'],
            bairro: doc['bairro'],
            endereco: doc['endereco'],
            complemento: doc['complemento'],
            cidade: doc['cidade'],
            uf: doc['uf']))
        .toList();
  }

  deletarContatoFirestore(id) async {
    CollectionReference planoCollection =
        FirebaseFirestore.instance.collection('contato');
    planoCollection.doc(id).delete();
  }
}
//=========================================================================

class Contato {
  dynamic id;
  String? idContato;
  String? idPet;
  String? nome;
  String? email;
  String? telefone;
  String? endereco;
  String? bairro;
  String? cidade;
  String? complemento;
  String? uf;

  Contato(
      {this.nome,
      this.idContato,
      this.email,
      this.telefone,
      this.id,
      this.bairro,
      this.endereco,
      this.complemento,
      this.cidade,
      this.uf});
  factory Contato.fromJson(Map json) {
    return Contato(
        id: json['id'],
        idContato: json['idContato'],
        nome: json['nome'],
        email: json['email'],
        telefone: json['telefone'],
        bairro: json['bairro'],
        endereco: json['endereco'],
        complemento: json['complemento'],
        cidade: json['cidade'],
        uf: json['uf']);
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'idContato': this.idContato,
        'nome': this.nome,
        'telefone': this.telefone,
        'email': this.email,
        'bairro': this.bairro,
        'endereco': this.endereco,
        'complemento': this.complemento,
        'cidade': this.cidade,
        'uf': this.uf,
      };

  Contato.fromMap(Map map) {
    id = map[idColuna];
    idContato = map[idContatoColuna];
    idPet = map[idPetColuna];
    nome = map[nomeColuna];
    email = map[emailColuna];
    telefone = map[telefoneColuna];
    endereco = map[enderecoColuna];
    bairro = map[bairroColuna];
    cidade = map[cidadeColuna];
    complemento = map[complementoColuna];
    uf = map[ufColuna];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      idContatoColuna: idContato,
      idPetColuna: idPet,
      nomeColuna: nome,
      emailColuna: email,
      telefoneColuna: telefone,
      enderecoColuna: endereco,
      bairroColuna: bairro,
      cidadeColuna: cidade,
      complementoColuna: complemento,
      ufColuna: uf,
    };
    if (id != null) {
      map[idColuna] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contato(id: $id,idContato:$idContato, idPet: $idPet,nome: $nome,email: $email,telefone: $telefone,endereco: $endereco,bairro: $bairro,cidade: $cidade,complemento: $complemento,uf: $uf)";
  }
}
