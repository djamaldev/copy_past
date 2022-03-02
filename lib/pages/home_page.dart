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
      ChangeNotifierProvider((ref) => ClipBoardProvider());

  @override
  void initState() {
    super.initState();
    ref.read(clipBoardProvider).getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: ref.watch(clipBoardProvider).taskList.length,
        itemBuilder: (context, index) {
          var data = ref.watch(clipBoardProvider).taskList;
          return ref.watch(clipBoardProvider).taskList == []
              ? const Center(
                  child: Text('No data!'),
                )
              : ListTile(
                  leading: IconButton(
                      icon: const Icon(Icons.copy), onPressed: () {}),
                  trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        ref.read(clipBoardProvider).deleteAllCopiedText();
                      }),
                  title: Text(data[index]['text']),
                );
        },
      ),
    );
  }
}
