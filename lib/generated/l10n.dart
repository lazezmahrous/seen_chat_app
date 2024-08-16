// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `en`
  String get language_code {
    return Intl.message(
      'en',
      name: 'language_code',
      desc: '',
      args: [],
    );
  }

  /// `sean`
  String get appName {
    return Intl.message(
      'sean',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Field is required`
  String get erordata {
    return Intl.message(
      'Field is required',
      name: 'erordata',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get setting {
    return Intl.message(
      'Setting',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get arLanguage {
    return Intl.message(
      'Arabic',
      name: 'arLanguage',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get enLanguage {
    return Intl.message(
      'English',
      name: 'enLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `Dark Theme`
  String get darkTheme {
    return Intl.message(
      'Dark Theme',
      name: 'darkTheme',
      desc: '',
      args: [],
    );
  }

  /// `Light Theme`
  String get lightTheme {
    return Intl.message(
      'Light Theme',
      name: 'lightTheme',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Enter`
  String get welcomePageButton {
    return Intl.message(
      'Enter',
      name: 'welcomePageButton',
      desc: '',
      args: [],
    );
  }

  /// `Sello Hearing`
  String get welcome {
    return Intl.message(
      'Sello Hearing',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Of course, the sentence above means welcome, but as for 'Hearing', it is a word that starts with the letter that the word 'Hello' starts with. So we removed the letter H and replaced it with S and brought a word that starts with the letter we removed, which is H. So the word will be Hello, and this is the encryption idea on which the application is based.`
  String get welcomePageDescription {
    return Intl.message(
      'Of course, the sentence above means welcome, but as for \'Hearing\', it is a word that starts with the letter that the word \'Hello\' starts with. So we removed the letter H and replaced it with S and brought a word that starts with the letter we removed, which is H. So the word will be Hello, and this is the encryption idea on which the application is based.',
      name: 'welcomePageDescription',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginHeadText {
    return Intl.message(
      'Login',
      name: 'loginHeadText',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get loginEmail {
    return Intl.message(
      'Email',
      name: 'loginEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter the email correctly`
  String get loginEmailError {
    return Intl.message(
      'Enter the email correctly',
      name: 'loginEmailError',
      desc: '',
      args: [],
    );
  }

  /// `The email is already used`
  String get loginEmailIsUsedWithAnotherUser {
    return Intl.message(
      'The email is already used',
      name: 'loginEmailIsUsedWithAnotherUser',
      desc: '',
      args: [],
    );
  }

  /// `The user has not registered before`
  String get userNotFound {
    return Intl.message(
      'The user has not registered before',
      name: 'userNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get passwoard {
    return Intl.message(
      'Password',
      name: 'passwoard',
      desc: '',
      args: [],
    );
  }

  /// `Wrong password`
  String get wrongPassword {
    return Intl.message(
      'Wrong password',
      name: 'wrongPassword',
      desc: '',
      args: [],
    );
  }

  /// `Weak Password`
  String get weakPassword {
    return Intl.message(
      'Weak Password',
      name: 'weakPassword',
      desc: '',
      args: [],
    );
  }

  /// `Email Already In Use`
  String get emailAlreadyInUse {
    return Intl.message(
      'Email Already In Use',
      name: 'emailAlreadyInUse',
      desc: '',
      args: [],
    );
  }

  /// `Short name`
  String get wrongUserName {
    return Intl.message(
      'Short name',
      name: 'wrongUserName',
      desc: '',
      args: [],
    );
  }

  /// `Search For Users`
  String get searchForUsers {
    return Intl.message(
      'Search For Users',
      name: 'searchForUsers',
      desc: '',
      args: [],
    );
  }

  /// `The password does not match`
  String get passwoardNotMatch {
    return Intl.message(
      'The password does not match',
      name: 'passwoardNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Spaces are not allowed`
  String get spacesAreNotAllowed {
    return Intl.message(
      'Spaces are not allowed',
      name: 'spacesAreNotAllowed',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password`
  String get confirmPsswoard {
    return Intl.message(
      'Confirm password',
      name: 'confirmPsswoard',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect password`
  String get loginPasswoardError {
    return Intl.message(
      'Incorrect password',
      name: 'loginPasswoardError',
      desc: '',
      args: [],
    );
  }

  /// `Not registered with us before?`
  String get userNotLogin {
    return Intl.message(
      'Not registered with us before?',
      name: 'userNotLogin',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get sighnUpHeadText {
    return Intl.message(
      'Sign Up',
      name: 'sighnUpHeadText',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get sighnUpUserName {
    return Intl.message(
      'Username',
      name: 'sighnUpUserName',
      desc: '',
      args: [],
    );
  }

  /// `Creating an account ...`
  String get loadingSighnUser {
    return Intl.message(
      'Creating an account ...',
      name: 'loadingSighnUser',
      desc: '',
      args: [],
    );
  }

  /// `This field cannot be empty`
  String get fieldIsRequired {
    return Intl.message(
      'This field cannot be empty',
      name: 'fieldIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get userisLogin {
    return Intl.message(
      'Already have an account?',
      name: 'userisLogin',
      desc: '',
      args: [],
    );
  }

  /// `Wrong`
  String get wrong {
    return Intl.message(
      'Wrong',
      name: 'wrong',
      desc: '',
      args: [],
    );
  }

  /// `Chats Not Found`
  String get chatsNotFound {
    return Intl.message(
      'Chats Not Found',
      name: 'chatsNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Search for users to start fun conversations in the sughah lamp language`
  String get searchForNewUser {
    return Intl.message(
      'Search for users to start fun conversations in the sughah lamp language',
      name: 'searchForNewUser',
      desc: '',
      args: [],
    );
  }

  /// `Online`
  String get userIsOnline {
    return Intl.message(
      'Online',
      name: 'userIsOnline',
      desc: '',
      args: [],
    );
  }

  /// `Last seen from`
  String get lastSeenFrom {
    return Intl.message(
      'Last seen from',
      name: 'lastSeenFrom',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get to {
    return Intl.message(
      'To',
      name: 'to',
      desc: '',
      args: [],
    );
  }

  /// `Search by personal ID`
  String get searchKayWord {
    return Intl.message(
      'Search by personal ID',
      name: 'searchKayWord',
      desc: '',
      args: [],
    );
  }

  /// `No users found with this ID`
  String get noUserFound {
    return Intl.message(
      'No users found with this ID',
      name: 'noUserFound',
      desc: '',
      args: [],
    );
  }

  /// `Your personal ID`
  String get personalId {
    return Intl.message(
      'Your personal ID',
      name: 'personalId',
      desc: '',
      args: [],
    );
  }

  /// `New name`
  String get editUserNameText {
    return Intl.message(
      'New name',
      name: 'editUserNameText',
      desc: '',
      args: [],
    );
  }

  /// `Username is too short`
  String get userNameIsShort {
    return Intl.message(
      'Username is too short',
      name: 'userNameIsShort',
      desc: '',
      args: [],
    );
  }

  /// `Logout confirmation`
  String get logOutHeadText {
    return Intl.message(
      'Logout confirmation',
      name: 'logOutHeadText',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to log out?`
  String get areYouSureLogOut {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'areYouSureLogOut',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get logOut {
    return Intl.message(
      'Log out',
      name: 'logOut',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Copied successfully`
  String get copySuccess {
    return Intl.message(
      'Copied successfully',
      name: 'copySuccess',
      desc: '',
      args: [],
    );
  }

  /// `What do you want to send?`
  String get writeMessage {
    return Intl.message(
      'What do you want to send?',
      name: 'writeMessage',
      desc: '',
      args: [],
    );
  }

  /// `Reply`
  String get reply {
    return Intl.message(
      'Reply',
      name: 'reply',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get copy {
    return Intl.message(
      'Copy',
      name: 'copy',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Original`
  String get orignal {
    return Intl.message(
      'Original',
      name: 'orignal',
      desc: '',
      args: [],
    );
  }

  /// `Sent`
  String get messageSent {
    return Intl.message(
      'Sent',
      name: 'messageSent',
      desc: '',
      args: [],
    );
  }

  /// `Seen`
  String get messageSeen {
    return Intl.message(
      'Seen',
      name: 'messageSeen',
      desc: '',
      args: [],
    );
  }

  /// `You`
  String get You {
    return Intl.message(
      'You',
      name: 'You',
      desc: '',
      args: [],
    );
  }

  /// `He`
  String get he {
    return Intl.message(
      'He',
      name: 'he',
      desc: '',
      args: [],
    );
  }

  /// `Prevent screenshot of the conversation`
  String get preventScreenShot {
    return Intl.message(
      'Prevent screenshot of the conversation',
      name: 'preventScreenShot',
      desc: '',
      args: [],
    );
  }

  /// `Enable`
  String get on {
    return Intl.message(
      'Enable',
      name: 'on',
      desc: '',
      args: [],
    );
  }

  /// `Disable`
  String get off {
    return Intl.message(
      'Disable',
      name: 'off',
      desc: '',
      args: [],
    );
  }

  /// `You prevented screenshots of this chat`
  String get youPreventScreenShot {
    return Intl.message(
      'You prevented screenshots of this chat',
      name: 'youPreventScreenShot',
      desc: '',
      args: [],
    );
  }

  /// `He prevented screenshots of this chat`
  String get hePreventScreenShot {
    return Intl.message(
      'He prevented screenshots of this chat',
      name: 'hePreventScreenShot',
      desc: '',
      args: [],
    );
  }

  /// `The letter to be replaced in encryption`
  String get harfOfEncryption {
    return Intl.message(
      'The letter to be replaced in encryption',
      name: 'harfOfEncryption',
      desc: '',
      args: [],
    );
  }

  /// `Chat settings`
  String get chatSettings {
    return Intl.message(
      'Chat settings',
      name: 'chatSettings',
      desc: '',
      args: [],
    );
  }

  /// `Sending`
  String get loading {
    return Intl.message(
      'Sending',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Sending failed`
  String get loadingFailure {
    return Intl.message(
      'Sending failed',
      name: 'loadingFailure',
      desc: '',
      args: [],
    );
  }

  /// `Unexpected error`
  String get failure {
    return Intl.message(
      'Unexpected error',
      name: 'failure',
      desc: '',
      args: [],
    );
  }

  /// `Writing ...`
  String get writing {
    return Intl.message(
      'Writing ...',
      name: 'writing',
      desc: '',
      args: [],
    );
  }

  /// `No Messages Yet !`
  String get noMessages {
    return Intl.message(
      'No Messages Yet !',
      name: 'noMessages',
      desc: '',
      args: [],
    );
  }

  /// `Try again`
  String get trySendingAgain {
    return Intl.message(
      'Try again',
      name: 'trySendingAgain',
      desc: '',
      args: [],
    );
  }

  /// `Replied`
  String get replyedSuccess {
    return Intl.message(
      'Replied',
      name: 'replyedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Replied: Image`
  String get replyedImage {
    return Intl.message(
      'Replied: Image',
      name: 'replyedImage',
      desc: '',
      args: [],
    );
  }

  /// `Replied: Voice message`
  String get replyedVoic {
    return Intl.message(
      'Replied: Voice message',
      name: 'replyedVoic',
      desc: '',
      args: [],
    );
  }

  /// `Voice message sent`
  String get sendingVoice {
    return Intl.message(
      'Voice message sent',
      name: 'sendingVoice',
      desc: '',
      args: [],
    );
  }

  /// `Image sent`
  String get sendingImage {
    return Intl.message(
      'Image sent',
      name: 'sendingImage',
      desc: '',
      args: [],
    );
  }

  /// `Discovering`
  String get discovering {
    return Intl.message(
      'Discovering',
      name: 'discovering',
      desc: '',
      args: [],
    );
  }

  /// `Voice note`
  String get soundMessage {
    return Intl.message(
      'Voice note',
      name: 'soundMessage',
      desc: '',
      args: [],
    );
  }

  /// `block`
  String get block {
    return Intl.message(
      'block',
      name: 'block',
      desc: '',
      args: [],
    );
  }

  /// `Delete Message Failure`
  String get deleteMessageFailure {
    return Intl.message(
      'Delete Message Failure',
      name: 'deleteMessageFailure',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
