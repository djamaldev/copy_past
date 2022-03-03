import 'package:sqflite/sqflite.dart';

import 'clip_board.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'copypast';

  static Future<void> initDB() async {
    if (_db != null) {
      print('not null');
      return;
    } else {
      try {
        String _path = await getDatabasesPath() + 'copypast.db';
        _db = await openDatabase(_path, version: _version,
            onCreate: (Database db, int version) async {
          await db.execute(
            'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, text TEXT, UNIQUE(text))',
          );
        });
      } catch (e) {
        print(e);
      }
    }
  }

  void _query(key) async {
    //Database db = await DatabaseHelper.instance.database;
    List<Map> result = await _db!
        .rawQuery("SELECT text FROM $_tableName WHERE text LIKE '%$key%'");

    var course = result.map<String>((element) {
      return element['text'];
    }).toList();
    if (course == key) {
      print('exist item: $course');
    }
    //print(course);
  }

  static Future<int> insert(ClipBoardManager? text) async {
    List<Map> result = await _db!
        .rawQuery("SELECT text FROM $_tableName WHERE text LIKE '%$text%'");

    var course = result.map<String>((element) {
      return element['text'];
    }).toList();
    if (course == text) {
      print('exist item: $course');
    }
    return _db!.insert(_tableName, {'text ': text!.text});
  }

  static Future<List<Map<String, dynamic>>> query() async {
    return _db!.query(_tableName, orderBy: 'id DESC', columns: ['text']);
  }

  static Future<int> deleteAll() async {
    return _db!.delete(_tableName);
  }

  static Future<int> delete(ClipBoardManager? text) async {
    return _db!.delete(_tableName, where: 'id = ?', whereArgs: [text!.id]);
  }
  /*static Future<int> insert(Task? task) async {
    return _db!.insert(_tableName, task!.toJson());
  }

  static Future<int> delete(Task? task) async {
    return _db!.delete(_tableName, where: 'id = ?', whereArgs: [task!.id]);
  }

  static Future<int> deleteAll() async {
    return _db!.delete(_tableName);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    return _db!.query(_tableName);
  }

  static Future<int> updatToCompletedTask(int id) async {
    return _db!.rawUpdate('''
    UPDATE tasks
    SET isCompleted = ?
    WHERE id = ?
    ''', [1, id]);
  }

  static Future<List<Map<String, dynamic>>> getCategoryTask(
      int category) async {
    return _db!.rawQuery('SELECT * FROM tasks WHERE category=?', [category]);
  }*/
}