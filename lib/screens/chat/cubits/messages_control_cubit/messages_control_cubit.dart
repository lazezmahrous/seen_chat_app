import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../../../Services/translate_services.dart';
import '../../../../models/message_model.dart';

part 'messages_control_state.dart';

class MessagesControlCubit extends Cubit<MessagesControlState> {
  MessagesControlCubit() : super(MessagesControlInitial());
  Future<void> deleteMessage({required Message message}) async {
    await Future.delayed(const Duration(seconds: 1));
    emit(DeleteMessageLoading());
    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(message.chatId)
          .collection('messages')
          .doc(message.messageId)
          .update({
        "unsend": true,
      });

      emit(DeleteMessageSuccess());
    } catch (e) {
      emit(DeleteMessageFailure());

      print(e);
    }
  }

  void translateToSekkyMallwany({required Message message}) {
    emit(TranslateMessageLoading());
    try {
      String newMessage = Translate.fromSekkymallawany(message: message);
      emit(TranslateMessageSuccess(newMessage: newMessage));
    } catch (e) {
      emit(TranslateMessageFailure());
      print(e);
    }
  }

  void deleteTranslateMessage() {
    emit(DeleteTranslateMessage());
  }
}
