import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:seen/models/user_model.dart' as model;

part 'get_users_info_state.dart';

class GetUsersInfoCubit extends Cubit<GetUsersInfoState> {
  GetUsersInfoCubit() : super(GetUsersInfoInitial());

  Future<void> getUserInfoById({required String userId}) async {
    try {
      emit(GetUsersInfoLoading());

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get()
          .then((userData) {
        emit(GetUsersInfoSuccess(userData: model.User.fromSnap(userData)));
      });
    } catch (e) {
      emit(GetUsersInfoFailure(errMessage: e.toString()));
    }
  }
}
