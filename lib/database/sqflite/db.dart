import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  static const String _nomeDB = "pet1.db";
  static const int _versaoDB = 1;

// Aplicação do padrão Singleton na classe.
  DB._privateConstructor();
  static final DB instance = DB._privateConstructor();

  // Configurar a intância única da classe.
  // Abre a base de dados (e cria quando ainda não existir).
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    String caminhoDoBanco = await getDatabasesPath();
    String banco = _nomeDB;
    String path = join(caminhoDoBanco, banco);

    return await openDatabase(
      path,
      version: _versaoDB,
      onCreate: _criarBanco,
    );
  }

  Future<void> _criarBanco(Database db, int novaVersao) async {
    List<String> queryes = [
      // "CREATE TABLE  tabelaPet(id INTEGER PRIMARY KEY, idContato TEXT, nomePet TEXT, raca TEXT, peso TEXT,genero TEXT, dtNasc TEXT, cor TEXT, foto TEXT, especie TEXT,nomeContato TEXT, contaPlano INT, nomePlano TEXT, idPlano TEXT, dataContrato TEXT, valorPlano TEXT, porte TEXT, planoVencido TEXT);",
      //"CREATE TABLE  tabelaContato(id INTEGER PRIMARY KEY, idPet TEXT,nome TEXT,email TEXT,telefone TEXT,endereco TEXT,bairro TEXT,cidade TEXT,complemento TEXT, uf TEXT);",
      //"CREATE TABLE  tabelaAgendamento(id INTEGER PRIMARY KEY,idPet TEXT,fotoPet TEXT, nomeContato TEXT,nomePet TEXT, data TEXT, hora TEXT, svBanho TEXT, valorBanho DOUBLE, svTosa TEXT, valorTosa DOUBLE, svTosaHigienica TEXT, valorTosaHigienica DOUBLE, svCorteUnha TEXT, valorCorteUnha DOUBLE, svHidratacao TEXT, valorHidratacao DOUBLE, svPintura TEXT, valorPintura DOUBLE,svHospedagem TEXT, valorHospedagem DOUBLE, svTransporte TEXT, valorTransporte DOUBLE,valorTotal DOUBLE,valorAdicional DOUBLE, observacao TEXT,status TEXT, colaborador TEXT, idColaborador TEXT, planoVencido TEXT);",
      //"CREATE TABLE  tabelaHospedagem(id INTEGER PRIMARY KEY,idPet TEXT,fotoPet TEXT, nomeContato TEXT,nomePet TEXT, dataCheckIn TEXT, horaCheckIn TEXT,dataCheckOut TEXT, horaCheckOut TEXT,porte TEXT,genero TEXT,dia INT,valorDia DOUBLE,adicional DOUBLE, valorTotal DOUBLE, observacao TEXT,status TEXT, colaborador TEXT, idColaborador TEXT);",
      //"CREATE TABLE  tabelaPlanos(id INTEGER PRIMARY KEY, nomePlano TEXT,svBanho TEXT, svTosa TEXT,svTosaHigienica TEXT, svCorteUnha TEXT, svHidratacao TEXT, svPintura TEXT,svHospedagem TEXT, svTransporte TEXT, valor DOUBLE);",
      //"CREATE TABLE  tabelaColaborador(id INTEGER PRIMARY KEY, nomeColaborador TEXT,funcao TEXT, porcenComissao DOUBLE,metaComissao DOUBLE, status TEXT);",
      //"INSERT INTO 'tabelaColaborador' ( 'nomeColaborador' , 'funcao' , 'porcenComissao', 'metaComissao', 'status') VALUES ('Geral' , 'Admin' , '0.00' , '0.00' ,'Ativo'); "
    ];

    for (String query in queryes) {
      await db.execute(query);
    }
  }
}
