import 'package:maps/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/contato_model.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath =
        join(databaseDirPath, "app_database.db"); // Banco único

    return await openDatabase(databasePath, version: 1,
        onCreate: (db, version) async {
      await _createTables(db);
    });
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            passwordHash TEXT NOT NULL
          )
        ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS contatos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        latitude TEXT NOT NULL,
        longitude TEXT NOT NULL
      )
    ''');
  }
}

// --------------------- CONTATO SERVICE ---------------------
class ContatoService {
  static final ContatoService instance = ContatoService._constructor();
  final DatabaseService _databaseService = DatabaseService.instance;

  ContatoService._constructor();

  final String _tableName = "contatos";
  final String _idColumn = "id";
  final String _nomeColumn = "nome";
  final String _latitudeColumn = "latitude";
  final String _longitudeColumn = "longitude";

  Future<void> addContato(
      String nome, String latitude, String longitude) async {
    final db = await _databaseService.database;
    await db.insert(
      _tableName,
      {
        _nomeColumn: nome,
        _latitudeColumn: latitude,
        _longitudeColumn: longitude,
      },
    );
  }

  Future<List<Contato>> getContatos() async {
    final db = await _databaseService.database;
    final data = await db.query(_tableName);

    return data
        .map((e) => Contato(
              id: e[_idColumn] as int,
              nome: e[_nomeColumn] as String,
              latitude: e[_latitudeColumn] as String,
              longitude: e[_longitudeColumn] as String,
            ))
        .toList();
  }

  Future<void> deleteContato(int id) async {
    final db = await _databaseService.database;
    await db.delete(_tableName, where: '$_idColumn = ?', whereArgs: [id]);
  }

  Future<void> updateContato(
      int id, String nome, String latitude, String longitude) async {
    final db = await _databaseService.database;
    await db.update(
      _tableName,
      {
        _nomeColumn: nome,
        _latitudeColumn: latitude,
        _longitudeColumn: longitude,
      },
      where: '$_idColumn = ?',
      whereArgs: [id],
    );
  }
}

class UserService {
  static final UserService instance = UserService._constructor();
  final DatabaseService _databaseService = DatabaseService.instance;

  UserService._constructor();

  Future<void> addUser(String name, String email, String passwordHash) async {
    final db = await _databaseService.database;
    await db.insert('users', {
      'name': name,
      'email': email,
      'passwordHash': passwordHash,
    });
  }

  Future<int> insertUser(User user) async {
    final db = await _databaseService.database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }
}
