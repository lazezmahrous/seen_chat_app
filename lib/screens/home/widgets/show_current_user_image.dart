import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/get_current_user_prof_img_cubit/get_current_user_prof_img_cubit.dart';

class ShowCurrentUserImage extends StatelessWidget {
  const ShowCurrentUserImage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetCurrentUserProfImgCubit()..getUserImg(),
      child:
          BlocBuilder<GetCurrentUserProfImgCubit, GetCurrentUserProfImgState>(
        builder: (context, state) {
          if (state is GetCurrentUserProfImgLoading) {
            return const CircularProgressIndicator();
          } else if (state is GetCurrentUserProfImgSuccess) {
            return CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(state.profImgUrl),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
