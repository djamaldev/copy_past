import 'package:copy_pasta/Providers/clip_board_provider.dart';
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
  bool isActve = false;
  String text = 'Add passcode';
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
    Future.delayed(Duration.zero, () {
      value = ref.watch(clipBoardProvider).passw;
      if (value.isNotEmpty) {
        setState(() {
          isActve = true;
          text = 'Remove passcode';
        });
      } else {
        setState(() {
          isActve = false;
        });
      }
    });
  }

  void _showPasscodeDialog() {
    showDialog(
      context: context,
      builder: (_) {
        //var messageController = TextEditingController();
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          title: const Center(
            child: Text(
              'Please save your passcode in safe place !',
              style: TextStyle(color: Colors.red),
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
                      decoration: const InputDecoration(
                          hintText: 'Enter 6 digits numbers here'),
                      validator: (val) {
                        if (val!.length != 6 || val.isEmpty) {
                          return 'The passcode should contains 6 digit number';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: confirmPasscodeController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      decoration:
                          const InputDecoration(hintText: 'Confirm passcode'),
                      validator: (val) {
                        if (val != passcodeController.text || val!.isEmpty) {
                          return 'The passcode confirmation does not match';
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
              child: const Text('Cancel'),
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
              child: const Text('Set'),
            ),
          ],
        );
      },
    );
  }

  _showRemoveDialog() async {
    //await Future.delayed(const Duration(milliseconds: 30));
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
              child: Text('Do you want to remove the passcode ?')),
          actions: [
            TextButton(
              onPressed: () {
                ref.read(clipBoardProvider).removePasscode();
                Navigator.of(context).pop();
              },
              child: const Text('Ok'),
            ),
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
  }

  @override
  Widget build(BuildContext context) {
    storedPasscode = ref.watch(clipBoardProvider).passw;
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('CopyPast'),
            automaticallyImplyLeading: true,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Home'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Orders'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Passwords list'),
            onTap: () {
              Future.delayed(Duration.zero, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PasswordList()),
                );
              });
            },
          ),
          const Divider(),
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
            title: Text(text),
          ),
        ],
      ),
    );
  }
}
