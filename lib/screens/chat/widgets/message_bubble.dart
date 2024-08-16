import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seen/services/translate_services.dart';
import 'package:seen/constanc.dart';
import 'package:seen/screens/chat/cubits/messages_control_cubit/messages_control_cubit.dart';
import 'package:seen/screens/chat/widgets/message_content.dart';
import 'package:seen/screens/chat/widgets/image_message_widget.dart';
import 'package:seen/global%20widgets/helpers/show_snack_bar.dart';
import 'package:seen/global%20widgets/loading_widget.dart';
import '../../../generated/l10n.dart';
import '../../../models/message_model.dart';
import '../cubits/replay_messages_cubit/replay_messages_cubit.dart';
import '../cubits/send_message_cubit/send_message_cubit.dart';
import 'play_voice_widget.dart';

class MessageBubble extends StatefulWidget {
  final Message message;
  final bool isLoading;

  const MessageBubble(
      {super.key, required this.message, required this.isLoading});

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  Future<void> markAsRead(Message message) async {
    await Future.delayed(const Duration(seconds: 1));
    if (!message.isRead) {
      if (message.senderID != FirebaseAuth.instance.currentUser!.uid) {
        await FirebaseFirestore.instance
            .collection('chats')
            .doc(message.chatId)
            .collection('messages')
            .doc(message.messageId)
            .update({
          'isRead': true,
        });
      }
    }
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SendMessageCubit(),
        ),
      ],
      child: BlocListener<MessagesControlCubit, MessagesControlState>(
        listener: (context, state) {
          if (state is DeleteMessageLoading ||
              state is TranslateMessageLoading) {
            setState(() {
              isLoading = true;
            });
          } else if (state is DeleteMessageSuccess) {
            setState(() {
              isLoading = false;
            });
          } else if (state is DeleteMessageFailure) {
            setState(() {
              isLoading = false;
            });
          } else if (state is TranslateMessageSuccess) {
            print(state.newMessage);
            setState(() {
              isLoading = false;
            });
          }
        },
        child: isLoading
            ? const LoadingWidget()
            : InkWell(
                onLongPress: () async {
                  final RenderBox overlay = Overlay.of(context)
                      .context
                      .findRenderObject() as RenderBox;
                  final RenderBox itemBox =
                      context.findRenderObject() as RenderBox;
                  final Offset itemPosition =
                      itemBox.localToGlobal(Offset.zero);

                  final double screenWidth = overlay.size.width;
                  const double menuWidth = 200;
                  final double dx = (screenWidth - menuWidth) / 2;

                  final selectedValue = await showMenu<String>(
                    context: context,
                    position: RelativeRect.fromLTRB(
                      dx,
                      itemPosition.dy - 50,
                      dx + menuWidth,
                      itemPosition.dy,
                    ),
                    items: <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'reply',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(S.of(context).reply),
                            SvgPicture.asset(
                              'assets/images/icons8-replay-48-_1_.svg',
                              width: 25,
                              color: Constanc.kOrignalColor,
                            ),
                          ],
                        ),
                      ),
                      if (widget.message.isOrignal == false)
                        PopupMenuItem<String>(
                          value: 'original',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(S.of(context).orignal),
                              SvgPicture.asset(
                                'assets/images/icons8-translate-48.svg',
                                width: 25,
                                color: Constanc.kOrignalColor,
                              ),
                            ],
                          ),
                        ),
                      PopupMenuItem<String>(
                        value: 'copy',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(S.of(context).copy),
                            SvgPicture.asset(
                              'assets/images/icons8-copy-48.svg',
                              width: 25,
                              color: Constanc.kOrignalColor,
                            ),
                          ],
                        ),
                      ),
                      if (widget.message.senderID ==
                          FirebaseAuth.instance.currentUser!.uid)
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(S.of(context).delete),
                              SvgPicture.asset(
                                'assets/images/icons8-delete-48.svg',
                                width: 25,
                                color: Constanc.kSecondColor,
                              ),
                            ],
                          ),
                        ),
                    ],
                  );

                  // Handle the selected value
                  if (selectedValue != null) {
                    switch (selectedValue) {
                      case 'reply':
                        BlocProvider.of<ReplayMessagesCubit>(context)
                            .getMessageToReplay(
                                message: widget.message, context: context);
                        break;
                      case 'original':
                        BlocProvider.of<MessagesControlCubit>(context)
                            .translateToSekkyMallwany(message: widget.message);

                        break;
                      case 'delete':
                        await BlocProvider.of<MessagesControlCubit>(context)
                            .deleteMessage(message: widget.message);
                        break;
                      case 'copy':
                        FlutterClipboard.copy(widget.message.content!);
                        break;
                      default:
                        break;
                    }
                  }
                },
                child: widget.message.unSend
                    ? const SizedBox()
                    : Dismissible(
                        key: UniqueKey(),
                        confirmDismiss: (a) async {
                          BlocProvider.of<ReplayMessagesCubit>(context)
                              .getMessageToReplay(
                                  message: widget.message, context: context);
                          return null;
                        },
                        child: FutureBuilder<void>(
                          future: markAsRead(widget.message),
                          builder: (context, snapshot) {
                            return widget.message.messageType ==
                                    MessageType.Voice
                                ? PlayVoiceWidget(message: widget.message)
                                : widget.message.messageType ==
                                        MessageType.Image
                                    ? ImageMessageWidget(
                                        message: widget.message,
                                      )
                                    : MessageContent(
                                        isLoading: widget.isLoading,
                                        message: widget.message,
                                      );
                          },
                        ),
                      ),
              ),
      ),
    );
  }
}
