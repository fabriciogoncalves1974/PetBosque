import 'package:sqflite/sqflite.dart'
    show Sqflite, getDatabasesPath, openDatabase;
import 'package:sqflite/sqlite_api.dart';

import '../database/sqflite/db.dart';

const String tabelaHospedagem = "tabelaHospedagem";
const String idColuna = "id";
const String idPetColuna = "idPet";
const String fotoPetColuna = "fotoPet";
const String nomeContatoColuna = "nomeContato";
const String nomePetColuna = "nomePet";
const String dataCheckInColuna = "dataCheckIn";
const String horaCheckInColuna = "horaCheckIn";
const String dataCheckOutColuna = "dataCheckOut";
const String horaCheckOutColuna = "horaCheckOut";
const String porteColuna = "porte";
const String diaColuna = "dia";
const String valorDiaColuna = "valorDia";
const String adicionalColuna = "adicional";
const String valorTotalColuna = "valorTotal";
const String observacaoColuna = "observacao";
const String statusColuna = "status";
const String colaboradorColuna = "colaborador";
const String idColaboradorColuna = "idColaborador";
const String generoColuna = "genero";

class InfoHospedagem {
  static final InfoHospedagem _instance = InfoHospedagem.internal();

  factory InfoHospedagem() => _instance;

  InfoHospedagem.internal();

  Future<Hospedagem> salvarHospedagem(Hospedagem hospedagem) async {
    Database? db = await DB.instance.database;
    Database? dbHospedagem = db;
    hospedagem.id =
        await dbHospedagem!.insert(tabelaHospedagem, hospedagem.toMap());
    return hospedagem;
  }

  Future<List> obterHospedagemContato(id) async {
    Database? db = await DB.instance.database;
    Database? dbHospedagem = db;
    List listMap = await dbHospedagem!
        .rawQuery("SELECT * FROM $tabelaHospedagem WHERE id = $id");
    List<Hospedagem> listaHospedagem = [];
    for (Map m in listMap) {
      listaHospedagem.add(Hospedagem.fromMap(m));
    }
    return listaHospedagem;
  }

  Future<Hospedagem?> obterHospedagem(int id) async {
    Database? db = await DB.instance.database;
    Database? dbHospedagem = db;
    List<Map> maps = await dbHospedagem!.query(tabelaHospedagem,
        columns: [
          idColuna,
          idPetColuna,
          fotoPetColuna,
          nomeContatoColuna,
          nomePetColuna,
          dataCheckInColuna,
          horaCheckInColuna,
          dataCheckOutColuna,
          horaCheckOutColuna,
          diaColuna,
          valorDiaColuna,
          adicionalColuna,
          valorTotalColuna,
          observacaoColuna,
          statusColuna,
          colaboradorColuna,
          idColaboradorColuna,
          porteColuna,
          generoColuna,
        ],
        where: "$idColuna = ?",
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Hospedagem.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deletarHospedagem(int id) async {
    Database? db = await DB.instance.database;
    Database? dbHospedagem = db;
    return await dbHospedagem!
        .delete(tabelaHospedagem, where: "$idColuna = ?", whereArgs: [id]);
  }

  Future<int> atualizarHospedagem(Hospedagem hospedagem) async {
    Database? db = await DB.instance.database;
    Database? dbHospedagem = db;
    return dbHospedagem!.update(tabelaHospedagem, hospedagem.toMap(),
        where: "$idColuna = ?", whereArgs: [hospedagem.id]);
  }

  Future<List> obterTodasHospedagem(dataAge) async {
    Database? db = await DB.instance.database;
    Database? dbHospedagem = db;
    List listMap = await dbHospedagem!.rawQuery(
        "SELECT * FROM $tabelaHospedagem WHERE dataCheckIn  LIKE '%$dataAge%' ORDER BY horaCheckIn");
    List<Hospedagem> listaHospedagem = [];
    for (Map m in listMap) {
      listaHospedagem.add(Hospedagem.fromMap(m));
    }
    return listaHospedagem;
  }

  Future<List> obterTodasHospedagemPendentes(dataAge) async {
    Database? db = await DB.instance.database;
    Database? dbHospedagem = db;
    List listMap = await dbHospedagem!.rawQuery(
        "SELECT * FROM $tabelaHospedagem WHERE dataCheckIn  < '$dataAge' AND status = 'Pendente' ORDER BY dataCheckIn");
    List<Hospedagem> listaHospedagem = [];
    for (Map m in listMap) {
      listaHospedagem.add(Hospedagem.fromMap(m));
    }
    return listaHospedagem;
  }

  Future<List> obterTodosHospedagemColaborador(idColaborador) async {
    Database? db = await DB.instance.database;
    Database? dbHospedagem = db;
    List listMap = await dbHospedagem!.rawQuery(
        "SELECT * FROM $tabelaHospedagem WHERE idColaborador = '$idColaborador' ORDER BY dataCheckIn");
    List<Hospedagem> listaHospedagem = [];
    for (Map m in listMap) {
      listaHospedagem.add(Hospedagem.fromMap(m));
    }
    return listaHospedagem;
  }

  Future<int?> quantidadeHospedagem() async {
    Database? db = await DB.instance.database;
    Database? dbHospedagem = db;
    return Sqflite.firstIntValue(
        await dbHospedagem!.rawQuery("SELECT COUNT(*) FROM $tabelaHospedagem"));
  }

  Future<int?> quantidadeHospedagemColaborador(int id) async {
    Database? db = await DB.instance.database;
    Database? dbHospedagem = db;
    return Sqflite.firstIntValue(await dbHospedagem!.rawQuery(
        "SELECT COUNT(*) FROM $tabelaHospedagem WHERE idColaborador = $id"));
  }

  Future<int?> quantidadeHospedagemDia(String data) async {
    Database? db = await DB.instance.database;
    Database? dbHospedagem = db;
    return Sqflite.firstIntValue(await dbHospedagem!.rawQuery(
        "SELECT COUNT(*) FROM $tabelaHospedagem WHERE dataCheckIn == '$data' AND status = 'Pendente'"));
  }

  Future<int?> quantidadeHospedagemPendentes(String data) async {
    Database? db = await DB.instance.database;
    Database? dbHospedagem = db;
    return Sqflite.firstIntValue(await dbHospedagem!.rawQuery(
        "SELECT COUNT(*) FROM $tabelaHospedagem WHERE dataCheckIn < '$data' AND status = 'Pendente'"));
  }

  Future totalHospedagemColaborador(int id) async {
    Database? db = await DB.instance.database;
    Database? dbHospedagem = db;
    return await dbHospedagem!.rawQuery(
        "SELECT SUM(valorTotal) as total FROM $tabelaHospedagem WHERE idColaborador = $id");
  }

  Future<Future<List<Map<String, Object?>>>> atualizarStatus(
      int id, String status, String colaborador, String idColaborador) async {
    Database? db = await DB.instance.database;
    Database? dbHospedagem = db;
    return dbHospedagem!.rawQuery(
        "UPDATE '$tabelaHospedagem' SET  status = '$status', colaborador = '$colaborador' , idColaborador = '$idColaborador' WHERE id = '$id'");
  }

  Future close() async {
    Database? db = await DB.instance.database;
    Database? dbHospedagem = db;
    dbHospedagem!.close();
  }
}

class Hospedagem {
  int? id;
  String? idPet;
  String? nomeContato;
  String? fotoPet;
  String? nomePet;
  String? dataCheckIn;
  String? horaCheckIn;
  String? dataCheckOut;
  String? horaCheckOut;
  int? dia;
  double? valorDia;
  double? adicional;
  double? valorTotal;
  String? observacao;
  String? status;
  String? colaborador;
  String? idColaborador;
  String? porte;
  String? genero;

  Hospedagem();

  Hospedagem.fromMap(Map map) {
    id = map[idColuna];
    idPet = map[idPetColuna];
    fotoPet = map[fotoPetColuna];
    nomeContato = map[nomeContatoColuna];
    nomePet = map[nomePetColuna];
    dataCheckIn = map[dataCheckInColuna];
    horaCheckIn = map[horaCheckInColuna];
    dataCheckOut = map[dataCheckOutColuna];
    horaCheckOut = map[horaCheckOutColuna];
    dia = map[diaColuna];
    valorDia = map[valorDiaColuna];
    adicional = map[adicionalColuna];
    valorTotal = map[valorTotalColuna];
    observacao = map[observacaoColuna];
    status = map[statusColuna];
    colaborador = map[colaboradorColuna];
    idColaborador = map[idColaboradorColuna];
    porte = map[porteColuna];
    genero = map[generoColuna];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      idPetColuna: idPet,
      fotoPetColuna: fotoPet,
      nomeContatoColuna: nomeContato,
      nomePetColuna: nomePet,
      dataCheckInColuna: dataCheckIn,
      horaCheckInColuna: horaCheckIn,
      dataCheckOutColuna: dataCheckOut,
      horaCheckOutColuna: horaCheckOut,
      diaColuna: dia,
      valorDiaColuna: valorDia,
      adicionalColuna: adicional,
      valorTotalColuna: valorTotal,
      observacaoColuna: observacao,
      statusColuna: status,
      colaboradorColuna: colaborador,
      idColaboradorColuna: idColaborador,
      porteColuna: porte,
      generoColuna: genero,
    };

    if (id != null) {
      map[idColuna] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Hospedagem(id: $id,idPet: $idPet,fotoPet: $fotoPet,nomeContato: $nomeContato,nomePet: $nomePet,dataCheckIn: $dataCheckIn,horaCheckIn: $horaCheckIn,dataCheckOut: $dataCheckOut,horaCheckOut: $horaCheckOut,dia: $dia, valorDia: $valorDia,adicional: $adicional,valorTotal: $valorTotal,observacao: $observacao, status: $status,colaborador: $colaborador, idColaborador: $idColaborador, porte: $porte, genero: $genero)";
  }
}