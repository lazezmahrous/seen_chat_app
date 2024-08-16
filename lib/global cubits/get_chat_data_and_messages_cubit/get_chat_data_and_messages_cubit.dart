import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'get_chat_data_and_messages_state.dart';

class GetChatDataAndMessagesCubit extends Cubit<GetChatDataAndMessagesState> {
  GetChatDataAndMessagesCubit() : super(GetChatDataAndMessagesInitial());
  late String chatId;

  Future<void> getChatId({required String anotheUserUid}) async {
    final ref = FirebaseFirestore.instance.collection('chats');
    emit(GetChatIdLoading());
    try {
      await ref
          .where('id', whereIn: [
            '$anotheUserUid ${FirebaseAuth.instance.currentUser!.uid}',
            '${FirebaseAuth.instance.currentUser!.uid} $anotheUserUid'
          ])
          .get()
          .then((onValue) {
            chatId = onValue.docs.first.id;
            emit(GetChatIdSuccess(chatId: chatId));
          });
    } catch (e) {
      emit(GetChatIdFailure());
      print(e);
    }
  }
}
