import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'prevent_screen_shot_state.dart';

class PreventScreenShotCubit extends Cubit<PreventScreenShotState> {
  PreventScreenShotCubit() : super(PreventScreenShotInitial());

  Future<void> isPreventScreenShot(
      {required String chatId, required String anotherUserId}) async {
    late DocumentSnapshot<Map<String, dynamic>> chatData;
    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .get()
          .then((onValue) {
        chatData = onValue;
      });

      List<String> preventAndroidScreenShot = List<String>.from(
          chatData.data()!['preventAndroidScreenShot'] as List<dynamic>);

      if (preventAndroidScreenShot
          .contains(FirebaseAuth.instance.currentUser!.uid)) {
        print('preventAndroidScreenShot');
        emit(PreventScreenShot());
      } else if (preventAndroidScreenShot.contains(anotherUserId)) {
        emit(AnotherUserUnPreventScreenShot());
      } else {
        emit(UnPreventScreenShot());
      }
    } catch (e) {
      print(e);
      emit(PreventScreenShotFailure());
    }
  }

  Future<void> preventScreenShot({required String anotherUserId}) async {
    // emit(PreventScreenShotLoading());
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('chats')
          .where('id', whereIn: [
        '$anotherUserId ${FirebaseAuth.instance.currentUser!.uid}',
        '${FirebaseAuth.instance.currentUser!.uid} $anotherUserId'
      ]).get();

      for (var doc in querySnapshot.docs) {
        final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
        final data = doc.data();
        final List<dynamic> preventList =
            data['preventAndroidScreenShot'] ?? [];

        if (preventList.contains(currentUserUid)) {
          await doc.reference.update({
            'preventAndroidScreenShot':
                FieldValue.arrayRemove([currentUserUid]),
          });
        } else {
          await doc.reference.update({
            'preventAndroidScreenShot': FieldValue.arrayUnion([currentUserUid]),
          });
        }

        // emit(PreventScreenShotSuccess());
        await isPreventScreenShot(
            anotherUserId: anotherUserId, chatId: querySnapshot.docs.first.id);
      }
    } catch (e) {
      print(e.toString());
      // emit(PreventScreenShotFailure());
    }
  }
}
