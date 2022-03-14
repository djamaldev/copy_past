import 'package:copy_pasta/services/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/clip_board.dart';

class ClipBoardProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _taskList = [];
  bool _isExist = false;
  final bool _isDetected = false;
  final bool _isOk = false;
  final String _value = '';

  List get taskList => [..._taskList];
  bool get isExist => _isExist;
  bool get isDetected => _isDetected;
  bool get isOk => _isOk;

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
        _taskList.indexWhere((element) {
          if (element.containsValue(value!.text)) {
            _isExist = true;
          }
          //_value = value.text!;
          return false;
        });
        if (!isExist) {
          await DBHelper.insert(ClipBoardManager(text: value!.text!));
          getAllCopiedText();
        } else {
          Null;
        }
        //_taskList.where((element) => element['text'] != value!.text);
        //await DBHelper.insert(ClipBoardManager(text: value!.text!));
      },
    );
    // _taskList = await DBHelper.query();
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
