import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<sql.Database> getDb(String table) async {
    final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(path.join(dbPath, 'transactionsDB.db'),
        version: 1, onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE $table(id TEXT, title TEXT, amount TEXT, date TEXT)');
    });
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.getDb(table);
    await db.insert(table, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.getDb(table);
    return await db.query(table);
  }

  static Future<void> delete(String table, String id) async {
    final db = await DBHelper.getDb(table);
    await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
