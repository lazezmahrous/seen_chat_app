import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:seen/screens/home/page/home.dart';
import 'package:seen/screens/signup/pages/signup.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seen/screens/login/cubits/login_cubit/login_cubit.dart';
import 'package:seen/screens/chat/page/chat_settings_page.dart';
import 'package:seen/screens/gallery_page.dart';
import 'package:seen/screens/login/page/login.dart';
import 'package:seen/screens/search/page/search_page.dart';
import 'package:seen/screens/settings_page.dart';
import 'package:seen/screens/splash.dart';
import 'package:seen/screens/welcome_page.dart';
import 'screens/user profile/page/user_profile_page.dart';
import 'screens/chat/page/chat_page.dart';

class Constanc {
  Constanc._();
  // static User? currentUser = FirebaseAuth.instance.currentUser;
  static Color kOrignalColor = HexColor('#3c00ff');
  static Color kSecondColor = HexColor('#c414e9');
  static Color kColorWhite = HexColor('#ffffff');
  static Color kColorGray = HexColor('#f2f2f2');
  static Color kColorblack = HexColor('#000000');
  static const String knoteBox = 'notes';
  static const String iconsPath = 'assets/icons/';
  static const String audioPath = 'assets/audio/';
  static const String imagesPath = 'assets/images/';
  static const String stickersPath = 'assets/stickers/';
  static  Map<String, Widget Function(BuildContext)> routes = {
    Home.id: (context) => const Home(),
    Signup.id: (context) => Signup(),
    Login.id: (context) => BlocProvider(
          create: (context) => LoginCubit(),
          child: const Login(),
        ),
    Splash.id: (context) => const Splash(),
    Search.id: (context) => const Search(),
    ChatPage.id: (context) => ChatPage(),
    GalleryPage.id: (context) => GalleryPage(),
    SettingPage.id: (context) => const SettingPage(),
    WelcomePage.id: (context) => const WelcomePage(),
    UserProfilePage.id: (context) => const UserProfilePage(),
    ChatSettingsPage.id: (context) => const ChatSettingsPage(
          userInChatId: '',
        ),
  };
  static const keyString =
      'qwertyuiopslkjhgfdsazxcvbnmnbvcx'; // يجب أن يكون طول المفتاح 32 بايت
  static const ivString = 'qwertyuiopasdfgh'; // يجب أن يكون طول IV 16 بايت

  static Future getChatWherUserIn({required String secondUserUid}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> chatCollection =
          await FirebaseFirestore.instance
              .collection('chats')
              .where('id', whereIn: [
        '$secondUserUid ${FirebaseAuth.instance.currentUser!.uid}',
        '${FirebaseAuth.instance.currentUser!.uid} $secondUserUid'
      ]).get();

      return chatCollection;
    } catch (e) {
      return e.toString();
    }
  }
}
