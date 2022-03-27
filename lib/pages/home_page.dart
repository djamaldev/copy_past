import 'dart:async';

import 'package:copy_pasta/Providers/clip_board_provider.dart';
import 'package:copy_pasta/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:passcode_screen/circle.dart';
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

  @override
  void initState() {
    super.initState();
    ref.read(clipBoardProvider.notifier).getAllCopiedText();
    ref.read(clipBoardProvider.notifier).getSavedPasswcode();
    //print(storedPasscode);
  }

  /*_showSavedValue() async {
    SharedPreferences sPrefs = await SharedPreferences.getInstance();
    //sPrefs.clear();
    setState(() {
      storedPasscode = sPrefs.getString('KEY_1').toString();
    });
  }*/

  Future<void> _onRfresh() async {
    await ref.read(clipBoardProvider).getAllCopiedText();
  }

  _showDialog() async {
    //await Future.delayed(const Duration(milliseconds: 30));
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

  _defaultLockScreenButton(BuildContext ctx) => MaterialButton(
        color: Theme.of(context).primaryColor,
        child: const Text('Authenticate'),
        onPressed: () {
          _showLockScreen(
            ctx,
            opaque: false,
            cancelButton: const Text(
              'Cancel',
              style: TextStyle(fontSize: 16, color: Colors.white),
              semanticsLabel: 'Cancel',
            ),
          );
        },
      );

  _showLockScreen(
    BuildContext ctx, {
    required bool opaque,
    CircleUIConfig? circleUIConfig,
    KeyboardUIConfig? keyboardUIConfig,
    required Widget cancelButton,
    List<String>? digits,
  }) {
    Future.delayed(Duration.zero, () {
      Navigator.push(
        context,
        PageRouteBuilder(
          opaque: opaque,
          pageBuilder: (context, animation, secondaryAnimation) =>
              PasscodeScreen(
            //key: _formKey,
            title: const Text(
              'Enter App Passcode',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            //circleUIConfig: circleUIConfig,
            keyboardUIConfig: keyboardUIConfig,
            passwordEnteredCallback: _onPasscodeEntered,
            cancelButton: cancelButton,
            deleteButton: const Text(
              'Delete',
              style: TextStyle(fontSize: 16, color: Colors.white),
              semanticsLabel: 'Delete',
            ),
            shouldTriggerVerification: _verificationNotifier.stream,
            backgroundColor: Colors.black.withOpacity(0.8),
            cancelCallback: _onPasscodeCancelled,
            digits: digits,
            passwordDigits: 6,
            bottomWidget: _buildPasscodeRestoreButton(),
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
    super.dispose();
  }

  _buildPasscodeRestoreButton() => Align(
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
            onPressed: _resetAppPassword,
            // splashColor: Colors.white.withOpacity(0.4),
            // highlightColor: Colors.white.withOpacity(0.2),
            // ),
          ),
        ),
      );

  _resetAppPassword() {
    Navigator.maybePop(context).then((result) {
      if (!result) {
        return;
      }
      _showRestoreDialog(() {
        Navigator.maybePop(context);
        //TODO: Clear your stored passcode here
      });
    });
  }

  _showRestoreDialog(VoidCallback onAccepted) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
  }

  Widget _buildChild(BuildContext ctx) {
    var data = ref.watch(clipBoardProvider).taskList;
    //ref.read(clipBoardProvider.notifier).getSavedPasswcode();
    //storedPasscode = ref.watch(clipBoardProvider).passw;
    print(storedPasscode);
    if (ref.watch(clipBoardProvider).passw == '' || isAuthenticated) {
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
                        ref
                            .read(clipBoardProvider)
                            .copyText(data[index]['text']);
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
