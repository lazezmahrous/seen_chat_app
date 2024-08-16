import 'package:bloc/bloc.dart';


import 'package:flutter/material.dart';




import 'package:shared_preferences/shared_preferences.dart';


part 'language_state.dart';


enum Language {

  ar,


  en,

}


class LanguageCubit extends Cubit<LanguageState> {

  LanguageCubit() : super(LanguageInitial());


  Future<String> getSavedLanguage() async {

    final prefs = await SharedPreferences.getInstance();


    final savedLanguage = prefs.getString('language');


    if (savedLanguage == null) {

      await prefs.setString('language', 'en');


      return prefs.getString('language').toString();

    } else {

      if (savedLanguage == 'en') {

        emit(LanguageSaved(const Locale('en')));


        return savedLanguage;

      } else {

        emit(LanguageSaved(const Locale('ar')));

        return savedLanguage;

      }

    }

  }


  void changeLanguage(String language) async {

    final prefs = await SharedPreferences.getInstance();


    await prefs.setString('language', language);


    final savedLanguage = prefs.getString('language');


    emit(LanguageSaved(Locale(savedLanguage!)));

  }

}

