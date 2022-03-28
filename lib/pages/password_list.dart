import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Providers/clip_board_provider.dart';

class PasswordList extends ConsumerStatefulWidget {
  const PasswordList({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _PasswordListState();
}

class _PasswordListState extends ConsumerState<PasswordList> {
  final clipBoardProvider = ChangeNotifierProvider<ClipBoardProvider>(
    (ref) => ClipBoardProvider(),
  );

  @override
  void initState() {
    super.initState();
    ref.read(clipBoardProvider.notifier).getAllCopiedPassword();
  }

  Future<void> _onRfresh() async {
    await ref.read(clipBoardProvider).getAllCopiedPassword();
  }

  _showDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          title: const Center(child: Text('copyPast')),
          content: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Text('Do you want to add password to the list ?')),
          actions: [
            TextButton(
                onPressed: () {
                  ref.read(clipBoardProvider).setPasswordData();
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
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          title: const Center(child: Text('Add password')),
          content: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: TextField(
              controller: textController,
              decoration: const InputDecoration(hintText: 'Enter text here'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                ref
                    .read(clipBoardProvider)
                    .addOtherPassword(textController.text);
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
    var data = ref.watch(clipBoardProvider).passwList;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password manager'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    contentPadding: const EdgeInsets.only(top: 10.0),
                    title: const Center(child: Text('copyPast')),
                    content: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: Text('Do you want to delete all password ?')),
                    actions: [
                      TextButton(
                          onPressed: () {
                            ref
                                .read(clipBoardProvider)
                                .deleteAllCopiedPassword();
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
      //drawer: const AppDrawer(),
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
                      ref
                          .read(clipBoardProvider)
                          .copyText(data[index]['password']);
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      ref.read(clipBoardProvider).deletePasswordAtIndex(
                          data[index]['password'].toString());
                      //print(index);
                    },
                  ),
                  title: Text(data[index]['password'].toString()),
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
