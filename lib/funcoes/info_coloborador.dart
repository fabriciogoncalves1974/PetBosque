import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart'
    show Sqflite, getDatabasesPath, openDatabase;
import 'package:sqflite/sqlite_api.dart';

import '../database/sqflite/db.dart';

const String tabelaColaborador = "tabelaColaborador";
const String idColuna = "id";
const String nomeColaboradorColuna = "nomeColaborador";
const String funcaoColuna = "funcao";
const String porcenComissaoColuna = "porcenComissao";
const String porcenParticipanteColuna = "porcenParticipante";
const String metaComissaoColuna = "metaComissao";
const String statusColuna = "status";

class InfoColaborador {
  static final InfoColaborador _instance = InfoColaborador.internal();

  factory InfoColaborador() => _instance;

  InfoColaborador.internal();

  Future<Colaborador> salvarColaborador(Colaborador colaborador) async {
    Database? db = await DB.instance.database;
    Database? dbColaborador = db;
    colaborador.id =
        await dbColaborador!.insert(tabelaColaborador, colaborador.toMap());
    return colaborador;
  }

  Future<List> obterDadosColaborador(dynamic id) async {
    Database? db = await DB.instance.database;
    Database? dbColaborador = db;
    List listMap = await dbColaborador!
        .rawQuery("SELECT * FROM $tabelaColaborador WHERE id = $id");
    List<Colaborador> listaColaborador = [];
    for (Map m in listMap) {
      listaColaborador.add(Colaborador.fromMap(m));
    }
    return listaColaborador;
  }

  Future<Future<List<Map<String, Object?>>>> inativarColaborador(
      dynamic id) async {
    Database? db = await DB.instance.database;
    Database? dbColaborador = db;
    return dbColaborador!.rawQuery(
        "UPDATE '$tabelaColaborador' SET  status = 'Inativo' WHERE id = '$id'");
  }

  Future<Future<List<Map<String, Object?>>>> ativarColaborador(
      dynamic id) async {
    Database? db = await DB.instance.database;
    Database? dbColaborador = db;
    return dbColaborador!.rawQuery(
        "UPDATE '$tabelaColaborador' SET  status = 'Ativo' WHERE id = '$id'");
  }

  Future<Colaborador?> obterColaborador(dynamic id) async {
    Database? db = await DB.instance.database;
    Database? dbColaborador = db;
    List<Map> maps = await dbColaborador!.query(tabelaColaborador,
        columns: [
          idColuna,
          nomeColaboradorColuna,
          funcaoColuna,
          porcenComissaoColuna,
          metaComissaoColuna,
          porcenParticipanteColuna,
          statusColuna,
        ],
        where: "$idColuna = ?",
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Colaborador.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<dynamic> deletarColaborador(dynamic id) async {
    Database? db = await DB.instance.database;
    Database? dbColaborador = db;
    return await dbColaborador!
        .delete(tabelaColaborador, where: "$idColuna = ?", whereArgs: [id]);
  }

  Future<int> atualizarColaborador(Colaborador colaborador) async {
    Database? db = await DB.instance.database;
    Database? dbColaborador = db;
    return dbColaborador!.update(tabelaColaborador, colaborador.toMap(),
        where: "$idColuna = ?", whereArgs: [colaborador.id]);
  }

  Future<List> obterTodosColaboradores() async {
    Database? db = await DB.instance.database;
    Database? dbColaborador = db;
    List listMap =
        await dbColaborador!.rawQuery("SELECT * FROM $tabelaColaborador ");
    List<Colaborador> listaColaborador = [];
    for (Map m in listMap) {
      listaColaborador.add(Colaborador.fromMap(m));
    }
    return listaColaborador;
  }

  Future<List> obterNomeColaborador() async {
    Database? db = await DB.instance.database;
    Database? dbColaborador = db;
    List listMap = await dbColaborador!
        .rawQuery("SELECT * FROM $tabelaColaborador WHERE status = 'Ativo'");
    List<Colaborador> listaColaborador = [];
    for (Map m in listMap) {
      listaColaborador.add(Colaborador.fromMap(m));
    }
    return listaColaborador;
  }

  Future<int?> quantidadeColaborador() async {
    Database? db = await DB.instance.database;
    Database? dbColaborador = db;
    return Sqflite.firstIntValue(await dbColaborador!
        .rawQuery("SELECT COUNT(*) FROM $tabelaColaborador"));
  }

  Future close() async {
    Database? db = await DB.instance.database;
    Database? dbPlano = db;
    dbPlano!.close();
  }

//=========================================================================

  //FUNÇÕES API

  Future<List> obterTodosColaboradoresApi() async {
    final url = Uri.http(
        'fb.servicos.ws', '/petBosque/colaborador/lista', {'q': '{http}'});

    final response = await http.get(url);
    final map = await jsonDecode(response.body);
    List<Colaborador> listaColaborador = [];

    if (map.containsKey("dados") && map["dados"] is List) {
      List listMap = map["dados"];
      for (Map m in listMap) {
        listaColaborador.add(Colaborador.fromJson(m));
      }
    }
    return listaColaborador;
  }

  Future<Colaborador?> obterDadosColaboradorApi(id) async {
    final url = Uri.http(
        'fb.servicos.ws', '/petBosque/colaborador/lista/$id', {'q': '{http}'});

    final response = await http.get(url);
    final map = await jsonDecode(response.body);
    //List<dynamic> listMap = map["dados"];

    // Map<String, dynamic> primeiroMap = listMap.first;

    Colaborador primeiroColaborador = Colaborador.fromJson(map["dados"]);
    return primeiroColaborador;
  }

  Future<String> salvarColaboradorApi(Colaborador colaborador) async {
    final url = Uri.http(
        'fb.servicos.ws', '/petBosque/colaborador/adiciona', {'q': '{http}'});

    final response = await http.post(
      Uri.parse("$url"),
      body: {
        "nomeColaborador": colaborador.nomeColaborador.toString(),
        "funcao": colaborador.funcao.toString(),
        "porcenComissao": colaborador.porcenComissao.toString(),
        "porcenParticipante": colaborador.porcenParticipante.toString(),
        "metaComissao": colaborador.metaComissao.toString(),
        "status": colaborador.status.toString(),
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
}

class Colaborador {
  dynamic id;
  String? nomeColaborador;
  String? funcao;
  dynamic porcenComissao;
  dynamic porcenParticipante;
  dynamic metaComissao;
  String? status;

  Colaborador(
      {this.nomeColaborador,
      this.funcao,
      this.porcenComissao,
      this.porcenParticipante,
      this.metaComissao,
      this.status,
      this.id});

  factory Colaborador.fromJson(Map json) {
    return Colaborador(
        id: json['id'],
        nomeColaborador: json['nomeColaborador'],
        funcao: json['funcao'],
        porcenComissao: json['porcenComissao'],
        porcenParticipante: json['porcenParticipante'],
        metaComissao: json['metaComissao'],
        status: json['status']);
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'nomeColaborador': this.nomeColaborador,
        'funcao': this.funcao,
        'porcenComissao': this.porcenComissao,
        'porcenParticipante': this.porcenParticipante,
        'metaComissao': this.metaComissao,
        'status': this.status,
      };

  Colaborador.fromMap(Map map) {
    id = map[idColuna];
    nomeColaborador = map[nomeColaboradorColuna];
    funcao = map[funcaoColuna];
    porcenComissao = map[porcenComissaoColuna];
    porcenParticipante = map[porcenParticipanteColuna];
    metaComissao = map[metaComissaoColuna];
    status = map[statusColuna];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      nomeColaboradorColuna: nomeColaborador,
      funcaoColuna: funcao,
      porcenComissaoColuna: porcenComissao,
      porcenParticipanteColuna: porcenParticipante,
      metaComissaoColuna: metaComissao,
      statusColuna: status,
    };

    if (id != null) {
      map[idColuna] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Colaborador(id: $id,nomeColaborador: $nomeColaborador,funcao: $funcao,porcenComissao: $porcenComissao,porcenParticipante: $porcenParticipante, metaComissao: $metaComissao,status: $status)";
  }
}
