import 'package:sqflite/sqflite.dart';

import 'clip_board.dart';
import 'password_list_manager.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 2;
  static const String _tableName = 'copypast';
  static const String _passwordList = 'passwordList';

  static Future<void> initDB() async {
    if (_db != null) {
      print('not null');
      return;
    } else {
      try {
        String _path = await getDatabasesPath() + 'copypast1.db';
        _db = await openDatabase(_path, version: _version,
            onCreate: (Database db, int version) async {
          await db.execute(
            'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, text TEXT)',
          );
          await db.execute(
            'CREATE TABLE $_passwordList(id INTEGER PRIMARY KEY AUTOINCREMENT, password TEXT)',
          );
        });
      } catch (e) {
        print(e);
      }
    }
  }

  static Future<int> insert(ClipBoardManager? text) async {
    return _db!.insert(_tableName, {'text ': text!.text});
  }

  static Future<List<Map<String, dynamic>>> query() async {
    return _db!.query(_tableName, orderBy: 'id DESC', columns: ['text']);
  }

  static Future<int> deleteAll() async {
    return _db!.delete(_tableName);
  }

  static Future<int> delete(String text) async {
    return await _db!.delete(_tableName, where: 'text = ?', whereArgs: [text]);
  }

  static Future<bool> texExists(String text) async {
    var result = await _db!.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $_tableName WHERE text="$text")',
    );
    int? exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  /// *********************Password table */

  static Future<int> insertPassw(PasswordListManager? passw) async {
    return _db!.insert(_passwordList, {'password ': passw!.password});
  }

  static Future<List<Map<String, dynamic>>> queryPassword() async {
    return _db!.query(_passwordList, orderBy: 'id DESC', columns: ['password']);
  }

  static Future<int> deleteAllPassword() async {
    return _db!.delete(_passwordList);
  }

  static Future<int> deletePassword(String passw) async {
    return await _db!
        .delete(_passwordList, where: 'password = ?', whereArgs: [passw]);
  }

  static Future<bool> passwExists(String passw) async {
    var result = await _db!.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $_passwordList WHERE password="$passw")',
    );
    int? exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }
}
