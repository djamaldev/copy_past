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
  TextEditingController field = TextEditingController();
  final List<String> _item = [];
  //List<String> allCopiedText = [];

  @override
  void initState() {
    ref.read(clipBoardProvider).getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: ref.watch(clipBoardProvider).allCopiedText.length,
        itemBuilder: (context, index) {
          //ref.read(clipBoardProvider).getData();
          return ref.watch(clipBoardProvider).allCopiedText == []
              ? const Center(
                  child: Text('No data!'),
                )
              : ListTile(
                  leading: GestureDetector(
                    onTap: () => Future.delayed(
                      Duration.zero,
                      () => ref.read(clipBoardProvider).copyText(
                          ref.watch(clipBoardProvider).allCopiedText[index]),
                    ), //ref.read(clipBoardProvider).copyText('text'),
                    child: const Icon(Icons.copy),
                  ),
                  title: Text(
                    ref.watch(clipBoardProvider).allCopiedText[index],
                  ),
                );
        },
      ),
    );
  }
}
