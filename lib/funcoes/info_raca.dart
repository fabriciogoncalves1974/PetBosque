import 'dart:convert';

import 'package:http/http.dart' as http;

const String tabelaRaca = "tabelaRaca";
const String idColuna = "id";
const String nomeColuna = "nome";
const String especieColuna = "especie";
const String idEspecieColuna = "idEspecie";

class InfoRaca {
  static final InfoRaca _instance = InfoRaca.internal();

  factory InfoRaca() => _instance;

  InfoRaca.internal();

  //=========================================================================

  //FUNÇÕES API

  Future<List> obterTodasRacaApi() async {
    final url =
        Uri.http('fb.servicos.ws', '/petBosque/raca/lista', {'q': '{http}'});

    final response = await http.get(url);
    final map = await jsonDecode(response.body);
    List<Raca> listaRaca = [];

    if (map.containsKey("dados") && map["dados"] is List) {
      List listMap = map["dados"];
      for (Map m in listMap) {
        listaRaca.add(Raca.fromJson(m));
      }
    }
    return listaRaca;
  }

  Future<Raca?> obterDadosRacaApi(id) async {
    final url = Uri.http(
        'fb.servicos.ws', '/petBosque/raca/lista/$id', {'q': '{http}'});

    final response = await http.get(url);
    final map = await jsonDecode(response.body);
    //List<dynamic> listMap = map["dados"];

    // Map<String, dynamic> primeiroMap = listMap.first;

    Raca resposta = Raca.fromJson(map["dados"]);
    return resposta;
  }

  Future<List> pesquisarRacaApi(id) async {
    final url = Uri.http(
        'fb.servicos.ws', '/petBosque/raca/especie/$id', {'q': '{http}'});

    final response = await http.get(url);
    final map = await jsonDecode(response.body);
    List<Raca> listaRaca = [];

    if (map.containsKey("dados") && map["dados"] is List) {
      List listMap = map["dados"];
      for (Map m in listMap) {
        listaRaca.add(Raca.fromJson(m));
      }
    }
    return listaRaca;
  }

  Future<String> salvarRacaApi(Raca raca) async {
    final url =
        Uri.http('fb.servicos.ws', '/petBosque/raca/adiciona', {'q': '{http}'});

    final response = await http.post(
      Uri.parse("$url"),
      body: {
        "nome": raca.nome.toString(),
        "especie": raca.especie.toString(),
        "idEspecie": raca.idEspecie.toString(),
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

  Future<String> atualizarRacaApi(Raca raca) async {
    final url = Uri.http(
        'fb.servicos.ws',
        // ignore: prefer_interpolation_to_compose_strings
        '/petBosque/raca/update/' + raca.id,
        {'q': '{http}'});

    final response = await http.post(
      Uri.parse("$url"),
      body: {
        "_method": "PUT",
        "nome": raca.nome.toString(),
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

  Future<String> excluirRacaApi(id) async {
    final url = Uri.http(
        'fb.servicos.ws',
        // ignore: prefer_interpolation_to_compose_strings
        '/petBosque/raca/delete/' + id,
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
}
//=========================================================================

class Raca {
  dynamic id;
  String? nome;
  String? especie;
  dynamic idEspecie;

  Raca({
    this.nome,
    this.especie,
    this.idEspecie,
    this.id,
  });
  factory Raca.fromJson(Map json) {
    return Raca(
        id: json['id'],
        nome: json['nome'],
        especie: json['especie'],
        idEspecie: json['idEspecie']);
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'nome': this.nome,
        'especie': this.especie,
        'idEspecie': this.idEspecie,
      };

  Raca.fromMap(Map map) {
    id = map[idColuna];
    nome = map[nomeColuna];
    especie = map[especieColuna];
    idEspecie = map[idEspecieColuna];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      nomeColuna: nome,
      especieColuna: especie,
      idEspecieColuna: idEspecie,
    };
    if (id != null) {
      map[idColuna] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contato(id: $id,nome: $nome,especie: $especie,idEspecie: $idEspecie)";
  }
}
