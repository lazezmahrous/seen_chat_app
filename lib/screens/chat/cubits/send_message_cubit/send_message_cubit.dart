import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:seen/constanc.dart';
import 'package:seen/global%20cubits/get_chat_data_and_messages_cubit/get_chat_data_and_messages_cubit.dart';
import 'package:seen/models/message_model.dart';
import 'package:uuid/uuid.dart';

part 'send_message_state.dart';

class SendMessageCubit extends Cubit<SendMessageState> {
  SendMessageCubit() : super(SendMessageInitial());
  final _fireStore = FirebaseFirestore.instance;

  Future<void> sendMessage({
    required BuildContext context,
    Message? replay,
    required String messageContent,
    required String secondUserUid,
    required bool isOrignalMessage,
    bool? isVoiceMessage = false,
    bool? isImageMessage = false,
    bool? isReplayMessage = false,
    bool? isScreenShotMessage = false,
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null && messageContent.isNotEmpty) {
        QuerySnapshot<Map<String, dynamic>> chatCollection =
            await Constanc.getChatWherUserIn(secondUserUid: secondUserUid);
        String? chatId;
        bool chatFound = false;

        if (chatCollection.docs.isNotEmpty) {
          final newChatDoc = chatCollection.docs.first;
          chatId = newChatDoc.id;
          chatFound = true;
        } else {
          final newChatDoc = await _fireStore.collection('chats').add({
            'id': '$secondUserUid ${currentUser.uid}',
            'participants': [secondUserUid, currentUser.uid],
            'preventAndroidScreenShot': [],
            'typing': [],
            'lastMessageTime': DateTime.now(),
            'block': false,
          });
          chatId = newChatDoc.id;

          await BlocProvider.of<GetChatDataAndMessagesCubit>(context)
              .getChatId(anotheUserUid: secondUserUid);
        }
        var uuid = const Uuid();
        String uid = uuid.v4();
        final chatDocRef = _fireStore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .doc(uid);

        final newMessage = Message(
          senderID: currentUser.uid,
          chatId: chatId,
          content: messageContent,
          messageType: isVoiceMessage!
              ? MessageType.Voice
              : isImageMessage!
                  ? MessageType.Image
                  : isScreenShotMessage!
                      ? MessageType.ScreenShot
                      : MessageType.Text,
          sentAt: Timestamp.now(),
          isRead: false,
          messageId: uid,
          index: 0, // سيتم تحديث الفهرس عند إدراج الرسالة
          rplay: isReplayMessage! ? [replay!] : null,
          isOrignal: isOrignalMessage,
        );
        emit(SendMessageLoading(message: newMessage));

        await chatDocRef.set(newMessage.toJson());

        await _fireStore.collection("chats").doc(chatId).update({
          "lastMessageTime": DateTime.now(),
        });

        emit(SendMessageSuccess(message: newMessage));
      } else {
        throw Exception("Current user is null or message content is empty");
      }
    } catch (e) {
      emit(SendMessageFailure(errMessage: e.toString()));
    }
  }
}
