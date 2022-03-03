import 'package:copy_pasta/services/clip_board.dart';
import 'package:copy_pasta/services/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClipBoardProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _taskList = [];

  List get taskList => _taskList;

  copyText(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    print(text);
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getAllCopiedText() async {
    _taskList = await DBHelper.query();
    notifyListeners();
    return _taskList;
  }

  Future<void> setData() async {
    //getAllCopiedText();
    await Clipboard.getData(Clipboard.kTextPlain).then(
      (value) async {
        await DBHelper.insert(ClipBoardManager(text: value!.text!));
        _taskList = await DBHelper.query();
        //addCopiedText(data: ClipBoardManager(text: value!.text!));
        print(value.text!);
      },
    );
    notifyListeners();
  }

  deleteAllCopiedText() async {
    await DBHelper.deleteAll();
    Clipboard.setData(const ClipboardData(text: null));
    _taskList = [];
    notifyListeners();
  }

  deleteTextAtIndex(ClipBoardManager? data) async {
    await DBHelper.delete(data);
    //_taskList.remove(data);
    notifyListeners();
  }
}
