import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seen/models/message_model.dart';

import '../../../constanc.dart';
import '../../../generated/l10n.dart';

class TimeAndSeenPlusSent extends StatelessWidget {
  TimeAndSeenPlusSent({super.key, required this.message});
  Message message;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            DateFormat('EEE, h:mm a', S.of(context).language_code)
                .format(message.sentAt!.toDate())
                .toString(),
            style: TextStyle(
              fontSize: 9,
              color: message.senderID == FirebaseAuth.instance.currentUser!.uid
                  ? Constanc.kColorWhite
                  : Constanc.kColorblack,
            )),
        message.senderID == FirebaseAuth.instance.currentUser!.uid
            ? Container(
                constraints: const BoxConstraints(
                  maxWidth: 50,
                ),
                child: Text(
                  message.isRead
                      ? S.of(context).messageSeen
                      : S.of(context).messageSent,
                  style: TextStyle(
                    fontSize: 9,
                    color: Constanc.kColorWhite,
                  ),
                ))
            : const SizedBox(),
      ],
    );
  }
}
