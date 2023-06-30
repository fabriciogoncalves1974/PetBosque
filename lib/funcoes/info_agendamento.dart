import 'package:sqflite/sqflite.dart'
    show Sqflite, getDatabasesPath, openDatabase;
import 'package:sqflite/sqlite_api.dart';

import '../database/sqflite/db.dart';

const String tabelaAgendamento = "tabelaAgendamento";
const String idColuna = "id";
const String idPetColuna = "idPet";
const String fotoPetColuna = "fotoPet";
const String nomeContatoColuna = "nomeContato";
const String nomePetColuna = "nomePet";
const String dataColuna = "data";
const String horaColuna = "hora";
const String svBanhoColuna = "svBanho";
const String valorBanhoColuna = "valorBanho";
const String svTosaColuna = "svTosa";
const String valorTosaColuna = "valorTosa";
const String svCorteUnhaColuna = "svCorteUnha";
const String valorCorteUnhaColuna = "valorCorteUnha";
const String svHidratacaoColuna = "svHidratacao";
const String valorHidratacaoColuna = "valorHidratacao";
const String svTosaHigienicaColuna = "svTosaHigienica";
const String valorTosaHigienicaColuna = "valorTosaHigienica";
const String svPinturaColuna = "svPintura";
const String valorPinturaColuna = "valorPintura";
const String svHospedagemColuna = "svHospedagem";
const String valorHospedagemColuna = "valorHospedagem";
const String svTransporteColuna = "svTransporte";
const String valorTransporteColuna = "valorTransporte";
const String valorAdicionalColuna = "valorAdicional";
const String valorTotalColuna = "valorTotal";
const String observacaoColuna = "observacao";
const String statusColuna = "status";
const String colaboradorColuna = "colaborador";
const String idColaboradorColuna = "idColaborador";
const String planoVencidoColuna = "planoVencido";

class InfoAgendamento {
  static final InfoAgendamento _instance = InfoAgendamento.internal();

  factory InfoAgendamento() => _instance;

  InfoAgendamento.internal();

  Future<Agendamento> salvarAgendamento(Agendamento agendamento) async {
    Database? db = await DB.instance.database;
    Database? dbAgendamento = db;
    agendamento.id =
        await dbAgendamento!.insert(tabelaAgendamento, agendamento.toMap());
    return agendamento;
  }

  Future<List> obterAgendamentoContato(id) async {
    Database? db = await DB.instance.database;
    Database? dbAgendamento = db;
    List listMap = await dbAgendamento!
        .rawQuery("SELECT * FROM $tabelaAgendamento WHERE id = $id");
    List<Agendamento> listaAgendamento = [];
    for (Map m in listMap) {
      listaAgendamento.add(Agendamento.fromMap(m));
    }
    return listaAgendamento;
  }

  Future<Agendamento?> obterAgendamento(int id) async {
    Database? db = await DB.instance.database;
    Database? dbAgendamento = db;
    List<Map> maps = await dbAgendamento!.query(tabelaAgendamento,
        columns: [
          idColuna,
          idPetColuna,
          fotoPetColuna,
          nomeContatoColuna,
          nomePetColuna,
          dataColuna,
          horaColuna,
          svBanhoColuna,
          valorBanhoColuna,
          svTosaColuna,
          valorTosaColuna,
          svCorteUnhaColuna,
          valorCorteUnhaColuna,
          svHidratacaoColuna,
          valorHidratacaoColuna,
          svTosaHigienicaColuna,
          valorTosaHigienicaColuna,
          svPinturaColuna,
          valorPinturaColuna,
          svHospedagemColuna,
          valorHospedagemColuna,
          svTransporteColuna,
          valorTransporteColuna,
          valorAdicionalColuna,
          valorTotalColuna,
          observacaoColuna,
          statusColuna,
          colaboradorColuna,
          idColaboradorColuna,
          planoVencidoColuna
        ],
        where: "$idColuna = ?",
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Agendamento.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deletarAgendamento(int id) async {
    Database? db = await DB.instance.database;
    Database? dbAgendamento = db;
    return await dbAgendamento!
        .delete(tabelaAgendamento, where: "$idColuna = ?", whereArgs: [id]);
  }

  Future<int> atualizarAgendamento(Agendamento agendamento) async {
    Database? db = await DB.instance.database;
    Database? dbAgendamento = db;
    return dbAgendamento!.update(tabelaAgendamento, agendamento.toMap(),
        where: "$idColuna = ?", whereArgs: [agendamento.id]);
  }

  Future<List> obterTodosAgendamentos(dataAge) async {
    Database? db = await DB.instance.database;
    Database? dbAgendamento = db;
    List listMap = await dbAgendamento!.rawQuery(
        "SELECT * FROM $tabelaAgendamento WHERE data  LIKE '%$dataAge%' ORDER BY hora");
    List<Agendamento> listaAgendamento = [];
    for (Map m in listMap) {
      listaAgendamento.add(Agendamento.fromMap(m));
    }
    return listaAgendamento;
  }

  Future<List> obterTodosAgendamentosPendentes() async {
    Database? db = await DB.instance.database;
    Database? dbAgendamento = db;
    List listMap = await dbAgendamento!.rawQuery(
        "SELECT * FROM $tabelaAgendamento WHERE status = 'Pendente' ORDER BY data DESC ");
    List<Agendamento> listaAgendamento = [];
    for (Map m in listMap) {
      listaAgendamento.add(Agendamento.fromMap(m));
    }
    return listaAgendamento;
  }

  Future<List> obterTodosAgendamentosColaborador(idColaborador) async {
    Database? db = await DB.instance.database;
    Database? dbAgendamento = db;
    List listMap = await dbAgendamento!.rawQuery(
        "SELECT * FROM $tabelaAgendamento WHERE idColaborador = '$idColaborador' ORDER BY data");
    List<Agendamento> listaAgendamento = [];
    for (Map m in listMap) {
      listaAgendamento.add(Agendamento.fromMap(m));
    }
    return listaAgendamento;
  }

  Future<int?> quantidadeAgendamentos() async {
    Database? db = await DB.instance.database;
    Database? dbAgendamento = db;
    return Sqflite.firstIntValue(await dbAgendamento!
        .rawQuery("SELECT COUNT(*) FROM $tabelaAgendamento"));
  }

  Future<int?> quantidadeAgendamentosColaborador(int id) async {
    Database? db = await DB.instance.database;
    Database? dbAgendamento = db;
    return Sqflite.firstIntValue(await dbAgendamento!.rawQuery(
        "SELECT COUNT(*) FROM $tabelaAgendamento WHERE idColaborador = $id"));
  }

  Future<int?> quantidadeAgendamentosDia(String data) async {
    Database? db = await DB.instance.database;
    Database? dbAgendamento = db;
    return Sqflite.firstIntValue(await dbAgendamento!.rawQuery(
        "SELECT COUNT(*) FROM $tabelaAgendamento WHERE data == '$data' AND status = 'Pendente'"));
  }

  Future<int?> quantidadeAgendamentosPendentes(String data) async {
    Database? db = await DB.instance.database;
    Database? dbAgendamento = db;
    return Sqflite.firstIntValue(await dbAgendamento!.rawQuery(
        "SELECT COUNT(*) FROM $tabelaAgendamento WHERE data < '$data' AND status = 'Pendente'"));
  }

  Future totalAgendamentosColaborador(int id) async {
    Database? db = await DB.instance.database;
    Database? dbAgendamento = db;
    return await dbAgendamento!.rawQuery(
        "SELECT SUM(valorTotal) as total FROM $tabelaAgendamento WHERE idColaborador = $id");
  }

  Future totalAgendamentosColaboradorAvulso(int id) async {
    Database? db = await DB.instance.database;
    Database? dbAgendamento = db;
    return await dbAgendamento!.rawQuery(
        "SELECT SUM(valorTotal) as total FROM $tabelaAgendamento WHERE planoVencido = 'P' AND idColaborador = $id");
  }

  Future<Future<List<Map<String, Object?>>>> atualizarStatus(
      int id, String status, String colaborador, String idColaborador) async {
    Database? db = await DB.instance.database;
    Database? dbAgendamento = db;
    return dbAgendamento!.rawQuery(
        "UPDATE '$tabelaAgendamento' SET  status = '$status', colaborador = '$colaborador' , idColaborador = '$idColaborador' WHERE id = '$id'");
  }

  Future close() async {
    Database? db = await DB.instance.database;
    Database? dbAgendamento = db;
    dbAgendamento!.close();
  }
}

class Agendamento {
  int? id;
  String? idPet;
  String? nomeContato;
  String? fotoPet;
  String? nomePet;
  String? data;
  String? hora;
  String? svBanho;
  double? valorBanho;
  String? svTosa;
  double? valorTosa;
  String? svCorteUnha;
  double? valorCorteUnha;
  String? svHidratacao;
  double? valorHidratacao;
  String? svTosaHigienica;
  double? valorTosaHigienica;
  String? svPintura;
  double? valorPintura;
  String? svHospedagem;
  double? valorHospedagem;
  String? svTransporte;
  double? valorTransporte;
  double? valorAdicional;
  double? valorTotal;
  String? observacao;
  String? status;
  String? colaborador;
  String? idColaborador;
  String? planoVencido;

  Agendamento();

  Agendamento.fromMap(Map map) {
    id = map[idColuna];
    idPet = map[idPetColuna];
    fotoPet = map[fotoPetColuna];
    nomeContato = map[nomeContatoColuna];
    nomePet = map[nomePetColuna];
    data = map[dataColuna];
    hora = map[horaColuna];
    svBanho = map[svBanhoColuna];
    valorBanho = map[valorBanhoColuna];
    svTosa = map[svTosaColuna];
    valorTosa = map[valorTosaColuna];
    svCorteUnha = map[svCorteUnhaColuna];
    valorCorteUnha = map[valorCorteUnhaColuna];
    svHidratacao = map[svHidratacaoColuna];
    valorHidratacao = map[valorHidratacaoColuna];
    svTosaHigienica = map[svTosaHigienicaColuna];
    valorTosaHigienica = map[valorTosaHigienicaColuna];
    svPintura = map[svPinturaColuna];
    valorPintura = map[valorPinturaColuna];
    svHospedagem = map[svHospedagemColuna];
    valorHospedagem = map[valorHospedagemColuna];
    svTransporte = map[svTransporteColuna];
    valorTransporte = map[valorTransporteColuna];
    valorAdicional = map[valorAdicionalColuna];
    valorTotal = map[valorTotalColuna];
    observacao = map[observacaoColuna];
    status = map[statusColuna];
    colaborador = map[colaboradorColuna];
    idColaborador = map[idColaboradorColuna];
    planoVencido = map[planoVencidoColuna];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      idPetColuna: idPet,
      fotoPetColuna: fotoPet,
      nomeContatoColuna: nomeContato,
      nomePetColuna: nomePet,
      dataColuna: data,
      horaColuna: hora,
      svBanhoColuna: svBanho,
      valorBanhoColuna: valorBanho,
      svTosaColuna: svTosa,
      valorTosaColuna: valorTosa,
      svCorteUnhaColuna: svCorteUnha,
      valorCorteUnhaColuna: valorCorteUnha,
      svHidratacaoColuna: svHidratacao,
      valorHidratacaoColuna: valorHidratacao,
      svTosaHigienicaColuna: svTosaHigienica,
      valorTosaHigienicaColuna: valorTosaHigienica,
      svPinturaColuna: svPintura,
      valorPinturaColuna: valorPintura,
      svHospedagemColuna: svHospedagem,
      valorHospedagemColuna: valorHospedagem,
      svTransporteColuna: svTransporte,
      valorTransporteColuna: valorTransporte,
      valorAdicionalColuna: valorAdicional,
      valorTotalColuna: valorTotal,
      observacaoColuna: observacao,
      statusColuna: status,
      colaboradorColuna: colaborador,
      idColaboradorColuna: idColaborador,
      planoVencidoColuna: planoVencido,
    };

    if (id != null) {
      map[idColuna] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Agendamento(id: $id,idPet: $idPet,fotoPet: $fotoPet,nomeContato: $nomeContato,nomePet: $nomePet,data: $data,hora: $hora,svBanho: $svBanho,valorBanho: $valorBanho,svTosa: $svTosa,valorTosa: $valorTosa,svCorteUnha: $svCorteUnha,valorCorteUnha: $valorCorteUnha,svHidratacao: $svHidratacao,valorHidratacao: $valorHidratacao,svTosaHigienica: $svTosaHigienica,valorTosaHigienica: $valorTosaHigienica,svPintura: $svPintura,valorPintura: $valorPintura,svHospedagem: $svHospedagem,valorHospedagem: $valorHospedagem,svTransporte: $svTransporte,valorTransporte: $valorTransporte,valorTotal: $valorTotal,valorAdicional: $valorAdicional,observacao: $observacao, status: $status,colaborador: $colaborador, idColaborador: $idColaborador, planoVencido: $planoVencido)";
  }
}
