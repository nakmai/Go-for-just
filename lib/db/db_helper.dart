import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'timer.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE summary (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            totalPlays INTEGER,
            totalPerfect INTEGER,
            totalSuccess INTEGER,
            totalFails INTEGER
          )
        ''');
        db.execute('''
          CREATE TABLE history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            time TEXT,
            result TEXT
          )
        ''');
      },
    );
  }

  Future<Map<String, int>?> getSummary() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('summary');
    if (result.isNotEmpty) {
      return {
        'totalPlays': result[0]['totalPlays'] as int,
        'totalPerfect': result[0]['totalPerfect'] as int,
        'totalSuccess': result[0]['totalSuccess'] as int,
        'totalFails': result[0]['totalFails'] as int,
      };
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final db = await database;
    return await db.query('history', orderBy: 'id DESC');
  }

  Future<void> insertHistory(String time, String result) async {
    final db = await database;
    await db.insert('history', {'time': time, 'result': result});
  }

  Future<void> saveSummary(Map<String, int> summary) async {
    final db = await database;
    await db.insert(
      'summary',
      summary,
      conflictAlgorithm: ConflictAlgorithm.replace, // 既存のデータを上書き
    );
  }

  Future<void> clearHistory() async {
    final db = await database;
    await db.delete('history');
    await db.delete('summary'); // 成績データもクリア
  }
}
