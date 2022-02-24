import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  //final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController field = TextEditingController();
  final List<String> _copiedText = [];
  List<String> allCopiedText = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
    //_remove();
  }

  _getData() async {
    //_getDataFromShared();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //allCopiedText.addAll(prefs.getStringList('copy')!);
    Clipboard.getData(Clipboard.kTextPlain).then(
      (value) {
        _copiedText.addAll([value!.text!]);
        for (final element in _copiedText) {
          allCopiedText.insert(0, element);
        }
        //allCopiedText.insertAll(0, _copiedText);
        //prefs.setStringList('copy', allCopiedText);
        print(allCopiedText);
      },
    );
  }

  _remove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.remove('copy');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            shrinkWrap: true,
            itemCount: allCopiedText.length,
            itemBuilder: (context, index) {
              //_getData();
              return ListTile(
                title: Text(
                  allCopiedText[index],
                ),
              );
            }));
  }
}
