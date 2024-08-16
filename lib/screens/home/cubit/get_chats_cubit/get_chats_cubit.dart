import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:seen/models/user_model.dart' as model;

part 'get_chats_state.dart';

class GetChatsCubit extends Cubit<GetChatsState> {
  GetChatsCubit() : super(GetChatsInitial());

  final _authRef = FirebaseAuth.instance;
  final _fireStoreRef = FirebaseFirestore.instance;
  Future<void> fetchUserChats() async {
    emit(FetchUserChatsLoading());
    try {
      await _fireStoreRef
          .collection('chats')
          .where('participants', arrayContainsAny: [_authRef.currentUser!.uid])
          .orderBy('lastMessageTime', descending: true)
          .get()
          .then((data) {
            emit(FetchUserChatsSuccess(
              chats: data,
            ));
          });
    } catch (e) {
      emit(FetchUserChatsFailure(errMessage: e.toString()));
    }
  }

  Future<void> deleteChat({required String chatId}) async {
    emit(DeleteChatLoading());
    try {
      _fireStoreRef.collection('chats').doc(chatId).delete();
      emit(DeleteChatSuccess());
      fetchUserChats();
    } catch (e) {
      emit(DeleteChatFailure(errMessage: e.toString()));
      print(e);
    }
  }

}
