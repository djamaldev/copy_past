import 'package:copy_pasta/services/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/clip_board.dart';

class ClipBoardProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _taskList = [];
  bool _isFound = false;
  String _passw = '';
  SharedPreferences? _prefs;
  //String _savedPassw = '';

  List get taskList => [..._taskList];
  bool get isFound => _isFound;
  String get passw => _passw;
  //String get savedPssw => _savedPassw;
  SharedPreferences? get prefs => _prefs;

  copyText(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    notifyListeners();
  }

  coyOtherText(String text) async {
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
    //print('list = $_taskList');
    for (int index = 0; index < _taskList.length; index++) {
      //print('list = ${_taskList[index]['text']}');
    }
    notifyListeners();
    //return _taskList;
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
    //_isPasscodeAdded = true;
    _passw = passcode;
    _prefs = await SharedPreferences.getInstance();
    _prefs!.setString("KEY_1", _passw.toString());
    //_prefs!.setBool('KEY_2', _isPasscodeAdded!);
    notifyListeners();
  }

  removePasscode() async {
    //_isPasscodeAdded = true;

    _prefs = await SharedPreferences.getInstance();
    _prefs!.clear();
    _passw = '';
    //_prefs!.setBool('KEY_2', _isPasscodeAdded!);
    notifyListeners();
  }

  saveToSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _prefs!.setString("KEY_1", _passw.toString());
    notifyListeners();
  }

  getValue() async {
    _prefs = await SharedPreferences.getInstance();
    _prefs!.getString('KEY_1').toString();
    notifyListeners();
  }
}
