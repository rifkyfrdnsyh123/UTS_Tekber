import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'databaseMhs.db');
    return openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  static Future<void> _createDatabase(Database db, int version) async {
    await db.execute("""
      CREATE TABLE IF NOT EXISTS mhs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT,
        nim TEXT
      )
    """);
  }

  static Future<int> insertUser(String nama, String nim) async {
    final db = await _openDatabase();
    final data = {'nama': nama, 'nim': nim};
    return await db.insert('mhs', data);
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final db = await _openDatabase();
    return await db.query('mhs');
  }

  static Future<int> deleteData(int id) async {
    final db = await _openDatabase();
    return await db.delete('mhs', where: 'id = ?', whereArgs: [id]);
  }

  static Future<Map<String, dynamic>?> getSingleData(int id) async {
    final db = await _openDatabase();

    List<Map<String, dynamic>> result =
        await db.query('mhs', where: 'id = ?', whereArgs: [id], limit: 1);

    return result.isNotEmpty ? result.first : null;
  }

  static Future<int> updateData(int id, Map<String, dynamic> data) async {
    final db = await _openDatabase();
    return await db.update('mhs', data, where: 'id = ?', whereArgs: [id]);
  }
}
