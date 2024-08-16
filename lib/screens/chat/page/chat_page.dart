import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screen_capture_event/screen_capture_event.dart';
import 'package:screenshot_callback/screenshot_callback.dart';
import 'package:seen/Services/local_storage.dart';
import 'package:seen/Services/push_notifcation_service.dart';
import 'package:seen/constanc.dart';
import 'package:seen/global%20cubits/get_chat_data_and_messages_cubit/get_chat_data_and_messages_cubit.dart';
import 'package:seen/global%20cubits/screen_actions_cubit/screen_actions_cubit.dart';
import 'package:seen/models/message_model.dart';
import 'package:seen/screens/chat/cubits/messages_control_cubit/messages_control_cubit.dart';
import 'package:seen/screens/chat/cubits/prevent_screen_shot_cubit/prevent_screen_shot_cubit.dart';
import 'package:seen/global%20widgets/divder_widget.dart';
import 'package:seen/screens/chat/widgets/message_bubble.dart';
import '../../../generated/l10n.dart';
import '../../home/cubit/get_chats_cubit/get_chats_cubit.dart';
import '../cubits/replay_messages_cubit/replay_messages_cubit.dart';
import '../cubits/send_message_cubit/send_message_cubit.dart';
import '../widgets/chat_app_bar_widget.dart';
import '../widgets/message_body_widget.dart';
import '../widgets/replay_message_widget.dart';
import '../widgets/text_field_tools.dart';

class ChatPage extends StatefulWidget {
  ChatPage({
    super.key,
    this.uid,
    this.fcToken,
  });

  static ScreenCaptureEvent screenListener = ScreenCaptureEvent();
  static String id = 'chat';

  String? uid;
  String? fcToken;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with AutomaticKeepAliveClientMixin {
  bool preventScreenshot = false;
  ScreenshotCallback screenshotCallback = ScreenshotCallback();
  String text = '';
  ScreenCaptureEvent screenListener = ScreenCaptureEvent();
  late Map<String, dynamic>? cachedUserData;
  late String chatId = '';

  @override
  void initState() {
    super.initState();

    screenListener.preventAndroidScreenShot(true);

    LocalStorage.getCachedUserData().then((value) {
      if (value != null) {
        cachedUserData = value;
      } else {
        print('error');
      }
    });
  }

  @override
  void dispose() {
    ChatPage.screenListener.dispose();
    screenshotCallback.dispose();
    super.dispose();
  }

  void sendPushNotifcation({required Message message}) {
    if (!message.isRead) {
      void pushNotifcation({required String messageContent}) {
        PushNotifcationService.sendNotifcationToSelectUser(
          deviceToken: widget.fcToken!,
          userName: cachedUserData!['username'],
          messageContent: messageContent,
          anotherUserId: widget.uid!,
        );
      }

      try {
        if (message.rplay != null) {
          if (message.messageType == MessageType.Text) {
            pushNotifcation(
                messageContent:
                    "${S.of(context).replyedSuccess} : ${message.content}");
          } else if (message.messageType == MessageType.Image) {
            pushNotifcation(messageContent: S.of(context).replyedImage);
          } else if (message.messageType == MessageType.Voice) {
            pushNotifcation(messageContent: S.of(context).replyedVoic);
          }
        } else if (message.messageType == MessageType.Text) {
          pushNotifcation(messageContent: message.content!);
        } else if (message.messageType == MessageType.Voice) {
          pushNotifcation(messageContent: S.of(context).sendingVoice);
        } else if (message.messageType == MessageType.Image) {
          pushNotifcation(messageContent: S.of(context).sendingImage);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider(
      create: (context) =>
          GetChatDataAndMessagesCubit()..getChatId(anotheUserUid: widget.uid!),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return BlocListener<PreventScreenShotCubit, PreventScreenShotState>(
            listener: (context, state) {
              if (state is PreventScreenShot) {
                print('PreventScreenShot');
                screenListener.preventAndroidScreenShot(true);
              } else if (state is UnPreventScreenShot) {
                print('UnPreventScreenShot');
                screenListener.preventAndroidScreenShot(false);
              } else if (state is AnotherUserUnPreventScreenShot) {
                screenListener.preventAndroidScreenShot(true);
              } else {
                print('else ======');
                screenListener.preventAndroidScreenShot(false);
              }
            },
            child: Scaffold(
              appBar: ChatAppBarWidget(userId: widget.uid!),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(text),
                  BlocBuilder<GetChatDataAndMessagesCubit,
                      GetChatDataAndMessagesState>(
                    builder: (context, state) {
                      if (state is GetChatIdSuccess) {
                        return MessageBodyWidget(
                          anotherUserId: widget.uid!,
                          chatId: state.chatId,
                        );
                      } else {
                        return Text(S.of(context).noMessages);
                      }
                    },
                  ),
                  const DivderWidget(),
                  const ReplayMessageWidget(),
                  BlocProvider(
                    create: (context) => MessagesControlCubit(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BlocConsumer<SendMessageCubit, SendMessageState>(
                            listener: (context, messageState) {
                              if (messageState is SendMessageSuccess) {
                                if (messageState.message.messageType ==
                                    MessageType.Image) {
                                } else if (messageState.message.rplay != null) {
                                  BlocProvider.of<ReplayMessagesCubit>(context)
                                      .deleteReplayWidget();
                                }
                                sendPushNotifcation(
                                    message: messageState.message);
                              }
                            },
                            builder: (context, state) {
                              if (state is SendMessageLoading) {
                                return Row(
                                  children: [
                                    FittedBox(
                                      child: Column(
                                        children: [
                                          MessageBubble(
                                            isLoading: true,
                                            message: state.message,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Column(
                                        children: [
                                          const CircularProgressIndicator(
                                              strokeWidth: .5),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: FittedBox(
                                              child: Text(
                                                S.of(context).loading,
                                                style: const TextStyle(
                                                    fontSize: 10),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              } else if (state is SendMessageFailure) {
                                return Container(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width - 100,
                                  ),
                                  child: FittedBox(
                                    child: Row(
                                      children: [
                                        FittedBox(
                                          child: MessageBubble(
                                            isLoading: true,
                                            message: state.message!,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Column(
                                            children: [
                                              ElevatedButton.icon(
                                                label: Text(S
                                                    .of(context)
                                                    .trySendingAgain),
                                                onPressed: () {
                                                  BlocProvider.of<
                                                              SendMessageCubit>(
                                                          context)
                                                      .sendMessage(
                                                    context: context,
                                                    replay: state
                                                        .message!.rplay!.first,
                                                    messageContent:
                                                        state.message!.content!,
                                                    secondUserUid: widget.uid!,
                                                    isOrignalMessage: true,
                                                    isImageMessage: state
                                                            .message!
                                                            .messageType ==
                                                        MessageType.Image,
                                                    isReplayMessage: state
                                                        .message!
                                                        .rplay!
                                                        .isNotEmpty,
                                                    isVoiceMessage: state
                                                            .message!
                                                            .messageType ==
                                                        MessageType.Voice,
                                                  );
                                                },
                                                icon: const Icon(Icons
                                                    .send_and_archive_rounded),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5),
                                                child: FittedBox(
                                                  child: Text(
                                                    S
                                                        .of(context)
                                                        .loadingFailure,
                                                    style: TextStyle(
                                                        color: Constanc
                                                            .kSecondColor,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  // ShowImageMessageWidget(anotherUserid: widget.uid!),
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
                              } else if (!snapshot.data!.data()!['block']) {
                                return TextFieldTools(
                                  userInChatUID: widget.uid,
                                  anotherUserFcToken: widget.fcToken,
                                );
                              } else {
                                return const FittedBox(
                                    child: Padding(
                                  padding: EdgeInsets.only(bottom: 20),
                                  child: Text(
                                      'لم يعد بالإمكان إرسال رسائل في هذه المحادثه'),
                                ));
                              }
                            });
                      } else {
                        return TextFieldTools(
                          userInChatUID: widget.uid,
                          anotherUserFcToken: widget.fcToken,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
