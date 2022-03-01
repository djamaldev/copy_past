import 'package:copy_pasta/services/clip_board.dart';
import 'package:copy_pasta/services/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClipBoardProvider extends ChangeNotifier {
  final List<String> _copiedText = [];
  List<String> _allCopiedText = [];
  List _taskList = [];

  List<String> get copiedText => _copiedText;
  List<String> get allCopiedText => _allCopiedText;
  List get taskList => _taskList;
  copyText(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    print(text);
    notifyListeners();
  }

  deleteText(int index) async {
    //reloadList();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _allCopiedText.removeAt(index);
    //prefs.setStringList('index', _allCopiedText);
    //removAtIndexFromSP();
    //prefs.reload();
    notifyListeners();
  }

  Future<int> addText({ClipBoardManager? data}) {
    return DBHelper.insert(data);
  }

  Future<void> getCopiedText() async {
    //List<Map<String, dynamic>> listCopy = await DBHelper.query();
    //_taskList.addAll(listCopy);
    _taskList = await DBHelper.query();
  }

  Future<void> getTaskes() async {
    final List<Map<String, dynamic>> task = await DBHelper.query();
    _taskList.addAll(
        task.map((data) => ClipBoardManager.fromJson(data['text'])).toList());
  }

  getData() async {
    //getDataFromShared();
    //reloadList();
    getCopiedText();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Clipboard.getData(Clipboard.kTextPlain).then(
      (value) {
        /* _copiedText.addAll([value!.text!]);
        for (final ele in _copiedText) {
          _allCopiedText.insert(0, ele);
        }*/
        //prefs.setStringList('copy', _allCopiedText);
        addText(data: ClipBoardManager(text: value!.text!));
        //addTexttt(data: value!.text!);
        //DBHelper.insert(ClipBoardManager(text: ))
        print(value.text!);
      },
    );
    //print(_allCopiedText);
    notifyListeners();
  }

  deleteAllCopiedText() async {
    DBHelper.deleteAll();
    notifyListeners();
  }

  deleteTextAtIndex(ClipBoardManager? data) {
    DBHelper.delete(data);
    notifyListeners();
  }

  getDataFromShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('copy')) {
      return;
    }
    _allCopiedText.addAll(prefs.getStringList('copy')!);
  }

  removDataFromSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('copy');
    _allCopiedText = [];
    notifyListeners();
  }

  reloadList() async {
    //getDataFromShared();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('index')) {
      return;
    }
    _allCopiedText.addAll((prefs.getStringList('index')!));
  }
}
