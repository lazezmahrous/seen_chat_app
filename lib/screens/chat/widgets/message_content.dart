import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:seen/constanc.dart';
import 'package:seen/models/message_model.dart';
import 'package:seen/screens/chat/cubits/messages_control_cubit/messages_control_cubit.dart';
import 'package:seen/screens/chat/widgets/show_replay_message.dart';

import '../../../generated/l10n.dart';
import 'he_and_you.dart';
import 'time_and_seen_plus_sent.dart';

class MessageContent extends StatefulWidget {
  const MessageContent({
    super.key,
    required this.message,
    required this.isLoading,
  });
  final Message message;
  final bool isLoading;

  @override
  State<MessageContent> createState() => _MessageContentState();
}

class _MessageContentState extends State<MessageContent> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment:
          widget.message.senderID == FirebaseAuth.instance.currentUser!.uid
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
      children: [
        widget.message.rplay != null && !widget.message.unSend
            ? ShowReplayMessage(
                message: widget.message,
              )
            : const SizedBox(),
        HeAndYou(
          senderID: widget.message.senderID!,
        ),
        Row(
          mainAxisAlignment:
              widget.message.senderID == FirebaseAuth.instance.currentUser!.uid
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: widget.message.content!.length < 24
                    ? width / 3
                    : width / 1.5,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              decoration: BoxDecoration(
                color: widget.message.messageType == MessageType.Voice
                    ? null
                    : widget.message.senderID ==
                            FirebaseAuth.instance.currentUser!.uid
                        ? null
                        : Colors.grey[300],
                gradient: widget.message.messageType == MessageType.Voice ||
                        widget.message.senderID !=
                            FirebaseAuth.instance.currentUser!.uid
                    ? null
                    : LinearGradient(
                        colors: [
                          Constanc.kOrignalColor,
                          Colors.blue, // يمكنك إضافة الألوان التي تريدها هنا
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                crossAxisAlignment: S.of(context).language_code == 'ar'
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<MessagesControlCubit, MessagesControlState>(
                        builder: (context, state) {
                          if (state is TranslateMessageSuccess) {
                            print('object');
                            return text_message(
                              isLoading: widget.isLoading,
                              textMessage: state.newMessage,
                              senderId: widget.message.senderID!,
                            );
                          } else {
                            return text_message(
                              isLoading: widget.isLoading,
                              textMessage: widget.message.content!,
                              senderId: widget.message.senderID!,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TimeAndSeenPlusSent(
                          message: widget.message,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<MessagesControlCubit, MessagesControlState>(
              builder: (context, state) {
                if (state is TranslateMessageSuccess) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () async {
                        BlocProvider.of<MessagesControlCubit>(context)
                            .deleteTranslateMessage();
                      },
                      child: SvgPicture.asset(
                        'assets/images/icons8-reload.svg',
                        width: 25,
                        color: Constanc.kOrignalColor,
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            )
          ],
        ),
      ],
    );
  }
}

class text_message extends StatefulWidget {
  text_message({
    super.key,
    required this.textMessage,
    required this.senderId,
    required this.isLoading,
  });

  String? textMessage;
  final String senderId;
  final bool isLoading;

  @override
  State<text_message> createState() => _text_messageState();
}

class _text_messageState extends State<text_message> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(
          widget.textMessage!,
          style: TextStyle(
            overflow: widget.isLoading ? TextOverflow.ellipsis : null,
            color: widget.senderId == FirebaseAuth.instance.currentUser!.uid
                ? Constanc.kColorWhite
                : Constanc.kColorblack,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
