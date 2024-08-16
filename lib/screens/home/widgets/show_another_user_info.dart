// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:octo_image/octo_image.dart';
import 'package:seen/models/user_model.dart' as model;
import '../../../generated/l10n.dart';
import '../../../global widgets/open_image_widget.dart';
import 'get_final_message.dart';

class ShowAnotherUserInfo extends StatefulWidget {
  ShowAnotherUserInfo(
      {super.key, required this.user, required this.showFinalMessage});

  final model.User user;
  bool? showFinalMessage;
  @override
  State<ShowAnotherUserInfo> createState() => _ShowAnotherUserInfoState();
}

class _ShowAnotherUserInfoState extends State<ShowAnotherUserInfo> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              OpenImageWidget(
                imageUrl: widget.user.profImg,
                child: SizedBox(
                  child: OctoImage.fromSet(
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      widget.user.profImg,
                    ),
                    octoSet: OctoSet.circleAvatar(
                      backgroundColor: Colors.grey,
                      text: const CircularProgressIndicator(),
                    ),
                    placeholderFadeInDuration: const Duration(seconds: 1),
                  ),
                ),
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.user.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      if (snapshot.data!['onLine']) {
                        return Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.fromBorderSide(BorderSide(
                                  color: Colors.white,
                                ))),
                          ),
                        );
                      }
                    }
                    return const SizedBox();
                  }),
            ],
          ),
        ),
        // last seen widget
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: widget.showFinalMessage!
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            Center(
                child: Container(
                    constraints: BoxConstraints(
                      maxWidth: width - 100,
                    ),
                    child: Text(
                      widget.user.username,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ))),
            widget.showFinalMessage!
                ? GetFinalMessage(
                    userId: widget.user.uid,
                  )
                : const SizedBox(),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .where('id', whereIn: [
                '${widget.user.uid} ${FirebaseAuth.instance.currentUser!.uid}',
                '${FirebaseAuth.instance.currentUser!.uid} ${widget.user.uid}'
              ]).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(S.of(context).failure);
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('');
                }

                List<dynamic> typingUsers = [];
                for (var doc in snapshot.data!.docs) {
                  typingUsers = doc['typing'] ?? [];
                }

                if (typingUsers.isNotEmpty &&
                    !typingUsers
                        .contains(FirebaseAuth.instance.currentUser!.uid)) {
                  return Container(
                    constraints: const BoxConstraints(
                      maxWidth: 200,
                    ),
                    child: Text(
                      S.of(context).writing,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  );
                } else {
                  String newSeenFormatted = DateFormat(
                          'h:mm a', S.of(context).language_code)
                      .format(DateTime.parse(
                          widget.user.newSeen)); // تمرير كائن DateTime مباشرةً
                  String lastSeenFormatted = DateFormat(
                          'h:mm a', S.of(context).language_code)
                      .format(DateTime.parse(
                          widget.user.lastSeen)); // تمرير كائن DateTime مباشرةً

                  return Container(
                    constraints: const BoxConstraints(
                      maxWidth: 250,
                    ),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.user.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          if (snapshot.data!['onLine']) {
                            return Text(
                              S.of(context).userIsOnline,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            );
                          } else {
                            return Text(
                              '${S.of(context).lastSeenFrom} $newSeenFormatted \n ${S.of(context).to} $lastSeenFormatted',
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                            );
                          }
                        } else if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }

                        return const SizedBox();
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
