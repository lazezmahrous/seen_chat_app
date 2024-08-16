import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seen/constanc.dart';

import '../../../global cubits/get_chat_data_and_messages_cubit/get_chat_data_and_messages_cubit.dart';
import '../../../models/message_model.dart';

class GetFinalMessage extends StatefulWidget {
  const GetFinalMessage({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<GetFinalMessage> createState() => _GetFinalMessageState();
}

class _GetFinalMessageState extends State<GetFinalMessage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => GetChatDataAndMessagesCubit()
        ..getChatId(anotheUserUid: widget.userId),
      child:
          BlocBuilder<GetChatDataAndMessagesCubit, GetChatDataAndMessagesState>(
        builder: (context, state) {
          if (state is GetChatIdSuccess) {
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(state.chatId)
                  .collection('messages')
                  .orderBy('sentAt', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> messageSnapshot) {
                if (messageSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (messageSnapshot.hasError) {
                  return const Text('Error occurred');
                } else if (!messageSnapshot.hasData ||
                    messageSnapshot.data!.docs.isEmpty) {
                  return const Text('No messages yet.');
                }

                // Now you have access to the messages
                List<Message> allMessages = [];
                List<Message> unreadMessages = [];

                for (var doc in messageSnapshot.data!.docs) {
                  Message message = Message.fromSnapshot(
                      doc as DocumentSnapshot<Map<String, dynamic>>);

                  if (message.unSend) {
                  } else {
                    allMessages.add(message);
                    if (!message.isRead) {
                      unreadMessages.add(message);
                    }
                  }
                }

                allMessages.sort((a, b) => b.sentAt!.compareTo(a.sentAt!));
                unreadMessages.sort((a, b) => b.sentAt!.compareTo(a.sentAt!));
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: width - 120,
                      child: Text(
                        unreadMessages.isNotEmpty
                            ? unreadMessages.first.messageType ==
                                    MessageType.Voice
                                ? 'تم إرسال رسالة صوتيه'
                                : unreadMessages.first.messageType ==
                                        MessageType.Image
                                    ? 'تم إرسال صوره'
                                    : unreadMessages.first.content!
                            : allMessages.isNotEmpty
                                ? allMessages.first.messageType ==
                                        MessageType.Voice
                                    ? 'تم إرسال رسالة صوتيه'
                                    : allMessages.first.messageType ==
                                            MessageType.Image
                                        ? 'تم إرسال صوره'
                                        : allMessages.first.content!
                                : '',
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    unreadMessages.isNotEmpty
                        ? unreadMessages.first.senderID !=
                                FirebaseAuth.instance.currentUser!.uid
                            ? Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Constanc.kSecondColor,
                                ),
                                child: Center(
                                    child: Text(
                                  '${unreadMessages.length}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Constanc.kColorWhite,
                                  ),
                                )),
                              )
                            : const SizedBox()
                        : const SizedBox(),
                  ],
                );
              },
            );
          } else if (state is GetChatIdLoading) {
            return const CircularProgressIndicator();
          } else {
            return const Text('حدث خطأ');
          }
        },
      ),
    );
  }
}
