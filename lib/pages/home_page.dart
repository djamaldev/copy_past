import 'package:copy_pasta/Providers/clip_board_provider.dart';
import 'package:copy_pasta/services/clip_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/db_helper.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  //final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final clipBoardProvider =
      ChangeNotifierProvider((ref) => ClipBoardProvider());
  TextEditingController field = TextEditingController();
  final List<String> _item = [];
  //List<String> allCopiedText = [];

  @override
  void initState() {
    //DBHelper.initDB();
    //DBHelper.insertIntoDB('text111');
    ref.read(clipBoardProvider).getData();
    //getData();
    super.initState();
  }

  void getData() async {
    await DBHelper.insert(ClipBoardManager(text: 'tttt'));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: ref.watch(clipBoardProvider).taskList.length,
        itemBuilder: (context, index) {
          var text = ref.watch(clipBoardProvider).taskList[index];
          return ref.watch(clipBoardProvider).taskList == []
              ? const Center(
                  child: Text('No data!'),
                )
              : ListTile(
                  leading: IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () => ref.read(clipBoardProvider).copyText(
                        ref.watch(clipBoardProvider).allCopiedText[index]),
                  ),
                  trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        ref.read(clipBoardProvider).deleteTextAtIndex(text);
                      }),
                  title: Text(
                    ref.watch(clipBoardProvider).taskList[index].toString(),
                  ),
                );
        },
      ),
    );
  }
}
