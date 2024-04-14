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
        db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, password TEXT)',
        );

        db.execute(
          'CREATE TABLE cart_items(id INTEGER PRIMARY KEY AUTOINCREMENT, userId INTEGER, productID INTEGER, quantity INTEGER)',
        );
      },
      version: 1,
    );
  }
}