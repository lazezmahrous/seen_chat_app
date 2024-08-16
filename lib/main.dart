import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connection_notifier/connection_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:seen/constanc.dart';
import 'package:seen/global%20cubits/network_conectivty_cubit/network_conectivty_cubit.dart';
import 'package:seen/screens/chat/cubits/prevent_screen_shot_cubit/prevent_screen_shot_cubit.dart';
import 'package:seen/screens/login/cubits/login_cubit/login_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:seen/services/firestore_services.dart';
import 'package:seen/services/notifcations_service.dart';
import 'package:seen/global%20cubits/auth_cubit/auth_cubit.dart';
import 'package:seen/screens/signup/cubits/get_image_cubit/get_image_cubit.dart';
import 'package:seen/global%20cubits/get_users_info_cubit/get_users_info_cubit.dart';
import 'package:seen/global%20cubits/language_cubit/language_cubit.dart';
import 'package:seen/global%20cubits/screen_actions_cubit/screen_actions_cubit.dart';
import 'package:seen/global%20cubits/theme_cubit/theme_cubit.dart';
import 'package:seen/firebase_options.dart';
import 'package:seen/generated/l10n.dart';
import 'package:seen/screens/user%20profile/cubit/user_profile_cubit.dart';
import 'package:seen/screens/splash.dart';
import 'package:seen/themes/switch_mode.dart';
import 'screens/home/cubit/get_chats_cubit/get_chats_cubit.dart';
import 'screens/chat/cubits/replay_messages_cubit/replay_messages_cubit.dart';
import 'screens/chat/cubits/send_message_cubit/send_message_cubit.dart';
import 'screens/chat/page/chat_page.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.initializeNotification();
  showAwesomeNotification(message);
}

void showAwesomeNotification(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  if (notification != null) {
    String? title = notification.title;
    String? body = notification.body;
    var random = Random();
    int id = random.nextInt(1000000); // يمكن تعديل الحد الأقصى حسب الحاجة
    try {
      if (title != null && body != null) {
        print(
            'message.anotherUserId! ================== : ${message.data['anotherFcToken'] != null}');
        print(
            'anotherFcToken ==================== : ${message.anotherFcToken != null}');
        await NotificationService.showScheduleNotification(
            chanelKay: 'user_notifications',
            title: notification.title!,
            body: notification.body!,
            scheduled: false,
            summary: 'You have new messages',
            id: id,
            payload: {
              "anotherUserId": message.data['anotherUserId'],
              "anotherFcToken": message.data['anotherFcToken'],
            });
      } else {
        print('Received a notification with null title or body.');
      }
    } catch (e) {
      print(e);
    }
  } else {
    print('Received a null notification.');
  }
}

Future<void> setupAwesomeNotifications() async {
  await NotificationService.initializeNotification();

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

Future<void> cacheUserData() async {
  try {
    print(FirebaseAuth.instance.currentUser!.uid);
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    Map<String, dynamic>? data = userData.data();
    if (data != null) {
      data.remove('password');

      // تحويل كل قيم الـ Timestamp إلى String
      data = data.map((key, value) {
        if (value is Timestamp) {
          return MapEntry(key, value.toDate().toIso8601String());
        } else {
          return MapEntry(key, value);
        }
      });

      String userDataJson = jsonEncode(data);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('cachedUserData', userDataJson);
    } else {
      print('No data found in the user document.');
    }
  } catch (e) {
    print('Error caching user data: $e');
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..backgroundColor = Colors.amber;

  // ..customAnimation = CustomAnimation();
}

bool connectivtiy = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await cacheUserData();
  await setupAwesomeNotifications();
  await initializeDateFormatting('ar'); // تهيئة صيغة التاريخ باللغة العربية
  await FireStoreService.setOnLineAndNewSeen();
  EasyLoading.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>(); // تعريف الـ navigatorKey هنا

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() { 
    super.initState();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        MyApp.navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => ChatPage(
              uid: message.data['anotherUserId'] ?? '',
              fcToken: message.data['anotherFcToken'] ?? '',
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessage.listen(showAwesomeNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      MyApp.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => ChatPage(
            uid: message.data['anotherUserId'] ?? '',
            fcToken: message.data['anotherFcToken'] ?? '',
          ),
        ),
      );
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      await FireStoreService.setOfLineAndLastSeen();
    } else if (state == AppLifecycleState.resumed) {
      await FireStoreService.setOnLineAndNewSeen();
    }
  }

  @override
  void dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LanguageCubit()..getSavedLanguage(),
        ),
        BlocProvider(
          create: (context) => ThemeCubit()..getSavedTheme(),
        ),
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => GetUsersInfoCubit(),
        ),
        BlocProvider(
          create: (context) => ScreenActionsCubit(),
        ),
        BlocProvider(
          create: (context) => ReplayMessagesCubit(),
        ),
        BlocProvider(
          create: (context) => SendMessageCubit(),
        ),
        BlocProvider(
          create: (context) => GetImageCubit(),
        ),
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => PreventScreenShotCubit(),
        ),
        BlocProvider(
          create: (context) => UserProfileCubit()..getData(),
        ),
        BlocProvider(
          create: (context) => GetChatsCubit()..fetchUserChats(),
        ),
        BlocProvider(
          create: (context) => NetworkConectivtyCubit(),
        ),
      ],
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, languageState) {
          if (languageState is LanguageSaved) {
            return buildMaterialApp(context, languageState.locale!);
          } else {
            return buildMaterialApp(context, const Locale('en'));
          }
        },
      ),
    );
  }

  Widget buildMaterialApp(BuildContext context, Locale locale) {
    return ConnectionNotifier(
      locale: const Locale('ar'),
      child: MaterialApp(
        navigatorKey: MyApp.navigatorKey, // تعيين الـ navigatorKey هنا
        builder: EasyLoading.init(),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        locale: locale,
        title: 'س',
        theme: ThemeClass.lightTheme,
        home: const Splash(),
        initialRoute: Splash.id,
        routes: Constanc.routes,
      ),
    );
  }
}
