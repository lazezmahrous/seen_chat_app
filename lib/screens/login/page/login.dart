// ignore_for_file: unnecessary_null_comparison, duplicate_ignore, use_build_context_synchronously

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:seen/constanc.dart';
// ignore: unused_import
import 'package:seen/screens/home/page/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seen/screens/signup/pages/signup.dart';
import 'package:seen/global%20widgets/buttons/orignal_button_widget.dart';
import 'package:seen/global%20widgets/buttons/outline_button_widget.dart';
import 'package:seen/global%20widgets/helpers/show_snack_bar.dart';
import 'package:seen/global%20widgets/text_field.dart';

import '../../../generated/l10n.dart';
import '../cubits/login_cubit/login_cubit.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  static String id = 'Login';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _formkayLogin = GlobalKey();
  bool isLoading = false;
  late String userOld;

  @override
  void initState() {
    userOld = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is LoginSuccess) {
          setState(() {
            isLoading = false;
          });
          Navigator.pushNamedAndRemoveUntil(context, Home.id, (route) => false);
        } else if (state is LoginFailure) {
          print(state.errMessage);
          setState(() {
            isLoading = false;
          });

          if (state.errMessage == 'user-not-found') {
            showSnackBarEror(context, S.of(context).userNotFound, 0);
          } else if (state.errMessage == 'wrong-password') {
            showSnackBarEror(context, S.of(context).wrongPassword, 0);
          } else {
            showSnackBarEror(context, S.of(context).wrong, 0);
          }
        }
      },
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          body: Form(
            key: _formkayLogin,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 600,
                            height: 240,
                            child: SvgPicture.asset('assets/images/login.svg'),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              S.of(context).loginHeadText,
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
                          ),
                          TextFieldWidget(
                            maxLength: 17,
                            ispassword: true,
                            controller: _password,
                            lableName: S.of(context).passwoard,
                            password: true,
                            iconName: 'icons8-password.svg',
                            textinput: TextInputType.emailAddress,
                            // onChanged: (value) {
                            //   _password.text = value;
                            // },
                            onTap: (data) {
                              _password.text = data!;
                              return null;
                            },
                            validator: (data) {
                              if (data!.isEmpty) {
                                return S.of(context).fieldIsRequired;
                              } else if (data.length < 6) {
                                return S.of(context).wrongPassword;
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
                                  S.of(context).userNotLogin,
                                  style: const TextStyle(
                                    color: Colors.black45,
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Signup(
                                              withoutPhoneNumber: true,
                                            ),
                                          ));
                                    },
                                    child: Text(S.of(context).sighnUpHeadText,
                                        style: TextStyle(
                                            color: Constanc.kOrignalColor))),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: OrignalButtonWidget(
                                    text: S.of(context).loginHeadText,
                                    onPressed: () async {
                                      if (_formkayLogin.currentState!
                                          .validate()) {
                                        await BlocProvider.of<LoginCubit>(
                                                context)
                                            .loginUser(
                                          email: _email.value.text,
                                          password: _password.value.text,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]),
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
