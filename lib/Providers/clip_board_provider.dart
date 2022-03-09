import 'dart:convert';

import 'package:copy_pasta/services/clip_board.dart';
import 'package:copy_pasta/services/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClipBoardProvider extends ChangeNotifier {
  List<Map<dynamic, dynamic>> _taskList = [];
  bool _isExist = false;
  final bool _isDetected = false;
  final bool _isOk = false;
  final String _value = '';

  List get taskList => _taskList;
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
          if (element['text'] == value!.text) {
            _isExist = true;
          }
          //_value = value.text!;
          return _isExist;
        });
        !_isExist
            ? DBHelper.insert(ClipBoardManager(text: value!.text!))
            : null;
        String rawJson = '{"text":"${value!.text}"}';
        Map<String, dynamic> map = jsonDecode(rawJson) as Map<String, dynamic>;
        String name = map['text'];
        /*for (dynamic user in _taskList) {
          _taskList.add(user['text']);
          print(user['text']);
        }*/
        DBHelper.getRaw();
        //final List task = await DBHelper.query();
        //_taskList[0]['text'] = value.text;
        //List<ClipBoardManager>.from(_taskList.where((i) => i.flag == true));
      },
    );
    //_taskList =  DBHelper.query();
    notifyListeners();
  }

  deleteAllCopiedText() async {
    await DBHelper.deleteAll();
    //Clipboard.hasStrings();
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
