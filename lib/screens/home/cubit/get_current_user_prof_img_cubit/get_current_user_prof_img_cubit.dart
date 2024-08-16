import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'get_current_user_prof_img_state.dart';

class GetCurrentUserProfImgCubit extends Cubit<GetCurrentUserProfImgState> {
  GetCurrentUserProfImgCubit() : super(GetCurrentUserProfImgInitial());
  final _ref = FirebaseFirestore.instance;
  Future getUserImg() async {
    emit(GetCurrentUserProfImgLoading());
    try {
      await _ref
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((userData) {
        emit(GetCurrentUserProfImgSuccess(
            profImgUrl: userData.data()!['profImg']));
      });
    } catch (e) {
      emit(GetCurrentUserProfImgFailure(errMessage: e.toString()));
    }
  }
}
