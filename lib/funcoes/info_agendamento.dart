import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
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
const String idParticipanteColuna = "idParticipante";
const String participanteColuna = "participante";
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
          idParticipanteColuna,
          participanteColuna,
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

  Future<List> obterTodosAgendamentosFirestore(dataAge) async {
    CollectionReference agendamentoCollection =
        FirebaseFirestore.instance.collection('agendamentos');
    var result = await agendamentoCollection
        .where('data', isEqualTo: '$dataAge')
        .where('status', isEqualTo: 'Pendente')
        .get();
    return result.docs
        .map((doc) => Agendamento(
            idPet: doc['idPet'],
            nomeContato: doc['nomeContato'],
            fotoPet: doc['fotoPet'],
            nomePet: doc['nomePet'],
            data: doc['data'],
            hora: doc['hora'],
            svBanho: doc['svBanho'],
            valorBanho: doc['valorBanho'],
            svTosa: doc['svTosa'],
            valorTosa: doc['valorTosa'],
            svCorteUnha: doc['svCorteUnha'],
            valorCorteUnha: doc['valorCorteUnha'],
            svHidratacao: doc['svHidratacao'],
            valorHidratacao: doc['valorHidratacao'],
            svTosaHigienica: doc['svTosaHigienica'],
            valorTosaHigienica: doc['valorTosaHigienica'],
            svPintura: doc['svPintura'],
            valorPintura: doc['valorPintura'],
            svHospedagem: doc['svHospedagem'],
            valorHospedagem: doc['valorHospedagem'],
            svTransporte: doc['svTransporte'],
            valorTransporte: doc['valorTransporte'],
            valorAdicional: doc['valorAdicional'],
            valorTotal: doc['valorTotal'],
            observacao: doc['observacao'],
            status: doc['status'],
            colaborador: doc['colaborador'],
            idColaborador: doc['idColaborador'],
            idParticipante: doc['idParticipante'],
            participante: doc['participante'],
            planoVencido: doc['planoVencido'],
            id: doc['idAgendamento']))
        .toList();
  }

  Future<List> obterTodosAgendamentosPendentesFirestore() async {
    CollectionReference agendamentoCollection =
        FirebaseFirestore.instance.collection('agendamentos');
    var result = await agendamentoCollection
        .where('status', isEqualTo: 'Pendente')
        .get();
    return result.docs
        .map((doc) => Agendamento(
            idPet: doc['idPet'],
            nomeContato: doc['nomeContato'],
            fotoPet: doc['fotoPet'],
            nomePet: doc['nomePet'],
            data: doc['data'],
            hora: doc['hora'],
            svBanho: doc['svBanho'],
            valorBanho: doc['valorBanho'],
            svTosa: doc['svTosa'],
            valorTosa: doc['valorTosa'],
            svCorteUnha: doc['svCorteUnha'],
            valorCorteUnha: doc['valorCorteUnha'],
            svHidratacao: doc['svHidratacao'],
            valorHidratacao: doc['valorHidratacao'],
            svTosaHigienica: doc['svTosaHigienica'],
            valorTosaHigienica: doc['valorTosaHigienica'],
            svPintura: doc['svPintura'],
            valorPintura: doc['valorPintura'],
            svHospedagem: doc['svHospedagem'],
            valorHospedagem: doc['valorHospedagem'],
            svTransporte: doc['svTransporte'],
            valorTransporte: doc['valorTransporte'],
            valorAdicional: doc['valorAdicional'],
            valorTotal: doc['valorTotal'],
            observacao: doc['observacao'],
            status: doc['status'],
            colaborador: doc['colaborador'],
            idColaborador: doc['idColaborador'],
            idParticipante: doc['idParticipante'],
            participante: doc['participante'],
            planoVencido: doc['planoVencido'],
            id: doc['idAgendamento']))
        .toList();
  }

  Future<List> obterAgendamentoDetalheFirestore(id) async {
    CollectionReference agendamentoCollection =
        FirebaseFirestore.instance.collection('agendamentos');
    var result = await agendamentoCollection
        .where('idAgendamento', isEqualTo: '$id')
        .get();
    return result.docs
        .map((doc) => Agendamento(
            idPet: doc['idPet'],
            nomeContato: doc['nomeContato'],
            fotoPet: doc['fotoPet'],
            nomePet: doc['nomePet'],
            data: doc['data'],
            hora: doc['hora'],
            svBanho: doc['svBanho'],
            valorBanho: doc['valorBanho'],
            svTosa: doc['svTosa'],
            valorTosa: doc['valorTosa'],
            svCorteUnha: doc['svCorteUnha'],
            valorCorteUnha: doc['valorCorteUnha'],
            svHidratacao: doc['svHidratacao'],
            valorHidratacao: doc['valorHidratacao'],
            svTosaHigienica: doc['svTosaHigienica'],
            valorTosaHigienica: doc['valorTosaHigienica'],
            svPintura: doc['svPintura'],
            valorPintura: doc['valorPintura'],
            svHospedagem: doc['svHospedagem'],
            valorHospedagem: doc['valorHospedagem'],
            svTransporte: doc['svTransporte'],
            valorTransporte: doc['valorTransporte'],
            valorAdicional: doc['valorAdicional'],
            valorTotal: doc['valorTotal'],
            observacao: doc['observacao'],
            status: doc['status'],
            colaborador: doc['colaborador'],
            idColaborador: doc['idColaborador'],
            idParticipante: doc['idParticipante'],
            participante: doc['participante'],
            planoVencido: doc['planoVencido'],
            id: doc['idAgendamento']))
        .toList();
  }

  Future<List> obterTodosAgendamentosColaboradorFirestore(id) async {
    CollectionReference agendamentoCollection =
        FirebaseFirestore.instance.collection('agendamentos');
    var result = await agendamentoCollection
        .where('idColaborador', isEqualTo: '$id')
        .get();
    return result.docs
        .map((doc) => Agendamento(
            idPet: doc['idPet'],
            nomeContato: doc['nomeContato'],
            fotoPet: doc['fotoPet'],
            nomePet: doc['nomePet'],
            data: doc['data'],
            hora: doc['hora'],
            svBanho: doc['svBanho'],
            valorBanho: doc['valorBanho'],
            svTosa: doc['svTosa'],
            valorTosa: doc['valorTosa'],
            svCorteUnha: doc['svCorteUnha'],
            valorCorteUnha: doc['valorCorteUnha'],
            svHidratacao: doc['svHidratacao'],
            valorHidratacao: doc['valorHidratacao'],
            svTosaHigienica: doc['svTosaHigienica'],
            valorTosaHigienica: doc['valorTosaHigienica'],
            svPintura: doc['svPintura'],
            valorPintura: doc['valorPintura'],
            svHospedagem: doc['svHospedagem'],
            valorHospedagem: doc['valorHospedagem'],
            svTransporte: doc['svTransporte'],
            valorTransporte: doc['valorTransporte'],
            valorAdicional: doc['valorAdicional'],
            valorTotal: doc['valorTotal'],
            observacao: doc['observacao'],
            status: doc['status'],
            colaborador: doc['colaborador'],
            idColaborador: doc['idColaborador'],
            idParticipante: doc['idParticipante'],
            participante: doc['participante'],
            planoVencido: doc['planoVencido'],
            id: doc['idAgendamento']))
        .toList();
  }

  Future<int?> quantidadeAgendamentosColaboradorFirestore(id) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var qtd = db.collection("contato").count().get();
    return null;
  }

  deletarAgendamentoFirestore(id) async {
    CollectionReference planoCollection =
        FirebaseFirestore.instance.collection('agendamentos');
    planoCollection.doc(id).delete();
  }

//=========================================================================

  //FUNÇÕES API

  Future<List> obterTodosAgendamentosApi() async {
    final url = Uri.http(
        'fb.servicos.ws', '/petBosque/agendamento/lista', {'q': '{http}'});

    final response = await http.get(url);
    final map = await jsonDecode(response.body);
    List<Agendamento> listaPlano = [];

    if (map.containsKey("dados") && map["dados"] is List) {
      List listMap = map["dados"];
      for (Map m in listMap) {
        listaPlano.add(Agendamento.fromJson(m));
      }
    }
    return listaPlano;
  }

  Future<String> salvarAgendamentoApi(Agendamento agendamento) async {
    final url = Uri.http(
        'fb.servicos.ws', '/petBosque/agendamento/adiciona', {'q': '{http}'});

    final response = await http.post(
      Uri.parse("$url"),
      body: {
        "idPet": agendamento.idPet.toString(),
        "colaborador": agendamento.colaborador.toString(),
        "data": agendamento.data.toString(),
        "fotoPet": agendamento.fotoPet.toString(),
        "hora": agendamento.hora.toString(),
        "idColaborador": agendamento.idColaborador.toString(),
        "idParticipante": agendamento.idParticipante.toString(),
        "participante": agendamento.participante.toString(),
        "nomeContato": agendamento.nomeContato.toString(),
        "nomePet": agendamento.nomePet.toString(),
        "observacao": agendamento.observacao.toString(),
        "planoVencido": agendamento.planoVencido.toString(),
        "status": agendamento.status.toString(),
        "svBanho": agendamento.svBanho.toString(),
        "svCorteUnha": agendamento.svCorteUnha.toString(),
        "svHidratacao": agendamento.svHidratacao.toString(),
        "svHospedagem": agendamento.svHospedagem.toString(),
        "svPintura": agendamento.svPintura.toString(),
        "svTosa": agendamento.svTosa.toString(),
        "svTosaHigienica": agendamento.svTosaHigienica.toString(),
        "svTransporte": agendamento.svTransporte.toString(),
        "valorAdicional": agendamento.valorAdicional.toString(),
        "valorBanho": agendamento.valorBanho.toString(),
        "valorCorteUnha": agendamento.valorCorteUnha.toString(),
        "valorHidratacao": agendamento.valorHidratacao.toString(),
        "valorHospedagem": agendamento.valorHospedagem.toString(),
        "valorPintura": agendamento.valorPintura.toString(),
        "valorTosa": agendamento.valorTosa.toString(),
        "valorTosaHigienica": agendamento.valorTosaHigienica.toString(),
        "valorTotal": agendamento.valorTotal.toString(),
        "valorTransporte": agendamento.valorTransporte.toString(),
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

  Future<String> excluirPlanoApi(id) async {
    final url = Uri.http(
        'fb.servicos.ws',
        // ignore: prefer_interpolation_to_compose_strings
        '/petBosque/agendamento/delete/' + id,
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

//=======================================================================
}

class Agendamento {
  dynamic id;
  String? idPet;
  String? nomeContato;
  String? fotoPet;
  String? nomePet;
  String? data;
  String? hora;
  String? svBanho;
  dynamic valorBanho;
  String? svTosa;
  dynamic valorTosa;
  String? svCorteUnha;
  dynamic valorCorteUnha;
  String? svHidratacao;
  dynamic valorHidratacao;
  String? svTosaHigienica;
  dynamic valorTosaHigienica;
  String? svPintura;
  dynamic valorPintura;
  String? svHospedagem;
  dynamic valorHospedagem;
  String? svTransporte;
  dynamic valorTransporte;
  dynamic valorAdicional;
  dynamic valorTotal;
  String? observacao;
  String? status;
  String? colaborador;
  String? idColaborador;
  String? idParticipante;
  String? participante;
  dynamic planoVencido;

  Agendamento(
      {this.idPet,
      this.colaborador,
      this.data,
      this.fotoPet,
      this.hora,
      this.id,
      this.idColaborador,
      this.idParticipante,
      this.participante,
      this.nomeContato,
      this.nomePet,
      this.observacao,
      this.planoVencido,
      this.status,
      this.svBanho,
      this.svCorteUnha,
      this.svHidratacao,
      this.svHospedagem,
      this.svPintura,
      this.svTosa,
      this.svTosaHigienica,
      this.svTransporte,
      this.valorAdicional,
      this.valorBanho,
      this.valorCorteUnha,
      this.valorHidratacao,
      this.valorHospedagem,
      this.valorPintura,
      this.valorTosa,
      this.valorTosaHigienica,
      this.valorTotal,
      this.valorTransporte});

  factory Agendamento.fromJson(Map json) {
    return Agendamento(
      id: json['id'],
      idPet: json['idPet'],
      colaborador: json['colaborador'],
      data: json['data'],
      fotoPet: json['fotoPet'],
      hora: json['hora'],
      idColaborador: json['colaborador'],
      idParticipante: json['idParticipante'],
      participante: json['participante'],
      nomeContato: json['nomeContato'],
      nomePet: json['nomePet'],
      observacao: json['observacao'],
      planoVencido: json['planoVencido'],
      status: json['status'],
      svBanho: json['svBanho'],
      svCorteUnha: json['svCorteUnha'],
      svHidratacao: json['svHidratacao'],
      svHospedagem: json['svHospedagem'],
      svPintura: json['svPintura'],
      svTosa: json['svTosa'],
      svTosaHigienica: json['svTosaHigienica'],
      svTransporte: json['svTransporte'],
      valorAdicional: json['valorAdicional'],
      valorBanho: json['valorBanho'],
      valorCorteUnha: json['valorCorteUnha'],
      valorHidratacao: json['valorHidratacao'],
      valorHospedagem: json['valorHospedagem'],
      valorPintura: json['valorPintura'],
      valorTosa: json['valorTosa'],
      valorTosaHigienica: json['valorTosaHigienica'],
      valorTotal: json['valorTotal'],
      valorTransporte: json['valorTransporte'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'idPet': this.idPet,
        'colaborador': this.colaborador,
        'data': this.data,
        'fotoPet': this.fotoPet,
        'hora': this.hora,
        'idColaborador': this.idColaborador,
        'idParticipante': this.idParticipante,
        'participante': this.participante,
        'nomeContato': this.nomeContato,
        'nomePet': this.nomePet,
        'observacao': this.observacao,
        'planoVencido': this.planoVencido,
        'status': this.status,
        'svBanho': this.svBanho,
        'svCorteUnha': this.svCorteUnha,
        'svHidratacao': this.svHidratacao,
        'svHospedagem': this.svHospedagem,
        'svPintura': this.svPintura,
        'svTosa': this.svTosa,
        'svTosaHigienica': this.svTosaHigienica,
        'svTransporte': this.svTransporte,
        'valorAdicional': this.valorAdicional,
        'valorBanho': this.valorBanho,
        'valorCorteUnha': this.valorCorteUnha,
        'valorHidratacao': this.valorHidratacao,
        'valorHospedagem': this.valorHospedagem,
        'valorPintura': this.valorPintura,
        'valorTosa': this.valorTosa,
        'valorTosaHigienica': this.valorTosaHigienica,
        'valorTotal': this.valorTotal,
        'valorTransporte': this.valorTransporte
      };

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
    idParticipante = map[idParticipanteColuna];
    participante = map[participanteColuna];
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
      idParticipanteColuna: idParticipante,
      participanteColuna: participante,
      planoVencidoColuna: planoVencido,
    };

    if (id != null) {
      map[idColuna] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Agendamento(id: $id,idPet: $idPet,fotoPet: $fotoPet,nomeContato: $nomeContato,nomePet: $nomePet,data: $data,hora: $hora,svBanho: $svBanho,valorBanho: $valorBanho,svTosa: $svTosa,valorTosa: $valorTosa,svCorteUnha: $svCorteUnha,valorCorteUnha: $valorCorteUnha,svHidratacao: $svHidratacao,valorHidratacao: $valorHidratacao,svTosaHigienica: $svTosaHigienica,valorTosaHigienica: $valorTosaHigienica,svPintura: $svPintura,valorPintura: $valorPintura,svHospedagem: $svHospedagem,valorHospedagem: $valorHospedagem,svTransporte: $svTransporte,valorTransporte: $valorTransporte,valorTotal: $valorTotal,valorAdicional: $valorAdicional,observacao: $observacao, status: $status,colaborador: $colaborador, idColaborador: $idColaborador,idParticipante: $idParticipante, participante: $participante, planoVencido: $planoVencido)";
  }
}
