import 'package:copy_pasta/services/clip_board.dart';
import 'package:copy_pasta/services/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClipBoardProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _taskList = [];
  bool _isExist = false;

  List get taskList => _taskList;
  bool get isExist => _isExist;

  copyText(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    print(text);
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getAllCopiedText() async {
    _taskList = await DBHelper.query();
    print('list = ${_taskList.toString()}');
    notifyListeners();
    return _taskList;
  }

  bool findPersonUsingIndexWhere(String text) {
    // Find the index of person. If not found, index = -1
    _taskList.indexWhere((element) {
      if (element['text'] == text) {
        print('exist: ${element['text']}');
        //return true;
      }
      return true;
    });
    return false;
  }

  Future<void> setData() async {
    await Clipboard.getData(Clipboard.kTextPlain).then(
      (value) {
        _taskList.indexWhere((element) {
          if (element['text'] == value!.text) {
            _isExist = true;
          }
          return _isExist;
        });
        !_isExist
            ? DBHelper.insert(ClipBoardManager(text: value!.text!))
            : null;
      },
    );
    notifyListeners();
  }

  deleteAllCopiedText() async {
    await DBHelper.deleteAll();
    Clipboard.getData('');
    _taskList = [];
    notifyListeners();
  }

  /*deleteTextAtIndex(ClipBoardManager? data) async {
    await DBHelper.delete(data);
    //_taskList.remove(data);
    notifyListeners();
  }*/

  deleteTextAtIndex(ClipBoardManager? data) async {
    await DBHelper.delete(data);
    _taskList.removeAt(data!.id!);
    notifyListeners();
  }
}
