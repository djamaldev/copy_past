import 'package:copy_pasta/Providers/clip_board_provider.dart';
import 'package:copy_pasta/widgets/app_drawer.dart';
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
    ref.read(clipBoardProvider.notifier).getAllCopiedText();
    //_showDialog();
  }

  Future<void> _onRfresh() async {
    await ref.read(clipBoardProvider).getAllCopiedText();
  }

  _showDialog() async {
    //await Future.delayed(const Duration(milliseconds: 30));
    var _isfound = ref.watch(clipBoardProvider).isFound;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('copyPast'),
          content: const Text(
              'Do you want to add copied text from system to the list ?'),
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
                showDialogWithFields();
              },
              child: const Text('Add other text'),
            )
          ],
        );
      },
    );
  }

  void showDialogWithFields() {
    showDialog(
      context: context,
      builder: (_) {
        var textController = TextEditingController();
        //var messageController = TextEditingController();
        return AlertDialog(
          title: const Text('Contact Us'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: 'Enter text here'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                ref.read(clipBoardProvider).coyOtherText(textController.text);
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var data = ref.watch(clipBoardProvider).taskList;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit product'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('copyPast'),
                    content: const Text('Do you want to delete all text ?'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            ref.read(clipBoardProvider).deleteAllCopiedText();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Yes')),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      )
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.delete_outline_rounded),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: _onRfresh,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
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
                ),
                const Divider(height: 1.0)
              ],
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
