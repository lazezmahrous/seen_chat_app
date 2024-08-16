import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:seen/constanc.dart';

part 'screen_actions_state.dart';

class ScreenActionsCubit extends Cubit<ScreenActionsState> {
  ScreenActionsCubit() : super(ScreenActionsInitial());

  Future<void> protectScreen({required String userUid}) async {
    emit(ScreenActionsHandelScreenShotLoading());
    try {
      await Constanc.getChatWherUserIn(secondUserUid: userUid).then((onValue) {
        for (var element in onValue.docs) {
          if ((element.data()['preventAndroidScreenShot'] as List)
                  .contains(FirebaseAuth.instance.currentUser!.uid) ||
              (element.data()['preventAndroidScreenShot'] as List)
                  .contains(userUid)) {
            // ChatPage.screenListener.preventAndroidScreenShot(true);
            emit(ScreenActionsPreventScreenShot());
          } else {
            // ChatPage.screenListener.preventAndroidScreenShot(false);
            emit(ScreenActionsUnPreventScreenShot());
          }
        }
      });
    } catch (e) {
      emit(ScreenActionsHandelScreenShotFailure());
    }
  }

  Future<void> preventScreenShot({required String userUid}) async {
    emit(ScreenActionsHandelScreenShotLoading());
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('chats')
          .where('id', whereIn: [
        '$userUid ${FirebaseAuth.instance.currentUser!.uid}',
        '${FirebaseAuth.instance.currentUser!.uid} $userUid'
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

        await protectScreen(userUid: userUid);
      }
    } catch (e) {
      emit(ScreenActionsHandelScreenShotFailure());
    }
  }

  Future<void> takeScreenShot({required String userUid}) async {
    print('s');
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('chats')
          .where('participants', whereIn: [
        '$userUid ${FirebaseAuth.instance.currentUser!.uid}',
        '${FirebaseAuth.instance.currentUser!.uid} $userUid',
      ]).get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.update({
          'screenShots':
              FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
        });

        emit(ScreenActionsTakeScreenShot());
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void openKeyboard() {
    emit(ScreenActionsOpenkeyboard());
  }

  void goToReplayMessage(int index) {
    emit(
      ScreenActionsGoToReplayMessage(
        indexOfmessage: index,
      ),
    );
  }
}
