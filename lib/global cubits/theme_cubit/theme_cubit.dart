import 'package:bloc/bloc.dart';


import 'package:flutter/material.dart';




import 'package:seen/themes/switch_mode.dart';


import 'package:shared_preferences/shared_preferences.dart';


part 'theme_state.dart';


class ThemeCubit extends Cubit<ThemeState> {

  ThemeCubit() : super(ThemeInitial(initialTheme: ThemeClass.lightTheme));


  getSavedTheme() async {

    final prefs = await SharedPreferences.getInstance();


    final savedTheme = prefs.getString('theme');


    if (savedTheme == null) {

      emit(SavedTheme(savedTheme: 'light'));

    } else {
      if (savedTheme == 'light') {
        emit(ThemeInitial(initialTheme: ThemeClass.lightTheme));
      } else {
        emit(ThemeInitial(initialTheme: ThemeClass.darkTheme));
      }

    }

  }


  void changeTheme(String theme) async {

    final prefs = await SharedPreferences.getInstance();


    if (theme == 'light') {

      await prefs.setString('theme', theme);


      emit(ThemeInitial(initialTheme: ThemeClass.lightTheme));

    } else {

      await prefs.setString('theme', theme);


      emit(ThemeInitial(initialTheme: ThemeClass.darkTheme));

    }

  }

}

