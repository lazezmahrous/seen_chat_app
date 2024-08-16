import 'package:flutter/material.dart';
import 'package:seen/screens/home/widgets/show_current_user_image.dart';
import 'package:seen/screens/User%20Profile/page/user_profile_page.dart';
import 'package:seen/screens/search/page/search_page.dart';
import 'package:seen/screens/settings_page.dart';
import 'package:seen/global%20widgets/icon_button_widget.dart';

class AppBarOfHomePageWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBarOfHomePageWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: SizedBox(
        width: 100,
        height: 100,
        child: Image.asset('assets/images/harfforlogin.png'),
      ),
      actions: [
        IconButtonWidget(
          onPressed: () {
            Navigator.pushNamed(context, Search.id);
          },
          icon: const Icon(Icons.search),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            children: [
              IconButtonWidget(
                onPressed: () {
                  Navigator.pushNamed(context, SettingPage.id);
                },
                icon: const Icon(Icons.settings),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserProfilePage(),
                    ),
                  );
                },
                icon: const ShowCurrentUserImage(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
