import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seen/constanc.dart';
import 'package:seen/models/message_model.dart';

import '../../../generated/l10n.dart';
import 'he_and_you.dart';
import 'time_and_seen_plus_sent.dart';
import '../../../global widgets/open_image_widget.dart';

class ImageMessageWidget extends StatelessWidget {
  const ImageMessageWidget({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment:
            message.senderID == FirebaseAuth.instance.currentUser!.uid
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
        children: [
          HeAndYou(
            senderID: message.senderID!,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: width / 2,
              height: width / 2,
              child: OpenImageWidget(
                imageUrl: message.content!,
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(20), // Apply borderRadius here
                  child: CachedNetworkImage(
                    imageUrl: message.content!,
                    fit: BoxFit.cover, // Ensure the image covers the container
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment:
                  message.senderID == FirebaseAuth.instance.currentUser!.uid
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    Text(
                        DateFormat('EEE, h:mm a', S.of(context).language_code)
                            .format(message.sentAt!.toDate())
                            .toString(),
                        // textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 9,
                          color: message.senderID ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? Constanc.kOrignalColor
                              : Constanc.kSecondColor,
                        )),
                    message.senderID == FirebaseAuth.instance.currentUser!.uid
                        ? TimeAndSeenPlusSent(
                            message: message,
                          )
                        : const SizedBox(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
