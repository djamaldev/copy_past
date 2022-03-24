import 'package:copy_pasta/pages/home_page.dart';
import 'package:copy_pasta/pages/passcode_screen.dart';
import 'package:copy_pasta/services/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'Providers/clip_board_provider.dart';

final clipBoardProvider =
    ChangeNotifierProvider<ClipBoardProvider>((ref) => ClipBoardProvider());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDB();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    /*ref.read(clipBoardProvider).getValue();
    storedPasscode = ref.watch(clipBoardProvider).passw;
    print(storedPasscode);
    if (storedPasscode == '') {
      ref.read(clipBoardProvider).removePasscode();
    }*/
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: storedPasscode.isEmpty ? const HomePage() : const LockScreen(),
    );
  }
}
