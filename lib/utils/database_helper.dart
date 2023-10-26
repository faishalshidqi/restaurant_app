import 'package:path/path.dart';
import 'package:restaurant_app/data/model/restaurant_in_list.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static late Database _database;
  static DatabaseHelper? _databaseHelper;
  static const _tableName = 'favorites';

  DatabaseHelper._internal() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._internal();

  Future<Database> get database async {
    _database = await _initializeDb();
    return _database;
  }

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db =
        openDatabase(join(path, 'fav_db.db'), onCreate: (db, version) async {
      await db.execute('''create table $_tableName(
      id text primary key, 
      name text, 
      description text, 
      picture_id text, 
      city text, 
      rating real)''');
    }, version: 1);
    return db;
  }

  Future<void> insertFavorite(RestaurantInList restaurant) async {
    final Database db = await database;
    await db.insert(_tableName, restaurant.toMap());
  }

  Future<List<RestaurantInList>> getFavorites() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(_tableName);
    return results
        .map((response) => RestaurantInList.fromMap(response))
        .toList();
  }

  Future<Map> getFavoriteById(String id) async {
    final Database db = await database;
    List<Map<String, dynamic>> results =
        await db.query(_tableName, where: 'id = ?', whereArgs: [id]);

    return results.first;
  }

  Future<void> deleteFavorite(String id) async {
    final db = await database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}
