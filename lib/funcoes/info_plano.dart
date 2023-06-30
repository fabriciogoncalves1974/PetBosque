import 'package:sqflite/sqflite.dart'
    show Sqflite, getDatabasesPath, openDatabase;
import 'package:sqflite/sqlite_api.dart';

import '../database/sqflite/db.dart';

const String tabelaPlano = "tabelaPlanos";
const String idColuna = "id";
const String nomePlanoColuna = "nomePlano";
const String svBanhoColuna = "svBanho";
const String svTosaColuna = "svTosa";
const String svCorteUnhaColuna = "svCorteUnha";
const String svHidratacaoColuna = "svHidratacao";
const String svTosaHigienicaColuna = "svTosaHigienica";
const String svPinturaColuna = "svPintura";
const String svHospedagemColuna = "svHospedagem";
const String svTransporteColuna = "svTransporte";
const String valorColuna = "valor";

class InfoPlano {
  static final InfoPlano _instance = InfoPlano.internal();

  factory InfoPlano() => _instance;

  InfoPlano.internal();

  Future<Plano> salvarPlano(Plano plano) async {
    Database? db = await DB.instance.database;
    Database? dbPlano = db;
    plano.id = await dbPlano!.insert(tabelaPlano, plano.toMap());
    return plano;
  }

  Future<List> obterPlanoContato(id) async {
    Database? db = await DB.instance.database;
    Database? dbPlano = db;
    List listMap =
        await dbPlano!.rawQuery("SELECT * FROM $tabelaPlano WHERE id = $id");
    List<Plano> listaPlano = [];
    for (Map m in listMap) {
      listaPlano.add(Plano.fromMap(m));
    }
    return listaPlano;
  }

  Future<Plano?> obterPlano(int id) async {
    Database? db = await DB.instance.database;
    Database? dbPlano = db;
    List<Map> maps = await dbPlano!.query(tabelaPlano,
        columns: [
          idColuna,
          nomePlanoColuna,
          svBanhoColuna,
          svTosaColuna,
          svCorteUnhaColuna,
          svHidratacaoColuna,
          svTosaHigienicaColuna,
          svPinturaColuna,
          svHospedagemColuna,
          svTransporteColuna,
          valorColuna,
        ],
        where: "$idColuna = ?",
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Plano.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deletarPlano(int id) async {
    Database? db = await DB.instance.database;
    Database? dbPlano = db;
    return await dbPlano!
        .delete(tabelaPlano, where: "$idColuna = ?", whereArgs: [id]);
  }

  Future<int> atualizarPlano(Plano plano) async {
    Database? db = await DB.instance.database;
    Database? dbPlano = db;
    return dbPlano!.update(tabelaPlano, plano.toMap(),
        where: "$idColuna = ?", whereArgs: [plano.id]);
  }

  Future<List> obterTodosPlanos() async {
    Database? db = await DB.instance.database;
    Database? dbPlano = db;
    List listMap = await dbPlano!.rawQuery("SELECT * FROM $tabelaPlano ");
    List<Plano> listaPlano = [];
    for (Map m in listMap) {
      listaPlano.add(Plano.fromMap(m));
    }
    return listaPlano;
  }

  Future<List> obterPlanosPet2(int id) async {
    Database? db = await DB.instance.database;
    Database? dbPlano = db;
    List listMap =
        await dbPlano!.rawQuery("SELECT * FROM $tabelaPlano WHERE id = $id");
    List<Plano> listaPlano = [];
    for (Map m in listMap) {
      listaPlano.add(Plano.fromMap(m));
    }
    return listaPlano;
  }

  Future obterPlanosPet(int id) async {
    Database? db = await DB.instance.database;
    Database? dbPlanos = db;
    return await dbPlanos!
        .rawQuery("SELECT * FROM $tabelaPlano WHERE id = $id");
  }

  Future<int?> quantidadePlanos() async {
    Database? db = await DB.instance.database;
    Database? dbPlano = db;
    return Sqflite.firstIntValue(
        await dbPlano!.rawQuery("SELECT COUNT(*) FROM $tabelaPlano"));
  }

  Future close() async {
    Database? db = await DB.instance.database;
    Database? dbPlano = db;
    dbPlano!.close();
  }
}

class Plano {
  int? id;
  String? nomePlano;
  String? svBanho;
  String? svTosa;
  String? svCorteUnha;
  String? svHidratacao;
  String? svTosaHigienica;
  String? svPintura;
  String? svHospedagem;
  String? svTransporte;
  double? valor;

  Plano();

  Plano.fromMap(Map map) {
    id = map[idColuna];
    nomePlano = map[nomePlanoColuna];
    svBanho = map[svBanhoColuna];
    svTosa = map[svTosaColuna];
    svCorteUnha = map[svCorteUnhaColuna];
    svHidratacao = map[svHidratacaoColuna];
    svTosaHigienica = map[svTosaHigienicaColuna];
    svPintura = map[svPinturaColuna];
    svHospedagem = map[svHospedagemColuna];
    svTransporte = map[svTransporteColuna];
    valor = map[valorColuna];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      nomePlanoColuna: nomePlano,
      svBanhoColuna: svBanho,
      svTosaColuna: svTosa,
      svCorteUnhaColuna: svCorteUnha,
      svHidratacaoColuna: svHidratacao,
      svTosaHigienicaColuna: svTosaHigienica,
      svPinturaColuna: svPintura,
      svHospedagemColuna: svHospedagem,
      svTransporteColuna: svTransporte,
      valorColuna: valor,
    };

    if (id != null) {
      map[idColuna] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Planos(id: $id,nomePlano: $nomePlano,svBanho: $svBanho,svTosa: $svTosa,svCorteUnha: $svCorteUnha,svHidratacao: $svHidratacao,svTosaHigienica: $svTosaHigienica,svPintura: $svPintura,svHospedagem: $svHospedagem,svTransporte: $svTransporte, valor: $valor)";
  }
}
