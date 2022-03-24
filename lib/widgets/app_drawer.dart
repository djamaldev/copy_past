import 'package:copy_pasta/Providers/clip_board_provider.dart';
import 'package:copy_pasta/pages/passcode_screen.dart';
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

  @override
  void initState() {
    super.initState();
    ref.read(clipBoardProvider.notifier).getAllCopiedText();
    _showSavedValue();
  }

  _showSavedValue() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String val = '';
    setState(() {
      val = _prefs.getString('KEY_1').toString();
    });
    if (val.isEmpty || val == '') {
      setState(() {
        isActve = false;
      });
    }
  }

  void _showPasscodeDialog() {
    showDialog(
      context: context,
      builder: (_) {
        //var messageController = TextEditingController();
        return SizedBox(
          height: 350,
          child: AlertDialog(
            title: const Center(
              child: Text(
                'Please save your passcode in safe place !',
                style: TextStyle(color: Colors.red),
              ),
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: passcodeController,
                  decoration: const InputDecoration(
                      hintText: 'Enter 6 digits numbers here'),
                ),
                TextField(
                  controller: confirmPasscodeController,
                  decoration:
                      const InputDecoration(hintText: 'Confirm passcode'),
                ),
              ],
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
                  ref
                      .read(clipBoardProvider)
                      .setPasscode(passcodeController.text.toString());
                  storedPasscode = ref.watch(clipBoardProvider).passw;
                  Navigator.pop(context);
                },
                child: const Text('Set'),
              ),
            ],
          ),
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
          title: const Text('copyPast'),
          content: const Text('Do you want to remove the passcode ?'),
          actions: [
            TextButton(
                onPressed: () {
                  ref.read(clipBoardProvider).removePasscode();
                  Navigator.of(context).pop();
                },
                child: const Text('Ok')),
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
            title: const Text('Shop'),
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
            leading: const Icon(Icons.edit),
            title: const Text('Manage products'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
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
            title: const Text('Add passcode'),
          ),
        ],
      ),
    );
  }
}
