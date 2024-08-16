import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octo_image/octo_image.dart';
import 'package:seen/global cubits/get_users_info_cubit/get_users_info_cubit.dart';

import '../../home/widgets/get_final_message.dart';
import '../page/chat_page.dart';

class UserChatBody extends StatefulWidget {
  const UserChatBody({super.key, required this.userId});

  final String userId;
  @override
  State<UserChatBody> createState() => _UserChatBodyState();
}

class _UserChatBodyState extends State<UserChatBody> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<GetUsersInfoCubit>(context)
        .getUserInfoById(userId: widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetUsersInfoCubit, GetUsersInfoState>(
        builder: (context, state) {
      if (state is GetUsersInfoLoading) {
        return const LinearProgressIndicator();
      } else if (state is GetUsersInfoSuccess) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  uid: (state.userData.uid),
                  fcToken: (state.userData.fcToken),
                ),
              ),
            );
          },
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  child: OctoImage.fromSet(
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      state.userData.profImg,
                    ),
                    octoSet: OctoSet.circleAvatar(
                      backgroundColor: Colors.grey,
                      text: const Text(""),
                    ),
                    placeholderFadeInDuration: const Duration(seconds: 1),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(state.userData.username),
                  GetFinalMessage(
                    userId: state.userData.uid,
                  ),
                ],
              ),
            ],
          ),
        );
      } else if (state is GetUsersInfoFailure) {
        return Center(
          child: Text(state.errMessage),
        );
      } else {
        return const Text('خطأ غير متوقع');
      }
    });
  }
}
