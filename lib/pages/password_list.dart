import 'package:copy_pasta/Providers/change_tehem_state.dart';
import 'package:copy_pasta/Providers/language_changer.dart';
import 'package:copy_pasta/services/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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

  final int maxFailedLoadAttempts = 3;
  InterstitialAd? _interstitialAd;
  int _interstitialLoadAttempts = 0;
  @override
  void initState() {
    super.initState();
    showInterstitialAd();
    ref.read(clipBoardProvider.notifier).getAllCopiedPassword();
    ref.read(changeLangauge).getLan();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          setState(() {
            _interstitialAd = ad;
            _interstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
            _interstitialAd?.show();
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          setState(() {
            _interstitialLoadAttempts += 1;
            _interstitialAd = null;
          });
          if (_interstitialLoadAttempts <= maxFailedLoadAttempts) {
            _createInterstitialAd();
          }
        },
      ),
    );
  }

  Future showInterstitialAd() async {
    Future.delayed(const Duration(seconds: 10), () {
      _createInterstitialAd();
    });
  }

  Future<void> _onRfresh() async {
    await ref.read(clipBoardProvider).getAllCopiedPassword();
  }

  _showDialog() async {
    final lan = ref.watch(changeLangauge);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          title: const Center(child: Text('copyPast')),
          content: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Text('${lan.getTexts('add_passw_alert')}')),
          actions: [
            TextButton(
                onPressed: () {
                  ref.read(clipBoardProvider).setPasswordData();
                  Navigator.of(context).pop();
                },
                child: Text('${lan.getTexts('ok')}')),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                showDialogWithFields();
              },
              child: Text('${lan.getTexts('other_passw')}'),
            )
          ],
        );
      },
    );
  }

  void showDialogWithFields() {
    final lan = ref.watch(changeLangauge);
    showDialog(
      context: context,
      builder: (_) {
        var textController = TextEditingController();
        //var messageController = TextEditingController();
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          title: Center(child: Text('${lan.getTexts('add_password')}')),
          content: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: TextField(
              controller: textController,
              decoration:
                  InputDecoration(hintText: '${lan.getTexts('enter_txt')}'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('${lan.getTexts('cancel')}'),
            ),
            TextButton(
              onPressed: () {
                ref
                    .read(clipBoardProvider)
                    .addOtherPassword(textController.text);
                Navigator.pop(context);
              },
              child: Text('${lan.getTexts('add')}'),
            ),
          ],
        );
      },
    );
  }

  _copiedToClipBoardDialog() async {
    final lan = ref.watch(changeLangauge);
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          title: const Center(child: Text('copyPast')),
          content: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Text('${lan.getTexts('copied_txt')}')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('${lan.getTexts('ok')}'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var data = ref.watch(clipBoardProvider).passwList;
    final isDarkMode = ref.watch(changeTheme).darkMode;
    final lan = ref.watch(changeLangauge);
    return Scaffold(
      appBar: AppBar(
        title: Text('${lan.getTexts('passw_manager')}'),
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
                    content: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child:
                            Text('${lan.getTexts('delete_all_passw_alert')}')),
                    actions: [
                      TextButton(
                          onPressed: () {
                            ref
                                .read(clipBoardProvider)
                                .deleteAllCopiedPassword();
                            Navigator.of(context).pop();
                          },
                          child: Text('${lan.getTexts('ok')}')),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('${lan.getTexts('cancel')}'),
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
      body: SafeArea(
        child: RefreshIndicator(
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
                        _copiedToClipBoardDialog();
                      },
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              contentPadding: const EdgeInsets.only(top: 10.0),
                              title: const Center(child: Text('copyPast')),
                              content: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 10.0),
                                  child: Text('${lan.getTexts('delete_txt')}')),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    ref
                                        .read(clipBoardProvider)
                                        .deletePasswordAtIndex(
                                            data[index]['password'].toString());
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('${lan.getTexts('ok')}'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('${lan.getTexts('cancel')}'),
                                ),
                              ],
                            );
                          },
                        );
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
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: isDarkMode ? Colors.white : Colors.red,
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
