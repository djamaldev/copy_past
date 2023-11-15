import 'dart:async';

import 'package:copy_pasta/Providers/change_tehem_state.dart';
import 'package:copy_pasta/Providers/clip_board_provider.dart';
import 'package:copy_pasta/Providers/language_changer.dart';
import 'package:copy_pasta/services/ad_helper.dart';
import 'package:copy_pasta/widgets/app_drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  //final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final clipBoardProvider = ChangeNotifierProvider<ClipBoardProvider>(
    (ref) => ClipBoardProvider(),
  );
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();
  bool isAuthenticated = false;
  String? storedPasscode;
  SharedPreferences? prefs;
  final int maxFailedLoadAttempts = 3;
  InterstitialAd? _interstitialAd;
  int _interstitialLoadAttempts = 0;
  AppOpenAd? _appOpenAd;
  final bool _isloaded = false;
  final bool _adShowing = false;
  bool _bannerAdReady = false;
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    ref.read(clipBoardProvider.notifier).getAllCopiedText();
    ref.read(clipBoardProvider.notifier).getSavedPasswcode();
    ref.read(changeTheme).getSavedTheme();
    ref.read(changeLangauge).getLan();
    showOpenAd();
    //showInterstitialAd();
    _loadBannerId();
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

  void _loadOpenAd() {
    AppOpenAd.load(
      adUnitId: AdHelper.OpenAppAdAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _appOpenAd = ad;
            _appOpenAd?.show();
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          if (kDebugMode) {
            print('AppOpenAd failed to load: $error');
          }
        },
      ),
      orientation: AppOpenAd.orientationPortrait,
    );
  }

  Future<void> _loadBannerId() async {
    BannerAd(
      adUnitId: AdHelper.banerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
            _bannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          if (kDebugMode) {
            print('Failed to load a banner ad: ${err.message}');
          }
          ad.dispose();
        },
      ),
    ).load();
  }

  Future showOpenAd() async {
    Future.delayed(const Duration(seconds: 5), () {
      _loadOpenAd();
    });
  }

  Future showInterstitialAd() async {
    Future.delayed(const Duration(seconds: 10), () {
      _createInterstitialAd();
    });
  }

  Future<void> _onRfresh() async {
    await ref.read(clipBoardProvider).getAllCopiedText();
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
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text('${lan.getTexts('alert_copied_txt')}'),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  ref.read(clipBoardProvider).setData();
                  Navigator.of(context).pop();
                },
                child: Text('${lan.getTexts('ok')}')),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                showDialogWithFields();
              },
              child: Text('${lan.getTexts('add_other_txt')}'),
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
          title: const Center(child: Text('CopyPast')),
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
                ref.read(clipBoardProvider).addOtherText(textController.text);
                Navigator.pop(context);
              },
              child: Text('${lan.getTexts('add')}'),
            ),
          ],
        );
      },
    );
  }

  _defaultLockScreenButton(BuildContext ctx) {
    final lan = ref.watch(changeLangauge);
    return MaterialButton(
      color: Theme.of(context).primaryColor,
      child: Text('${lan.getTexts('authenticate')}'),
      onPressed: () {
        _showLockScreen(
          ctx,
          opaque: false,
          cancelButton: Text(
            '${lan.getTexts('cancel')}',
            style: const TextStyle(fontSize: 16, color: Colors.white),
            semanticsLabel: '${lan.getTexts('cancel')}',
          ),
        );
      },
    );
  }

  _showLockScreen(
    BuildContext ctx, {
    required bool opaque,
    KeyboardUIConfig? keyboardUIConfig,
    required Widget cancelButton,
    List<String>? digits,
  }) {
    final lan = ref.watch(changeLangauge);
    Future.delayed(Duration.zero, () {
      Navigator.push(
        context,
        PageRouteBuilder(
          opaque: opaque,
          pageBuilder: (context, animation, secondaryAnimation) =>
              PasscodeScreen(
            //key: _formKey,
            title: Text(
              '${lan.getTexts('enter_app_passcode')}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 28),
            ),
            //circleUIConfig: circleUIConfig,
            keyboardUIConfig: keyboardUIConfig,
            passwordEnteredCallback: _onPasscodeEntered,
            cancelButton: cancelButton,
            deleteButton: Text(
              '${lan.getTexts('delete')}',
              style: const TextStyle(fontSize: 16, color: Colors.white),
              semanticsLabel: '${lan.getTexts('delete')}',
            ),
            shouldTriggerVerification: _verificationNotifier.stream,
            backgroundColor: Colors.black.withOpacity(0.8),
            cancelCallback: _onPasscodeCancelled,
            digits: digits,
            passwordDigits: 6,
            //bottomWidget: _buildPasscodeRestoreButton(),
          ),
        ),
      );
    });
  }

  _onPasscodeEntered(String enteredPasscode) {
    storedPasscode = ref.watch(clipBoardProvider).passw;
    //_showSavedValue();
    bool isValid = storedPasscode == enteredPasscode;
    _verificationNotifier.add(isValid);
    if (isValid) {
      setState(() {
        isAuthenticated = isValid;
      });
    }
  }

  _onPasscodeCancelled() {
    Navigator.maybePop(context);
  }

  @override
  void dispose() {
    _verificationNotifier.close();
    _interstitialAd?.dispose();
    _appOpenAd?.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  /*_buildPasscodeRestoreButton() => Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10.0, top: 20.0),
          child: TextButton(
            child: const Text(
              "Reset passcode",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w300),
            ),
            onPressed: () {},
            // splashColor: Colors.white.withOpacity(0.4),
            // highlightColor: Colors.white.withOpacity(0.2),
            // ),
          ),
        ),
      );*/

  /*_resetAppPassword() {
    Navigator.maybePop(context).then((result) {
      if (!result) {
        return;
      }
      _showRestoreDialog(() {
        Navigator.maybePop(context);
        //TODO: Clear your stored passcode here
      });
    });
  }*/

  /*_showRestoreDialog(VoidCallback onAccepted) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          title: const Text(
            "Reset passcode",
            style: TextStyle(color: Colors.black87),
          ),
          content: const Text(
            "Passcode reset is a non-secure operation!\n\nConsider removing all user data if this action performed.",
            style: TextStyle(color: Colors.black87),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: const Text(
                "Cancel",
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.maybePop(context);
              },
            ),
            TextButton(
              child: const Text(
                "I understand",
                style: TextStyle(fontSize: 18),
              ),
              onPressed: onAccepted,
            ),
          ],
        );
      },
    );
  }*/

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

  Widget _buildChild(BuildContext ctx) {
    final lan = ref.watch(changeLangauge);
    var data = ref.watch(clipBoardProvider).taskList;
    final isDarkMode = ref.watch(changeTheme).darkMode;
    final theme = Theme.of(context);
    if (ref.watch(clipBoardProvider).passw == '' || isAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          //backgroundColor: theme.backgroundColor,
          title: Text('${lan.getTexts('clipBoard_manager')}'),
          centerTitle: true,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          contentPadding: const EdgeInsets.only(top: 10.0),
                          title: const Center(child: Text('copyPast')),
                          content: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              child: Text('${lan.getTexts('delete_all_txt')}')),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  ref
                                      .read(clipBoardProvider)
                                      .deleteAllCopiedText();
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Ok')),
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
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _showDialog();
                    });
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            )
          ],
        ),
        drawer: const SafeArea(child: AppDrawer()),
        body: SafeArea(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RefreshIndicator(
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
                                  .copyText(data[index]['text']);
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    contentPadding:
                                        const EdgeInsets.only(top: 10.0),
                                    title:
                                        const Center(child: Text('copyPast')),
                                    content: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 10.0),
                                        child: Text(
                                            '${lan.getTexts('delete_txt')}')),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          ref
                                              .read(clipBoardProvider)
                                              .deleteTextAtIndex(data[index]
                                                      ['text']
                                                  .toString());
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('${lan.getTexts('ok')}'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child:
                                            Text('${lan.getTexts('cancel')}'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              //print(index);
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
              if (_bannerAd != null && _bannerAdReady)
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: _bannerAd!.size.width.toDouble(),
                      height: _bannerAd!.size.height.toDouble(),
                      child: AdWidget(ad: _bannerAd!),
                    ),
                  ),
                ),
            ],
          ),
        ),
        /*floatingActionButton: FloatingActionButton(
          backgroundColor: isDarkMode ? Colors.white : Colors.red,
          child: const Icon(Icons.add),
          onPressed: () {
            setState(() {
              _showDialog();
            });
          },
        ),*/
      );
    } else {
      return Center(
        child: _defaultLockScreenButton(context),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildChild(context);
  }
}
