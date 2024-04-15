import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Service class for SQLite database management.
///
/// This class provides methods for initializing and accessing an SQLite database.
class SqliteService {
  /// Singleton instance of the database.
  static Database? _database;

  /// Retrieves the singleton instance of the database.
  ///
  /// If the database instance is not initialized, it initializes and returns it.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }
  
  /// Initializes the SQLite database.
  Future<Database> _initDB() async {
    String path = await getDatabasesPath();
    
    return openDatabase(
      join(path, 'ecommerce.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE users(id TEXT PRIMARY KEY, name TEXT, email TEXT, password TEXT)',
        );

        db.execute(
          'CREATE TABLE cartItems(id TEXT PRIMARY KEY, userId TEXT, productId INTEGER, quantity INTEGER)',
        );
      },
      version: 1,
    );
  }
}