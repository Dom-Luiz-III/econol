import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class Price {
  int? id;
  double gasolina;
  double etanol;

  Price({this.id, required this.gasolina, required this.etanol});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gasolina': gasolina,
      'etanol': etanol,
    };
  }

  factory Price.fromMap(Map<String, dynamic> map) {
    return Price(
      id: map['id'],
      gasolina: map['gasolina'],
      etanol: map['etanol'],
    );
  }
}

class DatabaseHelper {
  static const _databaseName = 'econol.db';
  static const _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE prices (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        gasolina REAL,
        etanol REAL
      )
    ''');
  }

  Future<int> insertPrice(Price price) async {
    Database db = await instance.database;
    return await db.insert('prices', price.toMap());
  }

  Future<List<Price>> fetchPrices() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query('prices');
    return List.generate(maps.length, (i) {
      return Price.fromMap(maps[i]);
    });
  }

}
