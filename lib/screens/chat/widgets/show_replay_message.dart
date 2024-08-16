import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seen/models/message_model.dart';

import '../../../constanc.dart';
import '../../../global cubits/screen_actions_cubit/screen_actions_cubit.dart';

class ShowReplayMessage extends StatelessWidget {
  final Message message;

  const ShowReplayMessage({super.key, required this.message});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return !message.unSend
        ? InkWell(
            onTap: () {
              BlocProvider.of<ScreenActionsCubit>(context)
                  .goToReplayMessage(message.index!);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Constanc.kColorGray,
              ),
              constraints: BoxConstraints(
                maxWidth: message.content!.length < 24 ||
                        message.messageType == MessageType.Voice
                    ? width / 2
                    : width / 1.5,
              ),
              margin: const EdgeInsetsDirectional.only(top: 10, bottom: 5),
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 200,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  child: Row(
                    children: [
                      Container(
                        width: 3,
                        height: 15,
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: message.rplay!.first.messageType ==
                                  MessageType.Text
                              ? Text(
                                  message.rplay!.first.content!,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                  ),
                                )
                              : message.rplay!.first.messageType ==
                                      MessageType.Image
                                  ? Container(
                                      width: 100,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            message.rplay!.first.content!,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : const Text('مقطع صوتي'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
