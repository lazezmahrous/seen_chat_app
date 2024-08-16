import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:seen/models/user_model.dart' as model;

part 'get_user_info_state.dart';

class GetUserInfoCubit extends Cubit<GetUserInfoState> {
  GetUserInfoCubit() : super(GetUserInfoInitial());

  Future getUserInfo({required String userUid}) async {
    emit(GetUserInfoLoading());
    try {
      DocumentSnapshot userInfo = await FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .get();
      emit(GetUserInfoSuccess(user: model.User.fromSnap(userInfo)));
    } catch (e) {
      emit(GetUserInfoFailure(errMessage: e.toString()));
    }
  }
}
