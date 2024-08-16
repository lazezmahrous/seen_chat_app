import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seen/constanc.dart';
import 'package:seen/models/message_model.dart';

import '../../../generated/l10n.dart';
import '../cubits/replay_messages_cubit/replay_messages_cubit.dart';

class ReplayMessageWidget extends StatelessWidget {
  const ReplayMessageWidget({super.key});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return BlocBuilder<ReplayMessagesCubit, ReplayMessagesState>(
      builder: (context, state) {
        if (state is GetReplayMessageLoading) {
          return const LinearProgressIndicator();
        } else if (state is GetReplayMessageSuccesss) {
          return Container(
            width: width / 1.2,
            decoration: BoxDecoration(
                color: Constanc.kColorGray,
                borderRadius: BorderRadius.circular(40)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    BlocProvider.of<ReplayMessagesCubit>(context)
                        .deleteReplayWidget();
                  },
                  icon: const Icon(Icons.cancel_outlined),
                ),
                state.message.messageType == MessageType.Image
                    ? const Icon(Icons.image)
                    : state.message.messageType == MessageType.Voice
                        ?  Text(S.of(context).soundMessage)
                        : Container(
                            constraints: BoxConstraints(
                              maxWidth: width / 2,
                            ),
                            child: Text(
                              state.message.content!,
                              style: const TextStyle(
                                fontSize: 12,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    height: 30,
                    width: 3,
                    color: Constanc.kColorblack,
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
