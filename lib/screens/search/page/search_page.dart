import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:seen/global%20widgets/text_field.dart';

import '../../../generated/l10n.dart';
import '../../chat/page/chat_page.dart';

class Search extends StatefulWidget {
  const Search({super.key});
  static String id = 'Search';

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _userName =
      TextEditingController(text: '@gmail.com');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(S.of(context).searchForUsers),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        children: [
          TextFieldWidget(
            maxLength: 28,
            ispassword: false,
            controller: _userName,
            lableName: S.of(context).searchForUsers,
            password: false,
            iconName: 'icons8-face.svg',
            textinput: TextInputType.name,
            autofocus: true,
            onChanged: (data) {
              setState(() {
                _userName.text.split('@').first = data;
                print('data: $data');
                print('data: ${_userName.text}');
                print('data: ${_userName.value.text}');
              });
              return null;
            },
            validator: (data) {
              if (data!.isEmpty) {
                return S.of(context).fieldIsRequired;
              } else if (data.length < 3) {
                return S.of(context).userNameIsShort;
              }
              return null;
            },
          ),
          _userName.value.text.length > 1
              ? StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('users').where(
                      'phoneNumber',
                      whereIn: [_userName.value.text]).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text(S.of(context).noUserFound));
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    } else {
                      return ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    child: OctoImage.fromSet(
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(snapshot
                                          .data!.docs[index]['profImg']),
                                      octoSet: OctoSet.circleAvatar(
                                        backgroundColor: Colors.grey,
                                        text: const Text(""),
                                      ),
                                      placeholderFadeInDuration:
                                          const Duration(seconds: 1),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Text(
                                      (snapshot.data!.docs[index])['username']),
                                ),
                                const Spacer(),
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatPage(
                                            uid: snapshot.data!.docs[index]
                                                ['uid'],
                                            fcToken: snapshot.data!.docs[index]
                                                ['fcToken'],
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.chat_rounded))
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(),
                        ),
                        itemCount: snapshot.data!.docs.length,
                      );
                    }
                  },
                )
              : Center(
                  child: Text(S.of(context).searchForNewUser),
                )
        ],
      ),
    );
  }
}
