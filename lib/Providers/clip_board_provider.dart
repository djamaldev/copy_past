import 'package:copy_pasta/services/db_helper.dart';
import 'package:copy_pasta/services/password_list_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/clip_board.dart';

class ClipBoardProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _taskList = [];
  List<Map<String, dynamic>> _passwList = [];
  bool _isFound = false;
  bool _isPasswFound = false;
  String _passw = '';
  SharedPreferences? _prefs;
  //bool _darkTheme = false;
  //DarkThemePreference darkThemePreference = DarkThemePreference();
  //var _themeMode = ThemeMode.light;

  List get taskList => [..._taskList];
  List get passwList => [..._passwList];
  bool get isFound => _isFound;
  bool get isPasswFound => _isPasswFound;
  String get passw => _passw;
  bool get enabled => _passw.isNotEmpty ? true : false;
  SharedPreferences? get prefs => _prefs;

  copyText(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    notifyListeners();
  }

  addOtherText(String text) async {
    Clipboard.setData(ClipboardData(text: text)).then(
      (_) async {
        _isFound = await DBHelper.texExists(text);
        if (_isFound == false) {
          await DBHelper.insert(ClipBoardManager(text: text));
          getAllCopiedText();
        } else {
          Null;
        }
      },
    );
    notifyListeners();
  }

  getAllCopiedText() async {
    _taskList = await DBHelper.query();
    notifyListeners();
  }

  setData() {
    Clipboard.getData(Clipboard.kTextPlain).then(
      (value) async {
        _isFound = await DBHelper.texExists(value!.text!);
        if (_isFound == false) {
          await DBHelper.insert(ClipBoardManager(text: value.text));
          getAllCopiedText();
        } else {
          Null;
        }
      },
    );
    notifyListeners();
  }

  deleteAllCopiedText() async {
    await DBHelper.deleteAll();
    _taskList = [];
    notifyListeners();
  }

  Future<void> deleteTextAtIndex(String text) async {
    await DBHelper.delete(text);
    _taskList = await DBHelper.query();
    notifyListeners();
  }

  setPasscode(String passcode) async {
    //_enabled = true;
    _passw = passcode;
    _prefs = await SharedPreferences.getInstance();
    _prefs!.setString("KEY_1", _passw.toString());
    //_prefs!.setBool('KEY_2', _isPasscodeAdded!);
    notifyListeners();
  }

  removePasscode() async {
    //_isPasscodeAdded = true;

    _prefs = await SharedPreferences.getInstance();
    _passw = '';
    _prefs!.clear();
    //_prefs!.setBool('KEY_2', _isPasscodeAdded!);
    notifyListeners();
  }

  saveToSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _prefs!.setString("KEY_1", _passw.toString());
    notifyListeners();
  }

  getSavedPasswcode() async {
    _prefs = await SharedPreferences.getInstance();
    if (!_prefs!.containsKey('KEY_1')) {
      return;
    }
    _passw = _prefs!.getString('KEY_1').toString();
    notifyListeners();
  }

  /// ****** Password Manager */////////////////

  addOtherPassword(String text) async {
    Clipboard.setData(ClipboardData(text: text)).then(
      (_) async {
        _isPasswFound = await DBHelper.passwExists(text);
        if (_isPasswFound == false) {
          await DBHelper.insertPassw(PasswordListManager(password: text));
          getAllCopiedPassword();
        } else {
          Null;
        }
      },
    );
    notifyListeners();
  }

  getAllCopiedPassword() async {
    _passwList = await DBHelper.queryPassword();
    notifyListeners();
  }

  setPasswordData() {
    Clipboard.getData(Clipboard.kTextPlain).then(
      (value) async {
        _isPasswFound = await DBHelper.passwExists(value!.text!);
        if (_isPasswFound == false) {
          await DBHelper.insertPassw(PasswordListManager(password: value.text));
          getAllCopiedPassword();
        } else {
          Null;
        }
      },
    );
    notifyListeners();
  }

  deleteAllCopiedPassword() async {
    await DBHelper.deleteAllPassword();
    _passwList = [];
    notifyListeners();
  }

  Future<void> deletePasswordAtIndex(String text) async {
    await DBHelper.deletePassword(text);
    _passwList = await DBHelper.queryPassword();
    notifyListeners();
  }
}
