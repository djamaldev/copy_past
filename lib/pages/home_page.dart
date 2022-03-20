import 'package:copy_pasta/Providers/clip_board_provider.dart';
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
  final bool _isok = false;
  @override
  void initState() {
    super.initState();
    ref.read(clipBoardProvider.notifier).getAllCopiedText();
    //_showDialog();
  }

  Future<void> _onRfresh() async {
    await ref.read(clipBoardProvider.notifier).getAllCopiedText();
  }

  _showDialog() async {
    //await Future.delayed(const Duration(milliseconds: 30));
    //var isFound = !ref.watch(clipBoardProvider).isExist;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('copyPast'),
            content: const Text('Copied text detect from clipboard'),
            actions: [
              TextButton(
                  onPressed: () {
                    ref.read(clipBoardProvider).setData();
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
        });
  }

  @override
  Widget build(BuildContext context) {
    var data = ref.watch(clipBoardProvider).taskList;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRfresh,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  ref.read(clipBoardProvider).copyText(data[index]['text']);
                },
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  ref
                      .read(clipBoardProvider)
                      .deleteTextAtIndex(data[index]['text'].toString());
                  print(index);
                },
              ),
              title: Text(data[index]['text'].toString()),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          setState(() {
            _showDialog();
          });
        },
      ),
    );
  }
}
