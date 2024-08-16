import 'package:flutter/material.dart';

import '../../../global widgets/icon_button_widget.dart';
import '../page/chat_settings_page.dart';
import 'show_another_user_info_widget.dart';

class ChatAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  ChatAppBarWidget({super.key, required this.userId});
  String? userId;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 250,
      // title: Text('text : $text'),
      leading: Container(
        constraints: const BoxConstraints(
          maxWidth: 250,
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
            ShowUserDataWidget(
              userId: userId!,
              isChatPage: false,
            ),
          ],
        ),
      ),
      actions: [
        IconButtonWidget(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatSettingsPage(
                      userInChatId: userId!,
                    ),
                  ));
            }),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
