import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart'
    show Sqflite, getDatabasesPath, openDatabase;
import 'package:sqflite/sqlite_api.dart';

import '../database/sqflite/db.dart';

const String tabelaPet = "tabelaPet";
const String idColuna = "id";
const String idPetColuna = "idPet";
const String idContatoColuna = "idContato";
const String nomePetColuna = "nomePet";
const String racaColuna = "raca";
const String pesoColuna = "peso";
const String generoColuna = "genero";
const String dtNascColuna = "dtNasc";
const String especieColuna = "especie";
const String corColuna = "cor";
const String fotoColuna = "foto";
const String nomeContatoColuna = "nomeContato";
const String contaPlanoColuna = "contaPlano";
const String nomePlanoColuna = "nomePlano";
const String idPlanoColuna = "idPlano";
const String dataContratoColuna = "dataContrato";
const String dataCadastroColuna = "dataCadastro";
const String valorPlanoColuna = "valorPlano";
const String porteColuna = "porte";
const String planoVencidoColuna = "planoVencido";

class InfoPet {
  static final InfoPet _instance = InfoPet.internal();

  factory InfoPet() => _instance;

  InfoPet.internal();

  Future<Pet> salvarPet(Pet pet) async {
    Database? db = await DB.instance.database;
    Database? dbPet = db;
    pet.id = await dbPet!.insert(tabelaPet, pet.toMap());
    return pet;
  }

  Future<Pet?> obterPet(int id) async {
    Database? db = await DB.instance.database;
    Database? dbPet = db;
    List<Map> maps = await dbPet!.query(tabelaPet,
        columns: [
          idColuna,
          idPetColuna,
          idContatoColuna,
          nomePetColuna,
          racaColuna,
          pesoColuna,
          generoColuna,
          dtNascColuna,
          especieColuna,
          corColuna,
          fotoColuna,
          nomeContatoColuna,
          contaPlanoColuna,
          nomePlanoColuna,
          idPlanoColuna,
          dataContratoColuna,
          dataCadastroColuna,
          valorPlanoColuna,
          porteColuna,
          planoVencidoColuna,
        ],
        where: "$idColuna = ?",
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Pet.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deletarPetContato(int id) async {
    Database? db = await DB.instance.database;
    Database? dbPet = db;
    return await dbPet!
        .delete(tabelaPet, where: "$idContatoColuna = ?", whereArgs: [id]);
  }

  Future<int> deletarPet(int id) async {
    Database? db = await DB.instance.database;
    Database? dbPet = db;
    return await dbPet!
        .delete(tabelaPet, where: "$idColuna = ?", whereArgs: [id]);
  }

  Future<int> atualizarPet(Pet pet) async {
    Database? db = await DB.instance.database;
    Database? dbPet = db;
    return dbPet!.update(tabelaPet, pet.toMap(),
        where: "$idColuna = ?", whereArgs: [pet.id]);
  }

  Future<Future<List<Map<String, Object?>>>> atualizarNomeContato(
      String idContato, String nomeContato) async {
    Database? db = await DB.instance.database;
    Database? dbPet = db;
    return dbPet!.rawQuery(
        "UPDATE '$tabelaPet' SET  nomeContato = '$nomeContato' WHERE idContato = '$idContato'");
  }

  Future<Future<List<Map<String, Object?>>>> atualizarFotoPet(
      String idPet, String fotoPet) async {
    Database? db = await DB.instance.database;
    Database? dbPet = db;
    return dbPet!.rawQuery(
        "UPDATE tabelaAgendamento SET  fotoPet = '$fotoPet' WHERE idPet = '$idPet'");
  }

  Future<Future<List<Map<String, Object?>>>> renovaPlano(
      int idPet, int contadorPlano) async {
    Database? db = await DB.instance.database;
    Database? dbPet = db;
    return dbPet!.rawQuery(
        "UPDATE tabelaPet SET  contaPlano = '$contadorPlano'  WHERE id = '$idPet'");
  }

  Future<Future<List<Map<String, Object?>>>> contaPlanoPet(
      String idPet, int contadorPlano) async {
    Database? db = await DB.instance.database;
    Database? dbPet = db;
    return dbPet!.rawQuery(
        "UPDATE tabelaPet SET  contaPlano = '$contadorPlano' WHERE id = '$idPet'");
  }

  Future<List<Pet>> pesquisarTodosPets(String? teclado) async {
    Database? db = await DB.instance.database;
    Database? dbPet = db;
    List listMap = await dbPet!.rawQuery(
        "SELECT * FROM $tabelaPet WHERE nomePet  LIKE '%$teclado%' OR nomeContato LIKE '%$teclado%'");
    List<Pet> listaPet = [];
    for (Map m in listMap) {
      listaPet.add(Pet.fromMap(m));
    }
    return listaPet;
  }

  Future<Future<List<Map<String, Object?>>>> excluirPetPlano(int id) async {
    Database? db = await DB.instance.database;
    Database? dbPet = db;
    return dbPet!.rawQuery(
        "UPDATE '$tabelaPet' SET  nomePlano = 'N', planoVencido = 'P' , idPlano = '0' , contaPlano = '0' WHERE id = '$id'");
  }

  Future<List> obterTodosPet() async {
    Database? db = await DB.instance.database;
    Database? dbPet = db;
    List listMap = await dbPet!.rawQuery("SELECT * FROM $tabelaPet");
    List<Pet> listaPet = [];
    for (Map m in listMap) {
      listaPet.add(Pet.fromMap(m));
    }
    return listaPet;
  }

  Future<List> obterTodosPetContato(id) async {
    Database? db = await DB.instance.database;
    Database? dbPet = db;
    List listMap =
        await dbPet!.rawQuery("SELECT * FROM $tabelaPet WHERE idContato = $id");
    List<Pet> listaPet = [];
    for (Map m in listMap) {
      listaPet.add(Pet.fromMap(m));
    }
    return listaPet;
  }

  Future<Future<List<Map<String, Object?>>>> atualizaPlanoVencido(
      int id, String planoVencido) async {
    Database? db = await DB.instance.database;
    Database? dbPet = db;
    return dbPet!.rawQuery(
        "UPDATE '$tabelaPet' SET  planovencido = '$planoVencido' WHERE id = '$id'");
  }

  Future<int?> quantidadePet() async {
    Database? db = await DB.instance.database;
    Database? dbPet = db;
    return Sqflite.firstIntValue(
        await dbPet!.rawQuery("SELECT COUNT(*) FROM $tabelaPet"));
  }

  Future close() async {
    Database? db = await DB.instance.database;
    Database? dbPet = db;
    dbPet!.close();
  }

//FUNÇÕES API

  Future<List> obterTodosPetApi() async {
    final url =
        Uri.http('fb.servicos.ws', '/petBosque/pet/lista', {'q': '{http}'});

    final response = await http.get(url);
    final map = await jsonDecode(response.body);
    List listMap = map["dados"];
    List<Pet> listaPet = [];
    for (Map m in listMap) {
      listaPet.add(Pet.fromJson(m));
    }
    return listaPet;
  }

  Future<List> obterTodosPetClienteApi(id) async {
    final url = Uri.http(
        'fb.servicos.ws', '/petBosque/pet/cliente/$id', {'q': '{http}'});

    final response = await http.get(url);
    final map = await jsonDecode(response.body);
    List<Pet> listaPet = [];
    if (map.containsKey("dados") && map["dados"] is List) {
      List listMap = map["dados"];

      for (Map m in listMap) {
        listaPet.add(Pet.fromJson(m));
      }
    }
    return listaPet;
  }

  Future<Pet?> obterDadosPetApi(id) async {
    final url =
        Uri.http('fb.servicos.ws', '/petBosque/pet/lista/$id', {'q': '{http}'});

    final response = await http.get(url);
    final map = await jsonDecode(response.body);
    //List<dynamic> listMap = map["dados"];

    // Map<String, dynamic> primeiroMap = listMap.first;
    Pet primeiroPet = Pet.fromJson(map["dados"]);
    return primeiroPet;
  }

  Future<List<Pet>> pesquisarPetApi(String teclado) async {
    final url = Uri.http(
        'fb.servicos.ws', '/petBosque/pet/pesquisa/$teclado', {'q': '{http}'});

    final response = await http.get(url);
    final map = await jsonDecode(response.body);
    List<Pet> listaPet = [];
    if (map.containsKey("dados") && map["dados"] is List) {
      List listMap = map["dados"];

      for (Map m in listMap) {
        listaPet.add(Pet.fromJson(m));
      }
    }
    return listaPet;
  }

  Future<String> salvarPetApi(Pet pet) async {
    final url =
        Uri.http('fb.servicos.ws', '/petBosque/pet/adiciona', {'q': '{http}'});

    final response = await http.post(
      Uri.parse("$url"),
      body: {
        'nomePet': pet.nomePet.toString(),
        'idPet': pet.idPet.toString(),
        'raca': pet.raca.toString(),
        'peso': pet.peso.toString(),
        'genero': pet.genero.toString(),
        'dtNasc': pet.dtNasc.toString(),
        'especie': pet.especie.toString(),
        'cor': pet.cor.toString(),
        'foto': pet.foto.toString(),
        'idContato': pet.idContato.toString(),
        'nomeContato': pet.nomeContato.toString(),
        'contaPlano': pet.contaPlano.toString(),
        'nomePlano': pet.nomePlano.toString(),
        'idPlano': pet.idPlano.toString(),
        'dataContrato': pet.dataContrato.toString(),
        'dataCadastro': pet.dataCadastro.toString(),
        'valorPlano': pet.valorPlano.toString(),
        'porte': pet.porte.toString(),
        'planoVencido': pet.planoVencido.toString(),
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

  Future<String> atualizarPetApi(Pet pet) async {
    final url = Uri.http(
        'fb.servicos.ws',
        // ignore: prefer_interpolation_to_compose_strings
        '/petBosque/pet/update/' + pet.id,
        {'q': '{http}'});

    final response = await http.post(
      Uri.parse("$url"),
      body: {
        "_method": "PUT",
        'nomePet': pet.nomePet.toString(),
        'idPet': pet.idPet.toString(),
        'raca': pet.raca.toString(),
        'peso': pet.peso.toString(),
        'genero': pet.genero.toString(),
        'dtNasc': pet.dtNasc.toString(),
        'especie': pet.especie.toString(),
        'cor': pet.cor.toString(),
        'foto': pet.foto.toString(),
        'idContato': pet.idContato.toString(),
        'nomeContato': pet.nomeContato.toString(),
        'contaPlano': pet.contaPlano.toString(),
        'nomePlano': pet.nomePlano.toString(),
        'idPlano': pet.idPlano.toString(),
        'dataContrato': pet.dataContrato.toString(),
        'dataCadastro': pet.dataCadastro.toString(),
        'valorPlano': pet.valorPlano.toString(),
        'porte': pet.porte.toString(),
        'planoVencido': pet.planoVencido.toString(),
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

  Future<String> contaPlanoPetApi(contador, id) async {
    final url = Uri.http(
        'fb.servicos.ws',
        // ignore: prefer_interpolation_to_compose_strings
        '/petBosque/pet/contaPlano/$contador/$id',
        {'q': '{http}'});

    final response = await http.post(
      Uri.parse("$url"),
      body: {
        "_method": "PUT",
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

  Future<String> renovaPlanoApi(contador, id) async {
    final url = Uri.http(
        'fb.servicos.ws',
        // ignore: prefer_interpolation_to_compose_strings
        '/petBosque/pet/renovaPlano/$contador/$id',
        {'q': '{http}'});

    final response = await http.post(
      Uri.parse("$url"),
      body: {
        "_method": "PUT",
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

  Future<String> atualizaPlanoVencidoApi(planoVencido, id) async {
    final url = Uri.http(
        'fb.servicos.ws',
        // ignore: prefer_interpolation_to_compose_strings
        '/petBosque/pet/planoVencido/$planoVencido/$id',
        {'q': '{http}'});

    final response = await http.post(
      Uri.parse("$url"),
      body: {
        "_method": "PUT",
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

  Future<String> excluirPetApi(id) async {
    final url = Uri.http(
        'fb.servicos.ws',
        // ignore: prefer_interpolation_to_compose_strings
        '/petBosque/pet/delete/' + id,
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

  Future<String> excluirPetClienteApi(id) async {
    final url = Uri.http(
        'fb.servicos.ws',
        // ignore: prefer_interpolation_to_compose_strings
        '/petBosque/pet/deleteCliente/' + id,
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
/*
  Future<List> obterTodosPetFirestore() async {
    CollectionReference petCollection =
        FirebaseFirestore.instance.collection('pet');
    var result =
        await petCollection.orderBy('nomePet').orderBy('nomePlano').get();
    return result.docs
        .map((doc) => Pet(
            id: doc['idPet'],
            idContato: doc['idContato'],
            nomePet: doc['nomePet'],
            raca: doc['raca'],
            peso: doc['peso'],
            genero: doc['genero'],
            dtNasc: doc['dtNasc'],
            especie: doc['especie'],
            cor: doc['cor'],
            foto: doc['foto'],
            nomeContato: doc['nomeContato'],
            nomePlano: doc['nomePlano'],
            idPlano: doc['idPlano'],
            dataContrato: doc['dataContrato'],
            dataCadastro: doc['dataCadastro'],
            valorPlano: doc['valorPlano'],
            porte: doc['porte'],
            planoVencido: doc['planoVencido'],
            contaPlano: doc['contaPlano']))
        .toList();
  }

  Future<List> obterTodosPetContatoFirestore(String id) async {
    CollectionReference petCollection =
        FirebaseFirestore.instance.collection('pet');
    var result = await petCollection.where('idContato', isEqualTo: id).get();
    return result.docs
        .map((doc) => Pet(
              id: doc['idPet'],
              idContato: doc['idContato'],
              nomePet: doc['nomePet'],
              raca: doc['raca'],
              peso: doc['peso'],
              genero: doc['genero'],
              dtNasc: doc['dtNasc'],
              especie: doc['especie'],
              cor: doc['cor'],
              foto: doc['foto'],
              nomeContato: doc['nomeContato'],
              contaPlano: doc['contaPlano'],
              nomePlano: doc['nomePlano'],
              idPlano: doc['idPlano'],
              dataContrato: doc['dataContrato'],
              dataCadastro: doc['dataCadastro'],
              valorPlano: doc['valorPlano'],
              porte: doc['porte'],
              planoVencido: doc['planoVencido'],
            ))
        .toList();
  }

  Future<List<Pet>> pesquisarTodosPetFirestore(teclado) async {
    CollectionReference petCollection =
        FirebaseFirestore.instance.collection('pet');
    var result = await petCollection
        .orderBy('nomePet')
        .where('nomePet', isGreaterThanOrEqualTo: teclado)
        .where('nomePet', isLessThan: teclado + 'z')
        .get();
    return result.docs
        .map((doc) => Pet(
            id: doc['idPet'],
            idContato: doc['idContato'],
            nomePet: doc['nomePet'],
            raca: doc['raca'],
            peso: doc['peso'],
            genero: doc['genero'],
            dtNasc: doc['dtNasc'],
            especie: doc['especie'],
            cor: doc['cor'],
            foto: doc['foto'],
            nomeContato: doc['nomeContato'],
            nomePlano: doc['nomePlano'],
            idPlano: doc['idPlano'],
            dataContrato: doc['dataContrato'],
            dataCadastro: doc['dataCadastro'],
            valorPlano: doc['valorPlano'],
            porte: doc['porte'],
            planoVencido: doc['planoVencido'],
            contaPlano: doc['contaPlano']))
        .toList();
  }

  deletarPetFirestore(id) async {
    CollectionReference planoCollection =
        FirebaseFirestore.instance.collection('pet');
    planoCollection.doc(id).delete();
  }

  Future<List> deletarPetContatoFirestore(String id) async {
    CollectionReference petCollection =
        FirebaseFirestore.instance.collection('pet');
    var result = await petCollection.where('idContato', isEqualTo: id).get();
    return result.docs
        .map((doc) => Pet(
              id: doc['idPet'],
              idContato: doc['idContato'],
              nomePet: doc['nomePet'],
              raca: doc['raca'],
              peso: doc['peso'],
              genero: doc['genero'],
              dtNasc: doc['dtNasc'],
              especie: doc['especie'],
              cor: doc['cor'],
              foto: doc['foto'],
              nomeContato: doc['nomeContato'],
              contaPlano: doc['contaPlano'],
              nomePlano: doc['nomePlano'],
              idPlano: doc['idPlano'],
              dataContrato: doc['dataContrato'],
              dataCadastro: doc['dataCadastro'],
              valorPlano: doc['valorPlano'],
              porte: doc['porte'],
              planoVencido: doc['planoVencido'],
            ))
        .toList();
  }*/
}

class Pet {
  dynamic id;
  String? idPet;
  String? idContato;
  String? nomePet;
  String? raca;
  String? peso;
  String? genero;
  String? dtNasc;
  String? especie;
  String? cor;
  String? foto;
  String? nomeContato;
  dynamic contaPlano;
  String? nomePlano;
  String? idPlano;
  String? dataContrato;
  String? dataCadastro;
  String? valorPlano;
  String? porte;
  String? planoVencido;

  Pet(
      {this.id,
      this.idPet,
      this.idContato,
      this.nomePet,
      this.raca,
      this.peso,
      this.genero,
      this.dtNasc,
      this.especie,
      this.cor,
      this.foto,
      this.nomeContato,
      this.contaPlano,
      this.nomePlano,
      this.idPlano,
      this.dataContrato,
      this.dataCadastro,
      this.planoVencido,
      this.valorPlano,
      this.porte});

  factory Pet.fromJson(Map json) {
    return Pet(
        id: json['id'],
        idContato: json['idContato'],
        idPet: json['idPet'],
        nomePet: json['nomePet'],
        raca: json['raca'],
        peso: json['peso'],
        genero: json['genero'],
        dtNasc: json['dtNasc'],
        especie: json['especie'],
        cor: json['cor'],
        foto: json['foto'],
        nomeContato: json['nomeContato'],
        contaPlano: json['contaPlano'],
        nomePlano: json['nomePlano'],
        idPlano: json['idPlano'],
        dataContrato: json['dataContrato'],
        dataCadastro: json['dataCadastro'],
        planoVencido: json['planoVencido'],
        valorPlano: json['valorPlano'],
        porte: json['porte']);
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'idContato': this.idContato,
        'idpet': this.idPet,
        'nomePet': this.nomePet,
        'raca': this.raca,
        'peso': this.peso,
        'genero': this.genero,
        'dtNasc': this.dtNasc,
        'especie': this.especie,
        'cor': this.cor,
        'foto': this.foto,
        'nomeContato': this.nomeContato,
        'contaPlano': this.contaPlano,
        'nomePlano': this.nomePlano,
        'idPlano': this.idPlano,
        'dataContrato': this.dataContrato,
        'dataCadastro': this.dataCadastro,
        'planoVencido': this.planoVencido,
        'valorPlano': this.valorPlano,
        'porte': this.porte,
      };

  Pet.fromMap(Map map) {
    id = map[idColuna];
    idPet = map[idPetColuna];
    idContato = map[idContatoColuna];
    nomePet = map[nomePetColuna];
    raca = map[racaColuna];
    peso = map[pesoColuna];
    genero = map[generoColuna];
    dtNasc = map[dtNascColuna];
    especie = map[especieColuna];
    cor = map[corColuna];
    dtNasc = map[dtNascColuna];
    foto = map[fotoColuna];
    nomeContato = map[nomeContatoColuna];
    contaPlano = map[contaPlanoColuna];
    nomePlano = map[nomePlanoColuna];
    idPlano = map[idPlanoColuna];
    dataContrato = map[dataContratoColuna];
    dataCadastro = map[dataCadastroColuna];
    valorPlano = map[valorPlanoColuna];
    porte = map[porteColuna];
    planoVencido = map[planoVencidoColuna];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      idContatoColuna: idContato,
      idPetColuna: idPet,
      nomePetColuna: nomePet,
      racaColuna: raca,
      pesoColuna: peso,
      generoColuna: genero,
      dtNascColuna: dtNasc,
      especieColuna: especie,
      corColuna: cor,
      fotoColuna: foto,
      nomeContatoColuna: nomeContato,
      contaPlanoColuna: contaPlano,
      nomePlanoColuna: nomePlano,
      idPlanoColuna: idPlano,
      dataContratoColuna: dataContrato,
      dataCadastroColuna: dataCadastro,
      valorPlanoColuna: valorPlano,
      porteColuna: porte,
      planoVencidoColuna: planoVencido,
    };

    if (id != null) {
      map[idColuna] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Pet(id: $id,idPet: $idPet, idContato: $idContato,nomePet: $nomePet,raca: $raca,cor: $cor,genero: $genero,especie: $especie,peso: $peso,dtNasc: $dtNasc,foto: $foto,nomeContato: $nomeContato, contaPlano: $contaPlano, nomePlano: $nomePlano, idPlano: $idPlano, dataContrato: $dataContrato,dataCadastro: $dataCadastro, valorPlano: $valorPlano,porte: $porte, planoVencido: $planoVencido)";
  }
}
