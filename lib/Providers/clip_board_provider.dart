import 'package:copy_pasta/services/clip_board.dart';
import 'package:copy_pasta/services/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClipBoardProvider extends ChangeNotifier {
  List _taskList = [];

  List get taskList => _taskList;

  copyText(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    print(text);
    notifyListeners();
  }

  Future<int> addCopiedText({ClipBoardManager? data}) {
    return DBHelper.insert(data);
  }

  Future<void> getAllCopiedText() async {
    _taskList = await DBHelper.query();
  }

  getData() async {
    getAllCopiedText();
    await Clipboard.getData(Clipboard.kTextPlain).then(
      (value) {
        addCopiedText(data: ClipBoardManager(text: value!.text!));
        //print(value.text!);
      },
    );
    notifyListeners();
  }

  deleteAllCopiedText() async {
    await DBHelper.deleteAll();
    notifyListeners();
  }

  deleteTextAtIndex(ClipBoardManager? data) async {
    await DBHelper.delete(data);
    notifyListeners();
  }
}
