import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';
import '../models/client_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return openDatabase(
      path,
      version: 2, // Atualizado para refletir a nova tabela
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE,
        password TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE clients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        email TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE clients (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nome TEXT NOT NULL,
          email TEXT NOT NULL
        )
      ''');
    }
  }

  // ============================ USUÁRIOS ============================

  Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final db = await database;
    List<Map<String, dynamic>> result =
        await db.query('users', where: 'email = ?', whereArgs: [email]);
    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }

  Future<List<UserModel>> getAllUsers() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query("users");
    return result.map((json) => UserModel.fromMap(json)).toList();
  }

  // ============================ CLIENTES ============================

  Future<int> insertClient(ClientModel client) async {
    final db = await database;
    return await db.insert('clients', client.toMap());
  }

  Future<List<ClientModel>> getClients() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query("clients");
    return result.map((json) => ClientModel.fromMap(json)).toList();
  }
}
