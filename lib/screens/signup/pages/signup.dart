// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:octo_image/octo_image.dart';
import 'package:seen/services/encrypt_service.dart';
import 'package:seen/constanc.dart';
import 'package:seen/global%20cubits/auth_cubit/auth_cubit.dart';
import 'package:seen/screens/signup/cubits/get_image_cubit/get_image_cubit.dart';
import 'package:seen/screens/gallery_page.dart';
import 'package:seen/screens/home/page/home.dart';
import 'package:seen/screens/login/page/login.dart';
import 'package:seen/screens/phone%20auth/otp_page.dart';
import 'package:seen/global%20widgets/buttons/orignal_button_widget.dart';
import 'package:seen/global%20widgets/helpers/show_snack_bar.dart';
import 'package:seen/global%20widgets/text_field.dart';
import 'package:uuid/uuid.dart';

import '../../../generated/l10n.dart';

class Signup extends StatefulWidget {
  Signup({
    this.userUid,
    this.phoneNumber,
    this.withoutPhoneNumber = false,
    super.key,
  });

  static String id = 'Signup';
  String? userUid;
  String? phoneNumber;
  bool? withoutPhoneNumber;

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _email =
      TextEditingController(text: "@gmail.com");

  final TextEditingController _phoneNumber = TextEditingController();

  final TextEditingController __confirmePasswordController =
      TextEditingController();

  GlobalKey<FormState> formkaySignup = GlobalKey();
  bool isLoading = false;
  bool visibleSighnButton = true;
  String? phoneNumberError;
  File? compressedImageFile;
  String? profImage;

  Future<File?> testCompressFile({required File file}) async {
    if (kIsWeb) {
      // No compression on the web
      return file;
    }

    try {
      var result = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        minWidth: 100,
        minHeight: 100,
        quality: 94,
      );

      // Save the compressed bytes in a new file
      File compressedFile = File('${file.path}.compressed');
      await compressedFile.writeAsBytes(result!);

      return compressedFile;
    } catch (error) {
      print('Error compressing image: $error');
      return null; // Return null on error
    }
  }

  Future<String?> uploadImageToFirebaseStorage(
      {required File imageFile, required String category}) async {
    try {
      var uuid = const Uuid();

      // إنشاء معرف UUID فريد
      String uniqueId = uuid.v4();
      Reference storageRef =
          FirebaseStorage.instance.ref().child(category).child(uniqueId);

      // رفع الصورة إلى Firebase Storage
      UploadTask uploadTask = storageRef.putFile(imageFile);

      // انتظار اكتمال عملية الرفع
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);

      // الحصول على عنوان URL للصورة المحملة
      String imageUrl = await snapshot.ref.getDownloadURL();

      return imageUrl;
    } catch (error) {
      print('Error uploading image to Firebase Storage: $error');
      return null; // Return null on error
    }
  }

  String removeSpaces(String text) {
    return text.replaceAll(RegExp(r'\s+'), '');
  }

  bool _isEmoji(String text) {
    return RegExp(
            r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')
        .hasMatch(text);
  }

  bool _isNumberWithoutLetters(String text) {
    return RegExp(r'[a-zA-Z\u0600-\u06FF]').hasMatch(text);
  }

  String punctuation = r"[!\" "#\$%&'()*+,-.:;<=>?@[\\]^_`{|}~]";
  bool _containsPunctuation(String text) {
    return RegExp(punctuation).hasMatch(text);
  }

  String countryCode = '';

  bool imageIsEmpty = false;
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthCubitState>(
      listener: (context, state) {
        if (state is AuthSignupLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is AuthSignupFaluire) {
          setState(() {
            visibleSighnButton = true;

            isLoading = false;
          });
          if (state.errMessage == 'weak-password') {
            showSnackBarEror(context, S.of(context).weakPassword, 0);
          } else if (state.errMessage == 'email-already-in-use') {
            showSnackBarEror(context, S.of(context).emailAlreadyInUse, 0);
          } else {
            showSnackBarEror(context, S.of(context).wrong, 0);
          }
        } else if (state is AuthSignupSuccess) {
          setState(() {
            isLoading = false;
          });

          Navigator.pushNamedAndRemoveUntil(
            context,
            Home.id,
            (route) => false,
          );
        }
      },
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const SpinKitPulse(
          color: Colors.indigoAccent,
          size: 100.0,
        ),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Form(
            key: formkaySignup,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              BlocBuilder<GetImageCubit, GetImageState>(
                                builder: (context, state) {
                                  if (state is GetImageSuccess) {
                                    compressedImageFile = File(state.imagePath);
                                    return Stack(
                                      children: [
                                        SizedBox(
                                          child: OctoImage.fromSet(
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.cover,
                                            image: FileImage(
                                              File(state.imagePath),
                                            ),
                                            octoSet: OctoSet.circleAvatar(
                                              backgroundColor: Colors.grey,
                                              text: const Text(""),
                                            ),
                                            placeholderFadeInDuration:
                                                const Duration(seconds: 1),
                                          ),
                                        ),
                                        Positioned(
                                            bottom: 0,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Constanc.kColorGray,
                                              ),
                                              child: IconButton(
                                                  onPressed: () async {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              GalleryPage(
                                                            isProfileImg: false,
                                                            isChatPage: false,
                                                          ),
                                                        ));
                                                  },
                                                  icon: const Icon(
                                                    Icons.add_a_photo_rounded,
                                                    size: 30,
                                                  )),
                                            )),
                                      ],
                                    );
                                  } else {
                                    return Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Constanc.kColorGray,
                                          ),
                                          width: 120,
                                          height: 120,
                                          child: InkWell(
                                            onTap: () async {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        GalleryPage(
                                                      isProfileImg: false,
                                                                                                                  isChatPage: false,

                                                    ),
                                                  ));
                                            },
                                            child: const Icon(
                                              Icons.add_a_photo_rounded,
                                              size: 100,
                                            ),
                                          ),
                                        ),
                                        imageIsEmpty
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 20),
                                                child: Text(
                                                  S.of(context).fieldIsRequired,
                                                  style: TextStyle(
                                                    color:
                                                        Constanc.kSecondColor,
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            S.of(context).sighnUpHeadText,
                            style: const TextStyle(
                              fontSize: 35,
                              color: Color(0xff172b4d),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFieldWidget(
                          maxLength: 16,
                          ispassword: false,
                          controller: _userName,
                          lableName: S.of(context).sighnUpUserName,
                          password: false,
                          iconName: 'icons8-face.svg',
                          textinput: TextInputType.name,
                          onChanged: (data) {},
                          validator: (data) {
                            if (data!.isEmpty) {
                              return S.of(context).fieldIsRequired;
                            } else if (data.length < 4) {
                              return S.of(context).wrongUserName;
                            } else if (data.contains(RegExp(r'\s+'))) {
                              return S.of(context).spacesAreNotAllowed;
                            }
                            return null;
                          },
                        ),
                        widget.withoutPhoneNumber!
                            ? TextFieldWidget(
                                maxLength: 60,
                                ispassword: false,
                                controller: _email,
                                lableName: S.of(context).loginEmail,
                                password: false,
                                iconName: 'at.svg',
                                textinput: TextInputType.emailAddress,
                                onTap: (data) {
                                  _email.text = data!;
                                  return null;
                                },
                                validator: (data) {
                                  if (data!.isEmpty) {
                                    return S.of(context).fieldIsRequired;
                                  }
                                  return null;
                                },
                              )
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: TextFormField(
                                          validator: (data) {
                                            if (data!.isEmpty) {
                                              return 'يرجي إدخال رقم الهاتف';
                                            } else if (data.length < 10) {
                                              return 'رقم الهاتف قصير';
                                            } else if (_isEmoji(data) ||
                                                _containsPunctuation(data) ||
                                                _isNumberWithoutLetters(data)) {
                                              return 'رقم الهاتف يجب ان يحتوي علي أرقام فقط';
                                            } else {}
                                            return null;
                                          },
                                          maxLength: 11,
                                          controller: _phoneNumber,
                                          // textDirection: TextDirection.ltr,
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                          // textAlign: TextAlign.end,
                                          keyboardType: TextInputType.phone,
                                          autofocus: true,
                                          decoration: InputDecoration(
                                            hintText: 'رقم الهاتف',
                                            prefixIcon: CountryCodePicker(
                                              onInit: (code) {
                                                countryCode = code!.dialCode!;
                                              },
                                              onChanged: (code) {
                                                countryCode = code.dialCode!;
                                              },
                                              initialSelection: 'EG',
                                              favorite: const ['+20', 'EG'],
                                              showCountryOnly: false,
                                              showOnlyCountryWhenClosed: false,
                                              alignLeft: false,
                                              boxDecoration: BoxDecoration(
                                                color: Constanc.kColorWhite,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                              ),
                                              padding: const EdgeInsets.all(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        TextFieldWidget(
                          maxLength: 17,
                          ispassword: true,
                          controller: _password,
                          lableName: S.of(context).passwoard,
                          password: true,
                          iconName: 'icons8-password.svg',
                          textinput: TextInputType.emailAddress,
                          onChanged: (value) {},
                          validator: (data) {
                            if (data!.isEmpty) {
                              return S.of(context).fieldIsRequired;
                            } else if (data.length < 6) {
                              return S.of(context).weakPassword;
                            }
                            return null;
                          },
                        ),
                        TextFieldWidget(
                          maxLength: 17,
                          ispassword: true,
                          controller: __confirmePasswordController,
                          lableName: S.of(context).confirmPsswoard,
                          password: true,
                          iconName: 'icons8-password.svg',
                          textinput: TextInputType.emailAddress,
                          onChanged: (value) {},
                          validator: (data) {
                            if (data!.isEmpty) {
                              return S.of(context).confirmPsswoard;
                            } else if (data.trim() != _password.text.trim()) {
                              return S.of(context).passwoardNotMatch;
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                S.of(context).userisLogin,
                                style: const TextStyle(
                                  color: Colors.black45,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, Login.id);
                                },
                                child: Text(
                                  S.of(context).loginHeadText,
                                  style:
                                      TextStyle(color: Constanc.kOrignalColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Visibility(
                                visible: visibleSighnButton,
                                child: OrignalButtonWidget(
                                  text: S.of(context).sighnUpHeadText,
                                  onPressed: () async {
                                    if (formkaySignup.currentState!
                                        .validate()) {
                                      final encryptionHelper =
                                          EncryptionHelper();

                                      if (compressedImageFile != null) {
                                        setState(() {
                                          visibleSighnButton = false;
                                        });

                                        await uploadImageToFirebaseStorage(
                                                imageFile: compressedImageFile!,
                                                category: 'profileImages')
                                            .then(
                                          (value) async {
                                            if (!widget.withoutPhoneNumber!) {
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) => OtpPage(
                                              //         userName: removeSpaces(
                                              //             _userName.text),
                                              //         profUrl: value!,
                                              //         password: encryptionHelper
                                              //             .encryptText(
                                              //                 _password.text),
                                              //         phoneNumber:
                                              //             '$countryCode ${_phoneNumber.text.substring(0, 4).replaceFirst('0', '')} ${_phoneNumber.text.substring(4, 7)} ${_phoneNumber.text.substring(7)}'),
                                              //   ),
                                              // );
                                            } else {
                                              print(_phoneNumber.text);
                                              await BlocProvider.of<AuthCubit>(
                                                      context)
                                                  .signUpUser(
                                                email: _email.text,
                                                phoneNumber: _email.text,
                                                userUid: '',
                                                password: encryptionHelper
                                                    .encryptText(
                                                  _password.text,
                                                ),
                                                userName: removeSpaces(
                                                    _userName.value.text),
                                                profImg: value!,
                                              )
                                                  .then((onValue) {
                                                BlocProvider.of<GetImageCubit>(
                                                        context)
                                                    .deletImage();
                                              });
                                            }
                                          },
                                        );
                                      } else {
                                        setState(() {
                                          imageIsEmpty = true;
                                        });
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: visibleSighnButton ? false : true,
                          child: Center(
                              child: Text(S.of(context).loadingSighnUser)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
