import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seen/services/create_popup_menu.dart';
import 'package:seen/services/local_storage.dart';
import 'package:seen/services/translate_services.dart';
import 'package:seen/constanc.dart';
import 'package:seen/screens/chat/cubits/prevent_screen_shot_cubit/prevent_screen_shot_cubit.dart';
import 'package:seen/global%20widgets/card_widget.dart';
import 'package:seen/global%20widgets/kbutton.dart';

import '../../../global cubits/get_chat_data_and_messages_cubit/get_chat_data_and_messages_cubit.dart';
import '../../../generated/l10n.dart';

class ChatSettingsPage extends StatefulWidget {
  const ChatSettingsPage({super.key, required this.userInChatId});

  static String id = 'chatSettingsPage';
  final String userInChatId;
  @override
  State<ChatSettingsPage> createState() => _ChatSettingsPageState();
}

class _ChatSettingsPageState extends State<ChatSettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetChatDataAndMessagesCubit()
        ..getChatId(anotheUserUid: widget.userInChatId),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(S.of(context).chatSettings),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Card(
                //   child: Padding(
                //     padding:
                //         const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.stretch,
                //       children: [
                //         Text(S.of(context).preventScreenShot),
                //         ScreenShotStatusStream(
                //           chatId: widget.chatId,
                //           userInChatId: widget.userInChatId,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
            FittedBox(
              child: CardWidget(
                text: S.of(context).harfOfEncryption,
                child: PopupMenuButton(
                  icon: const Icon(Icons.arrow_drop_down),
                  onSelected: (newValue) async {
                    await LocalStorage.setHarfOfTranslate(harf: newValue);
                  },
                  itemBuilder: (context) => createPopupMenu(
                    list: Translate.arabicLetters,
                  ).toList(),
                ),
              ),
            ),
            BlocBuilder<GetChatDataAndMessagesCubit,
                GetChatDataAndMessagesState>(
              builder: (context, state) {
                if (state is GetChatIdSuccess) {
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('chats')
                        .doc(state.chatId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.data!.data()!['block']) {
                        return Kbutton(
                          text: 'إلغاء الحظر',
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('chats')
                                .doc(state.chatId)
                                .update({
                              "block": false,
                            });
                          },
                        );
                      } else if (!snapshot.data!.data()!['block']) {
                        return Kbutton(
                          text: 'حظر',
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('chats')
                                .doc(state.chatId)
                                .update({
                              "block": true,
                            });
                          },
                        );
                      } else {
                        return Text(S.of(context).erordata);
                      }
                    },
                  );
                } else {
                  return const Text('خطأ');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ScreenShotStatusStream extends StatefulWidget {
  final String chatId;
  final String userInChatId;

  const ScreenShotStatusStream({
    super.key,
    required this.chatId,
    required this.userInChatId,
  });

  @override
  State<ScreenShotStatusStream> createState() => _ScreenShotStatusStreamState();
}

class _ScreenShotStatusStreamState extends State<ScreenShotStatusStream> {
  @override
  Widget build(BuildContext context) {
    print('chat id ============= ${widget.chatId}');

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const CircularProgressIndicator();
        }
        print(snapshot.data!['preventAndroidScreenShot']);
        var data = snapshot.data!.data() as Map<String, dynamic>?;
        List<String> preventAndroidScreenShot =
            List<String>.from(data!['preventAndroidScreenShot']);
        String currentUserId = FirebaseAuth.instance.currentUser!.uid;
        bool currentUserPrevents =
            preventAndroidScreenShot.contains(currentUserId);
        bool otherUserPrevents =
            preventAndroidScreenShot.contains(widget.userInChatId);

        return ElevatedButton(
            onPressed: () async {
              await BlocProvider.of<PreventScreenShotCubit>(context)
                  .preventScreenShot(anotherUserId: widget.userInChatId);
            },
            child: const Text('llll'));
        // } else if (otherUserPrevents) {
        //   return ScreenShotStatusRow(
        //     message1: S.of(context).hePreventScreenShot,
        //     buttonText: S.of(context).on,
        //     onPressed: () async {
        //       await BlocProvider.of<PreventScreenShotCubit>(context)
        //           .preventScreenShot(anotherUserId: widget.userInChatId);
        //     },
        //   );
        // } else if (otherUserPrevents && currentUserPrevents) {
        //   return ScreenShotStatusRow(
        //     message1: S.of(context).youPreventScreenShot,
        //     message2: S.of(context).hePreventScreenShot,
        //     buttonText: S.of(context).off,
        //     onPressed: () async {
        //       await BlocProvider.of<PreventScreenShotCubit>(context)
        //           .preventScreenShot(anotherUserId: widget.userInChatId);
        //     },
        //   );
        // } else {
        //   return TextButton(
        //     onPressed: () async {
        //       await BlocProvider.of<PreventScreenShotCubit>(context)
        //           .preventScreenShot(anotherUserId: widget.userInChatId);
        //     },
        //     child: Text(
        //       S.of(context).on,
        //       style: TextStyle(color: Constanc.kOrignalColor),
        //     ),
        //   );
        // }
      },
    );
  }
}

class ScreenShotStatus extends StatefulWidget {
  final List<String> preventAndroidScreenShot;
  final String userInChatId;

  const ScreenShotStatus({
    super.key,
    required this.preventAndroidScreenShot,
    required this.userInChatId,
  });

  @override
  State<ScreenShotStatus> createState() => _ScreenShotStatusState();
}

class _ScreenShotStatusState extends State<ScreenShotStatus> {
  @override
  Widget build(BuildContext context) {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    bool currentUserPrevents =
        widget.preventAndroidScreenShot.contains(currentUserId);
    bool otherUserPrevents =
        widget.preventAndroidScreenShot.contains(widget.userInChatId);

    if (currentUserPrevents && otherUserPrevents) {
      return ScreenShotStatusRow(
        message1: S.of(context).youPreventScreenShot,
        message2: S.of(context).hePreventScreenShot,
        buttonText: S.of(context).off,
        onPressed: () async {
          await BlocProvider.of<PreventScreenShotCubit>(context)
              .preventScreenShot(anotherUserId: widget.userInChatId);
        },
      );
    } else if (currentUserPrevents) {
      return ScreenShotStatusRow(
        message1: S.of(context).youPreventScreenShot,
        buttonText: S.of(context).off,
        onPressed: () async {
          await BlocProvider.of<PreventScreenShotCubit>(context)
              .preventScreenShot(anotherUserId: widget.userInChatId);
        },
      );
    } else if (otherUserPrevents) {
      return ScreenShotStatusRow(
        message1: S.of(context).hePreventScreenShot,
        buttonText: S.of(context).on,
        onPressed: () async {
          await BlocProvider.of<PreventScreenShotCubit>(context)
              .preventScreenShot(anotherUserId: widget.userInChatId);
        },
      );
    } else {
      return TextButton(
        onPressed: () async {
          await BlocProvider.of<PreventScreenShotCubit>(context)
              .preventScreenShot(anotherUserId: widget.userInChatId);
        },
        child: Text(
          S.of(context).on,
          style: TextStyle(color: Constanc.kOrignalColor),
        ),
      );
    }
  }
}

class ScreenShotStatusRow extends StatelessWidget {
  final String message1;
  final String? message2;
  final String buttonText;
  final Future<void> Function() onPressed;

  const ScreenShotStatusRow({
    super.key,
    required this.message1,
    this.message2,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message1),
              if (message2 != null) Text(message2!),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () async {
                await onPressed();
              },
              child: Text(
                buttonText,
                style: TextStyle(color: Constanc.kOrignalColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
