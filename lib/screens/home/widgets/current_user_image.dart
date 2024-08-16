import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seen/screens/home/cubit/get_current_user_prof_img_cubit/get_current_user_prof_img_cubit.dart';

class CurrentUserImage extends StatefulWidget {
  const CurrentUserImage({
    super.key,
  });

  @override
  State<CurrentUserImage> createState() => _CurrentUserImageState();
}

class _CurrentUserImageState extends State<CurrentUserImage> {
  @override
  void initState() {
    BlocProvider.of<GetCurrentUserProfImgCubit>(context).getUserImg();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetCurrentUserProfImgCubit, GetCurrentUserProfImgState>(
      builder: (context, state) {
        if (state is GetCurrentUserProfImgLoading) {
          return const CircularProgressIndicator();
        } else if (state is GetCurrentUserProfImgSuccess) {
          return Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                  state.profImgUrl,
                ))),
          );
        } else if (state is GetCurrentUserProfImgFailure) {
          return const Icon(Icons.error_outline);
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
