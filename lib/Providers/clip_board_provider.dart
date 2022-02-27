import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClipBoardProvider extends ChangeNotifier {
  final List<String> _copiedText = [];
  List<String> _allCopiedText = [];
  final String _text = '';

  List<String> get copiedText => _copiedText;
  List<String> get allCopiedText => _allCopiedText;

  copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    print(text);
    notifyListeners();
  }

  getData() async {
    getDataFromShared();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Clipboard.getData(Clipboard.kTextPlain).then(
      (value) {
        // _text = value!.text!;
        _copiedText.addAll([value!.text!]);
        for (final ele in _copiedText) {
          _allCopiedText.insert(0, ele);
        }
        //notifyListeners();
        //allCopiedText.insertAll(0, _copiedText);
        prefs.setStringList('copy', _allCopiedText);
        //print(_copiedText);
      },
    );
    //_allCopiedText.addAll(_copiedText);
    print(_allCopiedText);
    notifyListeners();
  }

  getDataFromShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('copy')) {
      return;
    }
    _allCopiedText.addAll(prefs.getStringList('copy')!);
    //_allCopiedText = prefs.getStringList('copy')!;
    //print(prefs.getStringList('copy'));
    //notifyListeners();
  }

  removDataFromSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('copy');
    _allCopiedText = [];
  }
}
