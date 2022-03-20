import 'package:copy_pasta/services/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/clip_board.dart';

class ClipBoardProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _taskList = [];
  bool _isFound = false;

  List get taskList => [..._taskList];
  bool get isFound => _isFound;

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
}
