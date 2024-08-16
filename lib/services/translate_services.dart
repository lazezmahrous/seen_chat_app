import 'dart:convert';

import 'package:characters/characters.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:seen/Services/local_storage.dart';
import '../models/message_model.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis/speech/v1.dart' as speech;

class Translate {
  static bool _isEmoji(String text) {
    return RegExp(
            r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')
        .hasMatch(text);
  }

  static bool _isNumber(String text) {
    return RegExp(r'[0-9\u0660-\u0669]').hasMatch(text);
  }

  static String punctuation = r"[!\" "#\$%&'()*+,-.:;<=>?@[\\]^_`{|}~]";
  static bool _containsPunctuation(String text) {
    return RegExp(punctuation).hasMatch(text);
  }

  static Map<String, List<String>> letters = {
    "أ": [
      'أرنب',
      'أسد',
      'أمير',
      'أبواب',
      // يمكنك إضافة المزيد من الكلمات التي تبدأ بحرف الألف هنا
    ],
    "ا": [
      'ارنب',
      'اسد',
      'امير',
      'ابواب',
      // يمكنك إضافة المزيد من الكلمات التي تبدأ بحرف الألف هنا
    ],
    "إ": [
      'إسمع',
      'إرجع',
      'إزيك',
    ],
    "ب": [
      'بيت',
      'باب',
      'بحر',
      'بائع',
      // يمكنك إضافة المزيد من الكلمات التي تبدأ بحرف ب هنا
    ],
    "ت": [
      'تفاحة',
      'تمر',
      'تكنولوجيا',
      'تاريخ',
      // يمكنك إضافة المزيد من الكلمات التي تبدأ بحرف ت هنا
    ],
    "ث": [
      'ثعلب',
      'ثلج',
      'ثروة',
      'ثقافة',
      // يمكنك إضافة المزيد من الكلمات التي تبدأ بحرف ث هنا
    ],
    "ج": [
      'جمل',
      'جريدة',
      'جواب',
      'جدول',
      // يمكنك إضافة المزيد من الكلمات التي تبدأ بحرف ج هنا
    ],
    "ح": [
      'حصان',
      'حجر',
      'حكم',
      'حديقة',
      // يمكنك إضافة المزيد من الكلمات التي تبدأ بحرف ح هنا
    ],
    "خ": [
      'خير',
      'خريف',
      'خبز',
      'خيمة',
      // يمكنك إضافة المزيد من الكلمات التي تبدأ بحرف خ هنا
    ],
    "د": [
      'دراسة',
      'دمية',
      'دولة',
      'دنيا',
      // يمكنك إضافة المزيد من الكلمات التي تبدأ بحرف د هنا
    ],
    "ذ": [
      'ذهب',
      'ذيل',
      'ذاكرة',
      'ذكاء',
      // يمكنك إضافة المزيد من الكلمات التي تبدأ بحرف ذ هنا
    ],
    "ر": [
      'ربيع',
      'رؤية',
      'رسالة',
      'رياضة',
      // يمكنك إضافة المزيد من الكلمات التي تبدأ بحرف ر هنا
    ],
    "ز": [
      'زرافة',
      'زوج',
      'زمن',
      'زهرة',
      // يمكنك إضافة المزيد من الكلمات التي تبدأ بحرف ز هنا
    ],
    "س": [
      'سمك',
      'ساعة',
      'سيارة',
      'سماء',
      // يمكنك إضافة المزيد من الكلمات التي تبدأ بحرف س هنا
    ],
    "ش": [
      'شمس',
      'شجرة',
      'شريط',
      'شعر',
      // يمكنك إضافة المزيد من الكلمات التي تبدأ بحرف ش هنا
    ],
    "ص": [
      'صباح',
      'صحراء',
      'صندوق',
      'صديق',
      // يمكنك إضافة المزيد من الكلمات التي تبدأ بحرف ص هنا
    ],
    "ض": [
      'ضفدع',
      'ضوء',
      'ضمير',
      'ضربة',
      // يمكنك إضافة المزيد من الكلمات التي تبدأ بحرف ض هنا
    ],
    "ط": [
      'طائر',
      'طبيب',
      'طريق',
      'طعام',
      // يمكنك إضافة المزيد من الكلمات التي تبدأ بحرف ط هنا
    ],
    "ظ": [
      'ظرف',
      'ظاهرة',
      'ظل',
      'ظلم',
      // يمكنك إضافة المزيد من الكلمات التي تبدأ بحرف ظ هنا
    ],
    "ع": [
      'علم',
      'عمر',
      'عيد',
      'عشاء',
      // يمكنك إضافة المزيد من الكلمات التي تبدأ بحرف ع هنا
    ],
    "غ": [
      'غابة',
      'غرفة',
      'غيمة',
      'غذاء',
      // يمكنك إضافة المزيد من الكلمات التي تبدأ بحرف غ هنا
    ],
    "ف": [
      'فراشة',
      'فكرة',
      'فاكهة',
      'فنان',
      // يمكنك إضافة المزيد من الكلمات التي تبدأ بحرف ف هنا
    ],
    "ق": [
      'قلب',
      'قمر',
      'قراءة',
      'قائمة',
      // يمكنك إضافة المزيد من الكلمات التي تبدأ بحرف ق هنا
    ],
    "ك": [
      'كتاب',
      'كرة',
      'كلمة',
      'كافيه',
      // يمكنك إضافة المزيد من الكلمات التي تبدأ بحرف ك هنا
    ],
    "ل": [
      'لوحة',
      'ليل',
      'لغة',
      'ليمون',
      // يمكنك إضافة المزيد من الكلمات التي تبدأ بحرف ل هنا
    ],
    "م": [
      'مدرسة',
      'مسجد',
      'مكتب',
      'ماء',
      // يمكنك إضافة المزيد من الكلمات التي تبدأ بحرف م هنا
    ],
    "ن": [
      'نهر',
      'نجم',
      'ناس',
      'نوم',
      // يمكنك إضافة المزيد من الكلمات التي تبدأ بحرف ن هنا
    ],
    "ه": [
      'هدف',
      'هواء',
      'هاتف',
      'هلال',
      // يمكنك إضافة المزيد من الكلمات التي تبدأ بحرف ه هنا
    ],
    "و": [
      'ورد',
      'وظيفة',
      'وطن',
      'وقت',
      // يمكنك إضافة المزيد من الكلمات التي تبدأ بحرف و هنا
    ],
    "ي": [
      'ياورد',
      'يعمل',
      'يقول',
      'يشرب',
    ],
  };

  static List<String> arabicLetters = [
    'ا',
    'أ',
    'إ',
    'آ',
    'ب',
    'ت',
    'ث',
    'ج',
    'ح',
    'خ',
    'د',
    'ذ',
    'ر',
    'ز',
    'س',
    'ش',
    'ص',
    'ض',
    'ط',
    'ظ',
    'ع',
    'غ',
    'ف',
    'ق',
    'ك',
    'ل',
    'م',
    'ن',
    'ه',
    'و',
    'ي',
    'ئ',
    'ؤ',
    'ى',
    'ة',
    'ء',
    'ٱ',
    'ٳ',
    'ٶ',
    'ہ',
    'ۃ',
    'ۈ',
    'ۉ',
    'ۊ',
    'ۋ',
    'ی',
    'ۑ',
    'ە',
  ];

  static Future<String> toSekkymallawany({required String message}) async {
    if (message.length <= 800) {
      List<String> messageAsList = message.split(' ');
      print(messageAsList);
      List<String> modifiedWords = [];
      String? harfOfTranslate = await LocalStorage.getHarfOfTranslate();
      for (int i = 0; i < messageAsList.length; i++) {
        String element = messageAsList[i];
        if (element.isNotEmpty &&
            !_isEmoji(element) &&
            !_isNumber(element) &&
            !_containsPunctuation(element)) {
          // يطبق الشرط على الكلمة الزوجية
          String replacedLetter = element.substring(0, 1);

          // تحقق مما إذا كانت الحرف المستبدل يبدأ بحرف عربي
          for (var arabicLetter in arabicLetters) {
            if (replacedLetter.startsWith(arabicLetter)) {
              List<String> wordsOfLetter = letters[arabicLetter]!;
              wordsOfLetter.shuffle();
              replacedLetter = letters[arabicLetter]!.first;
              break;
            }
          }

          element = element.replaceRange(0, 1, harfOfTranslate);
          modifiedWords.add('$element $replacedLetter');
        } else {
          // إذا كان العنصر يحتوي على إيموجي أو رقم، أضفه بدون تعديل
          modifiedWords.add(element);
        }
      }

      String modifiedSentence = modifiedWords.join(' ');

      return modifiedSentence;
    } else {
      return message;
    }
  }

  static String fromSekkymallawany({required Message message}) {
    List<String> messageAsList =
        message.content!.split(' ').map((e) => e.toString()).toList();

    List<String> modifiedWords = [];

    for (int i = 0; i < messageAsList.length; i += 2) {
      String firstWord = messageAsList[i];
      String secondWord =
          (i + 1 < messageAsList.length) ? messageAsList[i + 1] : '';

      if (_isEmoji(firstWord) ||
          _isNumber(firstWord) ||
          _containsPunctuation(message.content!)) {
        modifiedWords.add(firstWord);
        if (secondWord.isNotEmpty) {
          modifiedWords.add(secondWord);
        }
      } else {
        if (secondWord.isNotEmpty) {
          String replacedLetter = secondWord.characters.first.toString();
          String firstWordOrignal =
              firstWord.replaceRange(0, 1, replacedLetter);
          modifiedWords.add(firstWordOrignal);
        }
      }
    }

    String modifiedSentence = modifiedWords.join(' ');
    return modifiedSentence;
  }

  static Future<String> transcribeAudio(String audioUrl) async {
    final accountCredentials = ServiceAccountCredentials.fromJson(
        json.decode(await rootBundle.loadString('service_account.json')));
    final scopes = [speech.SpeechApi.cloudPlatformScope];

    final client = await clientViaServiceAccount(accountCredentials, scopes);
    final speechApi = speech.SpeechApi(client);

    final recognitionConfig = speech.RecognitionConfig(
      encoding: 'LINEAR16',
      sampleRateHertz: 16000,
      languageCode: 'ar-AR',
    );

    final recognitionAudio = speech.RecognitionAudio(uri: audioUrl);

    final request = speech.RecognizeRequest(
      config: recognitionConfig,
      audio: recognitionAudio,
    );

    final response = await speechApi.speech.recognize(request);

    client.close();

    return response.results!
        .map((result) => result.alternatives!.first.transcript)
        .join('\n');
  }
}
