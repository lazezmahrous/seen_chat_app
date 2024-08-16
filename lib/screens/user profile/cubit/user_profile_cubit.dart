import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:seen/Services/firebase_storage_service.dart';
import 'package:seen/models/user_model.dart' as model;

part 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit() : super(UserProfileInitial());

  final _ref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  void getData() async {
    emit(GetDataLoading());
    try {
      await Future.delayed(const Duration(seconds: 2));

      await _ref.get().then(
        (data) {
          emit(
            GetDataSuccess(
              user: model.User.fromSnap(data),
            ),
          );
        },
      );
    } catch (e) {
      emit(GetDataFailure(
        errMessage: e.toString(),
      ));
    }
  }

  void changeUserName({required String newUserName}) async {
    emit(ChangeUserNameLoading());

    try {
      await Future.delayed(const Duration(seconds: 3));
      await _ref.update({
        "username": newUserName,
      });

      getData();
      emit(ChangeUserNameSuccess());
    } catch (e) {
      emit(ChangeUserNameFailure(
        errMessage: e.toString(),
      ));
    }
  }

  void changeProfileImage({required String newProfileImage}) async {
    emit(ChangProfImgLoading());

    try {
      await Future.delayed(const Duration(seconds: 3));
      await FirebaseStorageMethods.uploadToFirebase(newProfileImage)
          .then((prfImg) async {
        await _ref.update({
          "profImg": prfImg,
        });
      });

      getData();
      emit(ChangProfImgSuccess());
    } catch (e) {
      emit(ChangProfImgFailure(
        errMessage: e.toString(),
      ));
    }
  }
}
