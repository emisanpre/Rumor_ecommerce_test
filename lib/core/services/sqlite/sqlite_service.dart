import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }
  
  Future<Database> _initDB() async {
    String path = await getDatabasesPath();
    
    return openDatabase(
      join(path, 'ecommerce.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, cart TEXT, password TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> closeDB() async{
    Database db = await database;
    db.close();
  }

  Future<void> deleteDB() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'ecommerce.db');
    await deleteDatabase(path);
  }
}