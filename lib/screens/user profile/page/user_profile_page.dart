import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:seen/constanc.dart';
import 'package:seen/screens/login/page/login.dart';

import '../../../global widgets/icon_button_widget.dart';
import '../cubit/user_profile_cubit.dart';
import '../widgets/get_user_profile_data_widget.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});
  static String id = 'profilePage';
  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  GlobalKey<FormState> formkayUserProfile = GlobalKey();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: SpinKitPulse(
        color: Constanc.kOrignalColor,
        size: 100.0,
      ),
      child: BlocListener<UserProfileCubit, UserProfileState>(
        listener: (context, state) {
          if (state is ChangeUserNameLoading || state is ChangProfImgLoading) {
            setState(() {
              isLoading = true;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () {
                  Navigator.pop(context);
                }),
            
          ),
          body: Form(
            key: formkayUserProfile,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                GetUserProfileDataWidget(
                  formkayUserProfile: formkayUserProfile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
