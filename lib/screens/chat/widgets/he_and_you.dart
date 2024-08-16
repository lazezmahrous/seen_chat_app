import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constanc.dart';
import '../../../generated/l10n.dart';

class HeAndYou extends StatelessWidget {
  HeAndYou({super.key, required this.senderID});

  String senderID = '';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: senderID == FirebaseAuth.instance.currentUser!.uid
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          Text(
            senderID == FirebaseAuth.instance.currentUser!.uid
                ? S.of(context).You
                : S.of(context).he,
            style: TextStyle(
              color: Constanc.kColorblack,
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }
}
