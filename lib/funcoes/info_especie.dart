import 'dart:convert';

import 'package:http/http.dart' as http;

const String tabelaEspecie = "tabelaEspecie";
const String idColuna = "id";
const String nomeColuna = "nome";

class InfoEspecie {
  static final InfoEspecie _instance = InfoEspecie.internal();

  factory InfoEspecie() => _instance;

  InfoEspecie.internal();

  //=========================================================================

  //FUNÇÕES API

  Future<List> obterTodasEspecieApi() async {
    final url =
        Uri.http('fb.servicos.ws', '/petBosque/especie/lista', {'q': '{http}'});

    final response = await http.get(url);
    final map = await jsonDecode(response.body);
    List<Especie> listaEspecie = [];

    if (map.containsKey("dados") && map["dados"] is List) {
      List listMap = map["dados"];
      for (Map m in listMap) {
        listaEspecie.add(Especie.fromJson(m));
      }
    }
    return listaEspecie;
  }

  Future<Especie?> obterDadosEspecieApi(id) async {
    final url = Uri.http(
        'fb.servicos.ws', '/petBosque/especie/lista/$id', {'q': '{http}'});

    final response = await http.get(url);
    final map = await jsonDecode(response.body);
    //List<dynamic> listMap = map["dados"];

    // Map<String, dynamic> primeiroMap = listMap.first;

    Especie resposta = Especie.fromJson(map["dados"]);
    return resposta;
  }

  Future<String> salvarEspecieApi(Especie especie) async {
    final url = Uri.http(
        'fb.servicos.ws', '/petBosque/especie/adiciona', {'q': '{http}'});

    final response = await http.post(
      Uri.parse("$url"),
      body: {
        "nome": especie.nome.toString(),
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

  Future<String> atualizarEspecieApi(Especie especie) async {
    final url = Uri.http(
        'fb.servicos.ws',
        // ignore: prefer_interpolation_to_compose_strings
        '/petBosque/especie/update/' + especie.id,
        {'q': '{http}'});

    final response = await http.post(
      Uri.parse("$url"),
      body: {
        "_method": "PUT",
        "nome": especie.nome.toString(),
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

  Future<String> excluirEspecieApi(id) async {
    final url = Uri.http(
        'fb.servicos.ws',
        // ignore: prefer_interpolation_to_compose_strings
        '/petBosque/especie/delete/' + id,
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

class Especie {
  dynamic id;
  String? nome;

  Especie({
    this.nome,
    this.id,
  });
  factory Especie.fromJson(Map json) {
    return Especie(id: json['id'], nome: json['nome']);
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'nome': this.nome,
      };

  Especie.fromMap(Map map) {
    id = map[idColuna];
    nome = map[nomeColuna];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      nomeColuna: nome,
    };
    if (id != null) {
      map[idColuna] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contato(id: $id,nome: $nome)";
  }
}
