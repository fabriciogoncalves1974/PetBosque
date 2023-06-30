import 'package:sqflite/sqflite.dart'
    show Sqflite, getDatabasesPath, openDatabase;
import 'package:sqflite/sqlite_api.dart';

import '../database/sqflite/db.dart';

const String tabelaColaborador = "tabelaColaborador";
const String idColuna = "id";
const String nomeColaboradorColuna = "nomeColaborador";
const String funcaoColuna = "funcao";
const String porcenComissaoColuna = "porcenComissao";
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

  Future<List> obterDadosColaborador(int id) async {
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

  Future<Future<List<Map<String, Object?>>>> inativarColaborador(int id) async {
    Database? db = await DB.instance.database;
    Database? dbColaborador = db;
    return dbColaborador!.rawQuery(
        "UPDATE '$tabelaColaborador' SET  status = 'Inativo' WHERE id = '$id'");
  }

  Future<Future<List<Map<String, Object?>>>> ativarColaborador(int id) async {
    Database? db = await DB.instance.database;
    Database? dbColaborador = db;
    return dbColaborador!.rawQuery(
        "UPDATE '$tabelaColaborador' SET  status = 'Ativo' WHERE id = '$id'");
  }

  Future<Colaborador?> obterColaborador(int id) async {
    Database? db = await DB.instance.database;
    Database? dbColaborador = db;
    List<Map> maps = await dbColaborador!.query(tabelaColaborador,
        columns: [
          idColuna,
          nomeColaboradorColuna,
          funcaoColuna,
          porcenComissaoColuna,
          metaComissaoColuna,
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

  Future<int> deletarColaborador(int id) async {
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
}

class Colaborador {
  int? id;
  String? nomeColaborador;
  String? funcao;
  double? porcenComissao;
  double? metaComissao;
  String? status;

  Colaborador();

  Colaborador.fromMap(Map map) {
    id = map[idColuna];
    nomeColaborador = map[nomeColaboradorColuna];
    funcao = map[funcaoColuna];
    porcenComissao = map[porcenComissaoColuna];
    metaComissao = map[metaComissaoColuna];
    status = map[statusColuna];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      nomeColaboradorColuna: nomeColaborador,
      funcaoColuna: funcao,
      porcenComissaoColuna: porcenComissao,
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
    return "Colaborador(id: $id,nomeColaborador: $nomeColaborador,funcao: $funcao,porcenComissao: $porcenComissao,metaComissao: $metaComissao,status: $status)";
  }
}
