import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:octo_image/octo_image.dart';
import 'package:seen/Services/firestore_services.dart';
import 'package:seen/constanc.dart';
import 'package:seen/models/user_model.dart' as model;
import 'package:seen/screens/home/cubit/get_chats_cubit/get_chats_cubit.dart';
import 'package:seen/screens/search/page/search_page.dart';
import 'package:seen/global%20widgets/loading_widgets/chat_loading_widget.dart';
import 'package:seen/screens/home/widgets/show_another_user_info.dart';

import '../../../generated/l10n.dart';
import '../../chat/page/chat_page.dart';

class GetChatsBody extends StatefulWidget {
  const GetChatsBody({super.key});
  @override
  State<GetChatsBody> createState() => _GetChatsBodyState();
}

class _GetChatsBodyState extends State<GetChatsBody> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetChatsCubit>(context).fetchUserChats();

    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  List<String> usersProfurl = [
    "https://images.pexels.com/photos/3984963/pexels-photo-3984963.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "https://images.pexels.com/photos/810775/pexels-photo-810775.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "https://images.pexels.com/photos/2340978/pexels-photo-2340978.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "https://images.pexels.com/photos/1853353/pexels-photo-1853353.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
  ];
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      shrinkWrap: true,
      slivers: [
        BlocBuilder<GetChatsCubit, GetChatsState>(
          builder: (context, state) {
            if (state is FetchUserChatsLoading || state is DeleteChatLoading) {
              return const SliverToBoxAdapter(
                child: ChatLoadingWidget(),
              );
            } else if (state is FetchUserChatsSuccess) {
              if (state.chats.docs.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          S.of(context).searchForNewUser,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: SizedBox(
                            // width: 200,s
                            height: 50,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.all(3),
                                child: OctoImage.fromSet(
                                  width: 45,
                                  height: 45,
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(
                                    usersProfurl[index],
                                  ),
                                  octoSet: OctoSet.circleAvatar(
                                    backgroundColor: Colors.grey,
                                    text: const CircularProgressIndicator(),
                                  ),
                                  placeholderFadeInDuration:
                                      const Duration(seconds: 1),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton.icon(
                                  label: Text(S.of(context).discovering),
                                  onPressed: () {
                                    Navigator.pushNamed(context, Search.id);
                                  },
                                  icon: const Icon(Icons.search),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is DeleteChatSuccess) {
                BlocProvider.of<GetChatsCubit>(context).fetchUserChats();
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: state.chats.docs.length,
                  (context, index) {
                    final element = state.chats.docs[index];
                    final anotherUserUid = element['id']
                        .toString()
                        .split(' ')
                        .where((uid) =>
                            uid != FirebaseAuth.instance.currentUser!.uid)
                        .first
                        .toString();

                    return FutureBuilder<model.User>(
                      future: FireStoreService.getUserDataWithUid(
                        anotherUserUid: anotherUserUid,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const ChatLoadingWidget();
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        } else if (snapshot.hasData) {
                          return Column(
                            children: [
                              InkWell(
                                onLongPress: () async {
                                  final RenderBox overlay = Overlay.of(context)
                                      .context
                                      .findRenderObject() as RenderBox;
                                  final RenderBox itemBox =
                                      context.findRenderObject() as RenderBox;
                                  final Offset itemPosition =
                                      itemBox.localToGlobal(Offset.zero);

                                  final double screenWidth = overlay.size.width;
                                  const double menuWidth = 200;
                                  final double dx =
                                      (screenWidth - menuWidth) / 2;

                                  final selectedValue = await showMenu<String>(
                                    context: context,
                                    position: RelativeRect.fromLTRB(
                                      dx,
                                      itemPosition.dy - 50,
                                      dx + menuWidth,
                                      itemPosition.dy,
                                    ),
                                    items: <PopupMenuEntry<String>>[
                                      PopupMenuItem<String>(
                                        value: 'delete',
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text('حذف'),
                                            SvgPicture.asset(
                                              'assets/images/icons8-delete-48.svg',
                                              width: 25,
                                              color: Constanc.kSecondColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                  if (selectedValue == 'delete') {
                                    await BlocProvider.of<GetChatsCubit>(
                                            context)
                                        .deleteChat(chatId: element.id);
                                  }
                                },
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatPage(
                                        uid: snapshot.data!.uid,
                                        fcToken: snapshot.data!.fcToken,
                                      ),
                                    ),
                                  );
                                },
                                child: ShowAnotherUserInfo(
                                  user: snapshot.data!,
                                  showFinalMessage: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: Divider(
                                  color: Constanc.kColorGray,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Text(S.of(context).failure);
                        }
                      },
                    );
                  },
                ),
              );
            } else if (state is FetchUserChatsIsEmpty) {
              return SliverToBoxAdapter(
                child: Column(
                  children: [
                    Text(S.of(context).chatsNotFound),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Search.id);
                      },
                      child: Text(S.of(context).searchForNewUser),
                    ),
                  ],
                ),
              );
            } else if (state is FetchUserChatsFailure) {
              return SliverToBoxAdapter(
                child: Center(
                  child: Text(state.errMessage),
                ),
              );
            } else if (state is DeleteChatFailure) {
              return SliverToBoxAdapter(
                child: Center(
                  child: Text(state.errMessage),
                ),
              );
            } else {
              return SliverToBoxAdapter(
                child: Center(child: Text(S.of(context).failure)),
              );
            }
          },
        ),
      ],
    );
  }
}
