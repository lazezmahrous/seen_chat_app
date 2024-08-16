import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seen/constanc.dart';
import 'package:seen/screens/user%20profile/cubit/user_profile_cubit.dart';
import 'package:seen/screens/gallery_page.dart';
import 'package:seen/global%20widgets/divder_widget.dart';
import 'package:seen/global%20widgets/helpers/show_snack_bar.dart';
import 'package:seen/global%20widgets/icon_button_widget.dart';
import 'package:seen/global%20widgets/text_field.dart';

import '../../../generated/l10n.dart';
import '../../../global widgets/loading_widget.dart';
import '../../../global widgets/open_image_widget.dart';

class GetUserProfileDataWidget extends StatefulWidget {
  const GetUserProfileDataWidget({super.key, required this.formkayUserProfile});
  final GlobalKey<FormState> formkayUserProfile;
  @override
  State<GetUserProfileDataWidget> createState() =>
      _GetUserProfileDataWidgetState();
}

class _GetUserProfileDataWidgetState extends State<GetUserProfileDataWidget> {
  final TextEditingController _newUserName = TextEditingController();
  bool isEditUserName = false;
  File? compressedImageFile;

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserProfileCubit, UserProfileState>(
      listener: (context, state) {
        if (state is ChangeUserNameSuccess) {
          setState(() {
            isEditUserName = false;
          });
        } else if (state is ChangeUserNameLoading) {}
      },
      child: BlocBuilder<UserProfileCubit, UserProfileState>(
        builder: (context, state) {
          if (state is GetDataLoading) {
            return const Center(child: LoadingWidget());
          } else if (state is GetDataSuccess) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        OpenImageWidget(
                          imageUrl: state.user.profImg,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    state.user.profImg),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.add_a_photo),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GalleryPage(
                                      isProfileImg: true,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Visibility(
                  visible: !isEditUserName,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButtonWidget(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            isEditUserName = true;
                          });
                        },
                      ),
                      Text(state.user.username),
                    ],
                  ),
                ),
                Visibility(
                  visible: isEditUserName,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: IconButtonWidget(
                            icon: const Icon(Icons.done),
                            onPressed: () {
                              if (widget.formkayUserProfile.currentState!
                                  .validate()) {
                                BlocProvider.of<UserProfileCubit>(context)
                                    .changeUserName(
                                  newUserName: _newUserName.text,
                                );
                              }
                            },
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: TextFieldWidget(
                            maxLength: 16,
                            ispassword: false,
                            controller: _newUserName,
                            lableName: S.of(context).editUserNameText,
                            password: false,
                            iconName: '',
                            textinput: TextInputType.name,
                            autofocus: true,
                            onChanged: (data) {},
                            validator: (data) {
                              if (data!.isEmpty) {
                                return S.of(context).fieldIsRequired;
                              } else if (data.length < 4) {
                                return S.of(context).userNameIsShort;
                              } else if (data.contains(RegExp(r'\s+'))) {
                                return S.of(context).spacesAreNotAllowed;
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const DivderWidget(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.of(context).personalId),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(state.user.phoneNumber),
                        IconButtonWidget(
                          icon: SvgPicture.asset(
                            'assets/images/icons8-copy-48.svg',
                            width: 25,
                            color: Constanc.kOrignalColor,
                          ),
                          onPressed: () {
                            print(state.user.phoneNumber.split('@').first);
                            FlutterClipboard.copy(
                                    state.user.phoneNumber.split('@').first)
                                .then((value) {
                              showSnackBarBlue(
                                  context, S.of(context).copySuccess);
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                )
              ],
            );
          } else if (state is GetDataFailure) {
            return Text(state.errMessage);
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
