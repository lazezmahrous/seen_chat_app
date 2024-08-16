// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:pinput/pinput.dart';
// import 'package:seen/cubits/auth_cubit/auth_cubit.dart';
// import 'package:seen/cubits/get_image_cubit/get_image_cubit.dart';
// import 'package:seen/pages/Home/page/home.dart';
// import 'package:seen/widgets/timeout_widget.dart';

// class OtpPage extends StatefulWidget {
//   const OtpPage(
//       {super.key,
//       required this.phoneNumber,
//       required this.password,
//       required this.userName,
//       required this.profUrl});
//   static String id = 'OtpPage';

//   final String phoneNumber;
//   final String password;
//   final String userName;
//   final String profUrl;
//   @override
//   State<OtpPage> createState() => _OtpPageState();
// }

// class _OtpPageState extends State<OtpPage> {
//   FirebaseAuth auth = FirebaseAuth.instance;
//   final pinController = TextEditingController();
//   bool _hasError = false;
//   @override
//   void initState() {
//     super.initState();
//     print('password ============================= : ${widget.password}');
//     BlocProvider.of<AuthCubit>(context)
//         .signUpWithOtp(context: context, phoneNumber: widget.phoneNumber);
//   }

//   bool isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     final cubit = BlocProvider.of<AuthCubit>(context);
//     return BlocListener<AuthCubit, AuthCubitState>(
//       listener: (context, state) async {
//         if (state is PhoneAuthLoading) {
//           setState(() {
//             isLoading = true;
//           });
//         } else if (state is PhoneAuthCodeSent) {
//           print('verificationId :${state.verificationId}');
//         } else if (state is PhoneAuthFaluire) {
//           print('err messsage ${state.errMessage}');
//           setState(() {
//             _hasError = true;
//             isLoading = false;
//           });
//           showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 title: const Text('Error'),
//                 content: Text('Invalid OTP. ${state.errMessage}.'),
//                 actions: [
//                   TextButton(
//                     onPressed: () => Navigator.of(context).pop(),
//                     child: const Text('OK'),
//                   ),
//                 ],
//               );
//             },
//           );
//         } else if (state is PhoneAuthSuccess) {
//           await BlocProvider.of<AuthCubit>(context)
//               .signUpUser(
//             email: '',
//             phoneNumber: widget.phoneNumber,
//             password: widget.password,
//             userName: widget.userName,
//             profImg: widget.profUrl,
//             userUid: state.userUid,
//           )
//               .then((onValue) {
//             BlocProvider.of<GetImageCubit>(context).deletImage();
//           });
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const Home(),
//             ),
//           );
//         }
//       },
//       child: ModalProgressHUD(
//         inAsyncCall: isLoading,
//         progressIndicator: const SpinKitPulse(
//           color: Colors.indigoAccent,
//           size: 100.0,
//         ),
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text('تأكيد رقم التلفون'),
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Center(
//               child: ListView(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 shrinkWrap: true,
//                 children: [
//                   Container(
//                     constraints: BoxConstraints(
//                       maxWidth: screenWidth / 1.3,
//                     ),
//                     child: Text(
//                       'تم إرسال رمز مكون من 6 أرقام لرقم \n ${widget.phoneNumber}',
//                       style: const TextStyle(
//                         fontSize: 20,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 30,
//                   ),
//                   Pinput(
//                     controller: pinController,
//                     length: 6,
//                     defaultPinTheme: PinTheme(
//                       width: 56,
//                       height: 56,
//                       textStyle: const TextStyle(
//                         fontSize: 20,
//                         color: Colors.black,
//                       ),
//                       decoration: BoxDecoration(
//                         color: _hasError ? Colors.red[50] : Colors.white,
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(
//                           color: _hasError ? Colors.red : Colors.grey,
//                         ),
//                       ),
//                     ),
//                     onCompleted: (pin) {
//                       pinController.text = pin;
//                       print(pin);
//                       cubit.verifyCode(
//                         phoneNumber: widget.phoneNumber,
//                         smsCode: pin,
//                         context: context,
//                       );
//                     },
//                   ),
//                   const SizedBox(
//                     height: 30,
//                   ),
//                   const TimeoutWidget(),
//                   const SizedBox(
//                     height: 30,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
