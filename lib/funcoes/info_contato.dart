import 'package:sqflite/sqflite.dart'
    show Sqflite, getDatabasesPath, openDatabase;
import 'package:sqflite/sqlite_api.dart';

import '../database/sqflite/db.dart';

const String tabelaContato = "tabelaContato";
const String idColuna = "id";
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

  /* Future<List> obterTodosContatosFirestore() async {
    var result = await contactCollection.get();
    List listMap = result.docs
        .map((doc) => Contato(
              id: doc.reference.id.toString(),
              nome: doc['nome'],
              email: doc['email'],
              telefone: doc['telefone'],
              bairro: doc['bairro'],
              endereco: doc['endereco'],
              complemento: doc['complemento'],
              cidade: doc['cidade'],
            ))
        .toList();
    List<Contato> listaContato = [];
    for (Map m in listMap) {
      listaContato.add(Contato.fromMap(m));
    }
    print(listaContato);
    return listaContato;
  }*/
}

class Contato {
  int? id;
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
      {required nome,
      required email,
      required telefone,
      required String id,
      required bairro,
      required endereco,
      required complemento,
      required cidade});

  Contato.fromMap(Map map) {
    id = map[idColuna];
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
    return "Contato(id: $id,idPet: $idPet,nome: $nome,email: $email,telefone: $telefone,endereco: $endereco,bairro: $bairro,cidade: $cidade,complemento: $complemento,uf: $uf)";
  }
}
