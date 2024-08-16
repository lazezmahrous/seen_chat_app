import 'package:flutter/material.dart';
import 'package:seen/Services/firestore_services.dart';
import 'package:seen/models/user_model.dart' as model;
import 'package:seen/screens/home/widgets/show_another_user_info.dart';

import '../page/chat_page.dart';

class ShowUserDataWidget extends StatelessWidget {
  ShowUserDataWidget(
      {super.key, required this.userId, this.isChatPage = false});
  final String userId;
  bool? isChatPage;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<model.User>(
      future: FireStoreService.getUserDataWithUid(
        anotherUserUid: userId,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else if (snapshot.hasData) {
          return InkWell(
            onTap: () {
              if (isChatPage!) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      uid: snapshot.data!.uid,
                      fcToken: snapshot.data!.fcToken,
                    ),
                  ),
                );
              }
            },
            child: ShowAnotherUserInfo(
              user: snapshot.data!,
              showFinalMessage: isChatPage!,
            ),
          );
        } else {
          return const Text('خطأ غير متوقع');
        }
      },
    );
  }
}
