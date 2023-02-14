import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final changeLangauge = ChangeNotifierProvider.autoDispose((ref) {
  return ChangeLanguage();
});

class ChangeLanguage with ChangeNotifier {
  bool isEn = true;

  Map<String, Object> textsAr = {
    'english': 'إنجليزي',
    'arabic': 'عربي',
    'alert_copied_txt': 'هل فعلا تريد إدخال النص الذي تم نسخه ؟',
    'ok': 'حسنا',
    'add_other_txt': 'أضف نص اخر',
    'enter_txt': 'أدخل النص هنا',
    'cancel': 'إلغاء',
    'add': 'أضف',
    'authenticate': 'رمز الدخول',
    'enter_app_passcode': 'أدخل رمز الدخول هنا',
    'delete': 'حذف',
    'clipBoard_manager': 'قائمة النصوص',
    'delete_all_txt': 'هل فعلا تريد حذف كل النصوص ؟',
    'add_passcode': ' أضف رمز الدخول',
    'remove_passcode': 'حذف رمز الدخول',
    'save_passw_alert': 'يفضل حفظ رمز الدخول في مكان امن',
    'enter_digit_numb': 'أدخل 6 أرقام هنا',
    'gigit_numb_alert': 'رمز الدخول يجب أن يحتوي على 6 أرقام',
    'confirm_passcode': 'تأكيد رمز الدخول',
    'confirm_passcode_alert': 'رمز الدخول غير متوافق',
    'set': 'تأكيد',
    'remove_passcode_alert': 'هل فعلا تريد حذف رمز الدخول ؟',
    'home': 'الرئيسية',
    'list_password': 'قائمة كلمات السر',
    'language': 'اللغة',
    'dark_mode': 'تفعيل الوضع الداكن',
    'light_mode': 'إيقاف الوضع الداكن',
    'add_passw_alert': 'هل تريد إضافة النص إلى كلمات السر ؟',
    'other_passw': 'أضف نص اخر',
    'add_password': 'أضف كلمة السر',
    'passw_manager': 'قائمة كلمات السر',
    'delete_all_passw_alert': 'هل فعلا تريد حذف كل كلمات السر ؟',
    'enter_correct_passcode': 'أدخل رمز  الدخول',
    'incorrect_passcode': 'رمز الدخول خاطئ',
    'copied_txt': 'تم نسخ النص',
    'delete_txt': 'هل فعلا تريد حذف النص ؟',
    'security_txt': 'يرجى ادخال رمز الدخول الخاص بك'
  };
  Map<String, Object> textsEn = {
    'english': 'English',
    'arabic': 'Arabic',
    'alert_copied_txt':
        'Do you want to add copied text from system to the list ?',
    'ok': 'Ok',
    'add_other_txt': 'Add other text',
    'enter_txt': 'Enter text here',
    'cancel': 'Cancel',
    'add': 'Add',
    'authenticate': 'Authenticate',
    'enter_app_passcode': 'Enter App Passcode',
    'delete': 'Delete',
    'clipBoard_manager': 'ClipBoard manager',
    'delete_all_txt': 'Do you want to delete all texts ?',
    'add_passcode': 'Add passcode',
    'remove_passcode': 'Remove passcode',
    'save_passw_alert': 'Please save your passcode in safe place !',
    'enter_digit_numb': 'Enter 6 digits numbers here',
    'gigit_numb_alert': 'The passcode should contains 6 digit number',
    'confirm_passcode': 'Confirm passcode',
    'confirm_passcode_alert': 'The passcode confirmation does not match',
    'set': 'Set',
    'remove_passcode_alert': 'Do you want to remove the passcode ?',
    'home': 'Home',
    'list_password': 'Passwords list',
    'language': 'Language',
    'dark_mode': 'Enable dark mode',
    'light_mode': 'Desable dark mode',
    'add_passw_alert': 'Do you want to add password to the list ?',
    'other_passw': 'Add other password',
    'add_passwod': 'Add password',
    'passw_manager': 'Password manager',
    'delete_all_passw_alert': 'Do you want to delete all password ?',
    'enter_correct_passcode': 'Enter your passcode',
    'incorrect_passcode': 'Incorrect passcode',
    'copied_txt': 'Text copied to clipBoard',
    'delete_txt': 'Do you want to delete text ?',
    'security_txt': 'For your security please enter your passcode'
  };

  changeLan(bool lan) async {
    isEn = lan;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isEn', isEn);
    notifyListeners();
  }

  getLan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isEn = prefs.getBool('isEn') ?? true;
    notifyListeners();
  }

  Object? getTexts(String txt) {
    if (isEn == true) return textsEn[txt];
    return textsAr[txt];
  }
}
