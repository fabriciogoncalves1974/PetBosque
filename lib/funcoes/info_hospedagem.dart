import 'dart:convert';

import 'package:http/http.dart' as http;
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
/*
  Future<List> obterTodasHospedagemDiaFirestore(data) async {
    CollectionReference hospedagemCollection =
        FirebaseFirestore.instance.collection('hospedagem');
    var result = await hospedagemCollection
        .where('dataCheckIn', isEqualTo: '$data')
        .orderBy('horaCheckIn', descending: true)
        .get();
    return result.docs
        .map((doc) => Hospedagem(
            idPet: doc['idPet'],
            nomeContato: doc['nomeContato'],
            fotoPet: doc['fotoPet'],
            nomePet: doc['nomePet'],
            dataCheckIn: doc['dataCheckIn'],
            horaCheckIn: doc['horaCheckIn'],
            dataCheckOut: doc['dataCheckOut'],
            horaCheckOut: doc['horaCheckOut'],
            dia: doc['dia'],
            valorDia: doc['valorDia'],
            adicional: doc['adicional'],
            valorTotal: doc['valorTotal'],
            observacao: doc['observacao'],
            status: doc['status'],
            colaborador: doc['colaborador'],
            idColaborador: doc['idColaborador'],
            porte: doc['porte'],
            genero: doc['genero'],
            id: doc['idHospedagem']))
        .toList();
  }

  Future<List> obterTodasHospedagemFirestore(status) async {
    CollectionReference hospedagemCollection =
        FirebaseFirestore.instance.collection('hospedagem');
    var result = await hospedagemCollection
        .where('status', isEqualTo: '$status')
        .orderBy('dataCheckIn', descending: true)
        .get();
    return result.docs
        .map((doc) => Hospedagem(
            idPet: doc['idPet'],
            nomeContato: doc['nomeContato'],
            fotoPet: doc['fotoPet'],
            nomePet: doc['nomePet'],
            dataCheckIn: doc['dataCheckIn'],
            horaCheckIn: doc['horaCheckIn'],
            dataCheckOut: doc['dataCheckOut'],
            horaCheckOut: doc['horaCheckOut'],
            dia: doc['dia'],
            valorDia: doc['valorDia'],
            adicional: doc['adicional'],
            valorTotal: doc['valorTotal'],
            observacao: doc['observacao'],
            status: doc['status'],
            colaborador: doc['colaborador'],
            idColaborador: doc['idColaborador'],
            porte: doc['porte'],
            genero: doc['genero'],
            id: doc['idHospedagem']))
        .toList();
  }

  Future<List> obterTodasHospedagemDetalheFirestore(id) async {
    CollectionReference hospedagemCollection =
        FirebaseFirestore.instance.collection('hospedagem');
    var result = await hospedagemCollection
        .where('idHospedagem', isEqualTo: '$id')
        .get();
    return result.docs
        .map((doc) => Hospedagem(
            idPet: doc['idPet'],
            nomeContato: doc['nomeContato'],
            fotoPet: doc['fotoPet'],
            nomePet: doc['nomePet'],
            dataCheckIn: doc['dataCheckIn'],
            horaCheckIn: doc['horaCheckIn'],
            dataCheckOut: doc['dataCheckOut'],
            horaCheckOut: doc['horaCheckOut'],
            dia: doc['dia'],
            valorDia: doc['valorDia'],
            adicional: doc['adicional'],
            valorTotal: doc['valorTotal'],
            observacao: doc['observacao'],
            status: doc['status'],
            colaborador: doc['colaborador'],
            idColaborador: doc['idColaborador'],
            porte: doc['porte'],
            genero: doc['genero'],
            id: doc['idHospedagem']))
        .toList();
  }

  deletarHospedagemFirestore(id) async {
    CollectionReference planoCollection =
        FirebaseFirestore.instance.collection('hospedagem');
    planoCollection.doc(id).delete();
  }*/

//=========================================================================

  //FUNÇÕES API

  Future<List> obterTodasHospedagensApi() async {
    final url = Uri.http(
        'fb.servicos.ws', '/petBosque/hospedagem/lista', {'q': '{http}'});

    final response = await http.get(url);
    final map = await jsonDecode(response.body);
    List<Hospedagem> listaHospedagem = [];

    if (map.containsKey("dados") && map["dados"] is List) {
      List listMap = map["dados"];
      for (Map m in listMap) {
        listaHospedagem.add(Hospedagem.fromJson(m));
      }
    }
    return listaHospedagem;
  }

  Future<List> obterTodasHospedagensPetApi(id) async {
    final url = Uri.http(
        'fb.servicos.ws', '/petBosque/hospedagem/pet/$id', {'q': '{http}'});

    final response = await http.get(url);
    final map = await jsonDecode(response.body);
    List<Hospedagem> listaHospedagem = [];
    if (map.containsKey("dados") && map["dados"] is List) {
      List listMap = map["dados"];

      for (Map m in listMap) {
        listaHospedagem.add(Hospedagem.fromJson(m));
      }
    }
    return listaHospedagem;
  }

  Future<List> obterTodasHospedagensStatusApi(String status) async {
    final url = Uri.http('fb.servicos.ws',
        '/petBosque/hospedagem/lista/status/$status', {'q': '{http}'});

    final response = await http.get(url);
    final map = await jsonDecode(response.body);
    List<Hospedagem> listaHospedagem = [];
    if (map.containsKey("dados") && map["dados"] is List) {
      List listMap = map["dados"];

      for (Map m in listMap) {
        listaHospedagem.add(Hospedagem.fromJson(m));
      }
    }
    return listaHospedagem;
  }

  Future<Hospedagem?> obterDetalheHospedagemApi(id) async {
    final url = Uri.http(
        'fb.servicos.ws', '/petBosque/hospedagem/lista/$id', {'q': '{http}'});

    final response = await http.get(url);
    final map = await jsonDecode(response.body);
    //List<dynamic> listMap = map["dados"];

    // Map<String, dynamic> primeiroMap = listMap.first;

    Hospedagem primeiraHospedagem = Hospedagem.fromJson(map["dados"]);
    return primeiraHospedagem;
  }

  Future<String> salvarHospedagemApi(Hospedagem hospedagem) async {
    final url = Uri.http(
        'fb.servicos.ws', '/petBosque/hospedagem/adiciona', {'q': '{http}'});

    final response = await http.post(
      Uri.parse("$url"),
      body: {
        "idPet": hospedagem.idPet.toString(),
        "adicional": hospedagem.adicional.toString(),
        'colaborador': hospedagem.colaborador.toString(),
        'dataCheckIn': hospedagem.dataCheckIn.toString(),
        'dataCheckOut': hospedagem.dataCheckOut.toString(),
        'dia': hospedagem.dia.toString(),
        'fotoPet': hospedagem.fotoPet.toString(),
        'genero': hospedagem.genero.toString(),
        'horaCheckIn': hospedagem.horaCheckIn.toString(),
        'horaCheckOut': hospedagem.horaCheckOut.toString(),
        'idColaborador': hospedagem.idColaborador.toString(),
        'nomeContato': hospedagem.nomeContato.toString(),
        'nomePet': hospedagem.nomePet.toString(),
        'observacao': hospedagem.observacao.toString(),
        'porte': hospedagem.porte.toString(),
        'status': hospedagem.status.toString(),
        'valorDia': hospedagem.valorDia.toString(),
        'valorTotal': hospedagem.valorTotal.toString(),
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

  Future<String> AtualizarHospedagemApi(Hospedagem hospedagem) async {
    final url = Uri.http('fb.servicos.ws',
        '/petBosque/hospedagem/update/' + hospedagem.id, {'q': '{http}'});

    final response = await http.post(
      Uri.parse("$url"),
      body: {
        "_method": "PUT",
        'idPet': hospedagem.idPet.toString(),
        'adicional': hospedagem.adicional.toString(),
        'colaborador': hospedagem.colaborador.toString(),
        'dataCheckIn': hospedagem.dataCheckIn.toString(),
        'dataCheckOut': hospedagem.dataCheckOut.toString(),
        'dia': hospedagem.dia.toString(),
        'fotoPet': hospedagem.fotoPet.toString(),
        'genero': hospedagem.genero.toString(),
        'horaCheckIn': hospedagem.horaCheckIn.toString(),
        'horaCheckOut': hospedagem.horaCheckOut.toString(),
        'idColaborador': hospedagem.idColaborador.toString(),
        'nomeContato': hospedagem.nomeContato.toString(),
        'nomePet': hospedagem.nomePet.toString(),
        'observacao': hospedagem.observacao.toString(),
        'porte': hospedagem.porte.toString(),
        'status': hospedagem.status.toString(),
        'valorDia': hospedagem.valorDia.toString(),
        'valorTotal': hospedagem.valorTotal.toString(),
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

  Future<String> atualizarStatusApi(String id, String status,
      String colaborador, String idColaborador) async {
    final url = Uri.http(
        'fb.servicos.ws', '/petBosque/hospedagem/status/$id', {'q': '{http}'});

    final response = await http.post(
      Uri.parse("$url"),
      body: {
        "_method": "PUT",
        "status": status.toString(),
        "colaborador": colaborador.toString(),
        "idColaborador": idColaborador.toString(),
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

  Future<String> excluirHospedagemApi(id) async {
    final url = Uri.http(
        'fb.servicos.ws',
        // ignore: prefer_interpolation_to_compose_strings
        '/petBosque/hospedagem/delete/' + id,
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

class Hospedagem {
  dynamic id;
  String? idPet;
  String? nomeContato;
  String? fotoPet;
  String? nomePet;
  dynamic dataCheckIn;
  dynamic horaCheckIn;
  dynamic dataCheckOut;
  dynamic horaCheckOut;
  dynamic dia;
  dynamic valorDia;
  dynamic adicional;
  dynamic valorTotal;
  String? observacao;
  String? status;
  String? colaborador;
  String? idColaborador;
  String? porte;
  String? genero;

  Hospedagem(
      {this.idPet,
      this.adicional,
      this.colaborador,
      this.dataCheckIn,
      this.dataCheckOut,
      this.dia,
      this.fotoPet,
      this.genero,
      this.horaCheckIn,
      this.horaCheckOut,
      this.id,
      this.idColaborador,
      this.nomeContato,
      this.nomePet,
      this.observacao,
      this.porte,
      this.status,
      this.valorDia,
      this.valorTotal});

  factory Hospedagem.fromJson(Map json) {
    return Hospedagem(
      id: json['id'],
      idPet: json['idPet'],
      colaborador: json['colaborador'],
      adicional: json['adicional'],
      dataCheckIn: json['dataCheckIn'],
      dataCheckOut: json['dataCheckOut'],
      dia: json['dia'],
      fotoPet: json['fotoPet'],
      genero: json['genero'],
      horaCheckIn: json['horaCheckIn'],
      horaCheckOut: json['horaCheckOut'],
      idColaborador: json['idColaborador'],
      nomeContato: json['nomeContato'],
      nomePet: json['nomePet'],
      observacao: json['observacao'],
      porte: json['porte'],
      status: json['status'],
      valorDia: json['valorDia'],
      valorTotal: json['valorTotal'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'idPet': this.idPet,
        'adicional': this.adicional,
        'colaborador': this.colaborador,
        'dataCheckIn': this.dataCheckIn,
        'dataCheckOut': this.dataCheckOut,
        'dia': this.dia,
        'fotoPet': this.fotoPet,
        'genero': this.genero,
        'horaCheckIn': this.horaCheckIn,
        'horaCheckOut': this.horaCheckOut,
        'idColaborador': this.idColaborador,
        'nomeContato': this.nomeContato,
        'nomePet': this.nomePet,
        'observacao': this.observacao,
        'porte': this.porte,
        'status': this.status,
        'valorDia': this.valorDia,
        'valorTotal': this.valorTotal
      };

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
