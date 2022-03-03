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

  @override
  void initState() {
    super.initState();
    ref.read(clipBoardProvider).getAllCopiedText();
    _showDialog();
  }

  _onRefrech() async {
    ref.read(clipBoardProvider).getAllCopiedText();
  }

  _showDialog() async {
    await Future.delayed(const Duration(milliseconds: 50));
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
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          RefreshIndicator(
            onRefresh: () => _onRefrech(),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: ref.watch(clipBoardProvider).taskList.length,
              itemBuilder: (context, index) {
                var data = ref.watch(clipBoardProvider).taskList;
                //Map<String, dynamic> item = snapshot.data![index];
                return ListTile(
                  leading: IconButton(
                      icon: const Icon(Icons.copy), onPressed: () {}),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => ref
                        .read(clipBoardProvider)
                        .deleteTextAtIndex(data[index]),
                  ),
                  title: Text(data[index]['text']),
                );
              },
            ),
          ),
          TextButton(
            onPressed: () => ref.read(clipBoardProvider).setData(),
            child: const Text('set'),
          ),
        ],
      ),
    );
  }
}
