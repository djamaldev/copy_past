import 'package:copy_pasta/services/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/clip_board.dart';

class ClipBoardProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _taskList = [];

  List get taskList => [..._taskList];

  copyText(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    print(text);
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
        bool dd = await DBHelper.texExists(value!.text!);
        if (dd == false) {
          await DBHelper.insert(ClipBoardManager(text: value.text));
          getAllCopiedText();
        } else {
          Null;
        }
      },
    );
    print('list = $_taskList');
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
