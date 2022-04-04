import 'package:copy_pasta/Providers/change_tehem_state.dart';
import 'package:copy_pasta/Providers/clip_board_provider.dart';
import 'package:copy_pasta/Providers/language_changer.dart';
import 'package:copy_pasta/pages/password_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends ConsumerStatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends ConsumerState<AppDrawer> {
  final clipBoardProvider =
      ChangeNotifierProvider<ClipBoardProvider>((ref) => ClipBoardProvider());
  var passcodeController = TextEditingController();
  var confirmPasscodeController = TextEditingController();
  var checkPasscodeController = TextEditingController();
  bool isActve = false;
  bool isVisible = false;
  //bool isDarkMode = false;
  //String text = '';
  //String textDark = 'Dark mode';
  var storedPasscode = '';
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    ref.read(clipBoardProvider.notifier).getAllCopiedText();
    ref.read(clipBoardProvider.notifier).getSavedPasswcode();
    _showSavedValue();
  }

  _showSavedValue() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var value = '';
    //text = '${_lan.getTexts('add_password')}';
    Future.delayed(Duration.zero, () {
      value = ref.read(clipBoardProvider).passw;
      if (value.isNotEmpty) {
        setState(() {
          isActve = true;
          //text = '${_lan.getTexts('remove_passcode')}';
        });
      } else {
        setState(() {
          isActve = false;
        });
      }
    });
  }

  void _showPasscodeDialog() {
    final _lan = ref.watch(changeLangauge);
    showDialog(
      context: context,
      builder: (_) {
        //var messageController = TextEditingController();
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          title: Center(
            child: Text(
              '${_lan.getTexts('save_passw_alert')}',
              style: const TextStyle(color: Colors.red),
            ),
          ),
          content: SizedBox(
            height: 200,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: passcodeController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: '${_lan.getTexts('enter_digit_numb')}'),
                      validator: (val) {
                        if (val!.length != 6 || val.isEmpty) {
                          return '${_lan.getTexts('gigit_numb_alert')}';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: confirmPasscodeController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: '${_lan.getTexts('confirm_passcode')}'),
                      validator: (val) {
                        if (val != passcodeController.text || val!.isEmpty) {
                          return '${_lan.getTexts('confirm_passcode_alert')}';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  isActve = false;
                });
                Navigator.pop(context);
              },
              child: Text('${_lan.getTexts('cancel')}'),
            ),
            TextButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) {
                  return;
                }
                FocusScope.of(context).unfocus();
                _formKey.currentState?.save();
                ref
                    .read(clipBoardProvider)
                    .setPasscode(passcodeController.text.toString());
                storedPasscode = ref.watch(clipBoardProvider).passw;
                if (storedPasscode.isNotEmpty) {
                  //print(value);
                  setState(() {
                    isActve = true;
                  });
                }

                Navigator.pop(context);
              },
              child: Text('${_lan.getTexts('set')}'),
            ),
          ],
        );
      },
    );
  }

  _showRemoveDialog() async {
    final _lan = ref.watch(changeLangauge);
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          title: const Center(child: Text('copyPast')),
          content: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Text('${_lan.getTexts('remove_passcode_alert')}')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showEnterPasscodeDialogue();
              },
              child: Text('${_lan.getTexts('ok')}'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('${_lan.getTexts('cancel')}'),
            )
          ],
        );
      },
    );
  }

  _showEnterPasscodeDialogue() {
    final _lan = ref.watch(changeLangauge);
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          title: const Center(child: Text('copyPast')),
          content: SizedBox(
            height: 200,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: checkPasscodeController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: '${_lan.getTexts('enter_correct_passcode')}'),
                  validator: (val) {
                    if (val!.toString() != ref.watch(clipBoardProvider).passw ||
                        val.isEmpty) {
                      return '${_lan.getTexts('incorrect_passcode')}';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) {
                  return;
                }
                FocusScope.of(context).unfocus();
                _formKey.currentState?.save();
                ref.read(clipBoardProvider).removePasscode();
                Navigator.of(context).pop();
              },
              child: Text('${_lan.getTexts('ok')}'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('${_lan.getTexts('cancel')}'),
            )
          ],
        );
      },
    );
  }

  _alertShowListPasswordDialogue() {
    final _lan = ref.watch(changeLangauge);
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          title: const Center(child: Text('copyPast')),
          content: SizedBox(
            height: 200,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: checkPasscodeController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: '${_lan.getTexts('enter_correct_passcode')}'),
                  validator: (val) {
                    if (val!.toString() != ref.watch(clipBoardProvider).passw ||
                        val.isEmpty) {
                      return '${_lan.getTexts('incorrect_passcode')}';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) {
                  return;
                }
                FocusScope.of(context).unfocus();
                _formKey.currentState?.save();
                Future.delayed(Duration.zero, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PasswordList()),
                  );
                });
                Navigator.of(context).pop();
              },
              child: Text('${_lan.getTexts('ok')}'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('${_lan.getTexts('cancel')}'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _lan = ref.watch(changeLangauge);
    var _passcode = ref.watch(clipBoardProvider).passw;
    var isDarkMode = ref.watch(changeTheme).darkMode;
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: isDarkMode ? Colors.black : Colors.white,
        //other styles
      ),
      child: Drawer(
        //elevation: 2.0,
        child: Column(
          children: [
            AppBar(
              title: const Text('CopyPast'),
              automaticallyImplyLeading: true,
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text('${_lan.getTexts('home')}'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            Divider(
              color: isDarkMode ? Colors.white : Colors.grey,
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: Text('${_lan.getTexts('list_password')}'),
              onTap: () {
                if (_passcode.isNotEmpty) {
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
                            child: Text('${_lan.getTexts('security_txt')}')),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _alertShowListPasswordDialogue();
                            },
                            child: Text('${_lan.getTexts('ok')}'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('${_lan.getTexts('cancel')}'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  Future.delayed(Duration.zero, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PasswordList()),
                    );
                  });
                }
              },
            ),
            Divider(
              color: isDarkMode ? Colors.white : Colors.grey,
            ),
            ListTile(
              leading: const Icon(Icons.password),
              trailing: Switch(
                value: isActve,
                onChanged: (val) {
                  setState(() {
                    isActve = val;
                  });
                  if (isActve) {
                    _showPasscodeDialog();
                  } else {
                    _showRemoveDialog();
                  }
                },
              ),
              title: Text(isActve
                  ? '${_lan.getTexts('remove_passcode')}'
                  : '${_lan.getTexts('add_passcode')}'),
            ),
            Divider(
              color: isDarkMode ? Colors.white : Colors.grey,
            ),
            ListTile(
              leading: const Icon(Icons.language_outlined),
              title: Text('${_lan.getTexts('language')}'),
              trailing: Visibility(
                visible: isVisible,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${_lan.getTexts('arabic')}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Switch(
                      value: _lan.isEn,
                      onChanged: (value) => _lan.changeLan(value),
                    ),
                    Text(
                      '${_lan.getTexts('english')}',
                      style: const TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
              onTap: () {
                setState(() {
                  isVisible = !isVisible;
                });
              },
            ),
            Divider(
              color: isDarkMode ? Colors.white : Colors.grey,
            ),
            ListTile(
              leading: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              title: Text(isDarkMode
                  ? '${_lan.getTexts('light_mode')}'
                  : '${_lan.getTexts('dark_mode')}'),
              trailing: Switch(
                value: isDarkMode,
                onChanged: (val) => ref.read(changeTheme).changeTheme(val),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
