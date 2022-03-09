import 'package:copy_pasta/Providers/clip_board_provider.dart';
import 'package:copy_pasta/services/clip_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  //final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final clipBoardProvider =
      ChangeNotifierProvider<ClipBoardProvider>((ref) => ClipBoardProvider());
  bool _isok = false;
  @override
  void initState() {
    super.initState();
    ref.read(clipBoardProvider).getAllCopiedText();
    //_showDialog();
  }

  _showDialog() async {
    await Future.delayed(const Duration(milliseconds: 30));
    var isFound = ref.watch(clipBoardProvider).isExist;
    !isFound
        ? showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('copyPast'),
                content: const Text('Copied text detect from clipboard'),
                actions: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _isok = true;
                        });
                        _isok ? ref.read(clipBoardProvider).setData() : null;
                        //ref.read(clipBoardProvider).getAllCopiedText();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Ok')),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('close'),
                  )
                ],
              );
            })
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: ref.watch(clipBoardProvider).taskList.length,
        itemBuilder: (context, index) {
          var data = ref.watch(clipBoardProvider).taskList;
          ClipBoardManager? d;
          return ListTile(
            leading: IconButton(icon: const Icon(Icons.copy), onPressed: () {}),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () =>
                  ref.read(clipBoardProvider).deleteAllCopiedText(),
            ),
            title: Text(data[index]['text'].toString()),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showDialog();
          //ref.read(clipBoardProvider).getAllCopiedText();
        },
      ),
    );
  }
}
