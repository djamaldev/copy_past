import 'package:copy_pasta/Providers/change_tehem_state.dart';
import 'package:copy_pasta/pages/home_page.dart';
import 'package:copy_pasta/services/db_helper.dart';
import 'package:copy_pasta/services/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Providers/clip_board_provider.dart';

final clipBoardProvider =
    ChangeNotifierProvider<ClipBoardProvider>((ref) => ClipBoardProvider());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  final prefs = await SharedPreferences.getInstance();
  prefs.getBool('dark');
  await DBHelper.initDB();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(changeTheme);
    return MaterialApp(
      //title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Styles.themeData(currentTheme.darkMode, context),
      home: const HomePage(),
    );
  }
}
