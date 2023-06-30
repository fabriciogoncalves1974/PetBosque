import 'package:sqflite/sqflite.dart'
    show Sqflite, getDatabasesPath, openDatabase;
import 'package:sqflite/sqlite_api.dart';

import '../database/sqflite/db.dart';

const String tabelaPet = "tabelaPet";
const String idColunaPet = "id";
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
          idColunaPet,
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
          valorPlanoColuna,
          porteColuna,
          planoVencidoColuna,
        ],
        where: "$idColunaPet = ?",
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
        .delete(tabelaPet, where: "$idColunaPet = ?", whereArgs: [id]);
  }

  Future<int> atualizarPet(Pet pet) async {
    Database? db = await DB.instance.database;
    Database? dbPet = db;
    return dbPet!.update(tabelaPet, pet.toMap(),
        where: "$idColunaPet = ?", whereArgs: [pet.id]);
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
}

class Pet {
  int? id;
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
  int? contaPlano;
  String? nomePlano;
  String? idPlano;
  String? dataContrato;
  String? valorPlano;
  String? porte;
  String? planoVencido;

  Pet();

  Pet.fromMap(Map map) {
    id = map[idColunaPet];
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
    valorPlano = map[valorPlanoColuna];
    porte = map[porteColuna];
    planoVencido = map[planoVencidoColuna];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      idContatoColuna: idContato,
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
      valorPlanoColuna: valorPlano,
      porteColuna: porte,
      planoVencidoColuna: planoVencido,
    };

    if (id != null) {
      map[idColunaPet] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Pet(id: $id,idContato: $idContato,nomePet: $nomePet,raca: $raca,cor: $cor,genero: $genero,especie: $especie,peso: $peso,dtNasc: $dtNasc,foto: $foto,nomeContato: $nomeContato, contaPlano: $contaPlano, nomePlano: $nomePlano, idPlano: $idPlano, dataContrato: $dataContrato, valorPlano: $valorPlano,porte: $porte, planoVencido: $planoVencido)";
  }
}
