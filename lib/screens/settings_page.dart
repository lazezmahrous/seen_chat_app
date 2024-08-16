import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seen/global%20cubits/language_cubit/language_cubit.dart';
import 'package:seen/global%20cubits/theme_cubit/theme_cubit.dart';
import 'package:seen/generated/l10n.dart';
import 'package:seen/screens/splash.dart';
import 'package:seen/global%20widgets/card_widget.dart';
import 'package:seen/global%20widgets/icon_button_widget.dart';


class SettingPage extends StatefulWidget {
  const SettingPage({super.key});
  static String id = 'settingPage';
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  void initState() {
    BlocProvider.of<ThemeCubit>(context).getSavedTheme();
    super.initState();
  }

  String? theme;

  @override
  Widget build(BuildContext context) {
    final changeLanguage = BlocProvider.of<LanguageCubit>(context);
    // final changeTheme = BlocProvider.of<ThemeCubit>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButtonWidget(
              icon: const Icon(Icons.logout),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext ctx) {
                    return AlertDialog(
                      title: const Text('تأكيد الخروج'),
                      content:
                          const Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
                      actions: [
                        TextButton(
                          child: const Text('إلغاء'),
                          onPressed: () {
                            Navigator.of(ctx).pop(); // غلق الحوار
                          },
                        ),
                        TextButton(
                            child: const Text('تسجيل الخروج'),
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.of(ctx).pop(); // غلق الحوار

                              Navigator.restorablePushNamedAndRemoveUntil(
                                context,
                                Splash.id,
                                (route) => false,
                              );
                            }),
                      ],
                    );
                  },
                );
              },
            ),
          ],
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          children: [
            // CardWidget(
            //   text: S.of(context).theme,
            //   child: PopupMenuButton(
            //     icon: const Icon(Icons.arrow_drop_down),
            //     onSelected: (newValue) {
            //       if (newValue == 0) {
            //         changeTheme.changeTheme('dark');
            //       } else {
            //         changeTheme.changeTheme('light');
            //       }
            //       setState(() {});
            //     },
            //     itemBuilder: (context) => [
            //       PopupMenuItem(
            //         value: 0,
            //         child: Text(S.of(context).darkTheme),
            //       ),
            //       PopupMenuItem(
            //         value: 1,
            //         child: Text(S.of(context).lightTheme),
            //       ),
            //     ],
            //   ),
            // ),
            CardWidget(
              text: S.of(context).language,
              child: PopupMenuButton(
                icon: const Icon(Icons.arrow_drop_down),
                onSelected: (newValue) {
                  if (newValue == 0) {
                    changeLanguage.changeLanguage('ar');
                  } else {
                    changeLanguage.changeLanguage('en');
                  }
                  setState(() {});
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 0,
                    child: Text(S.of(context).arLanguage),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: Text(S.of(context).enLanguage),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
