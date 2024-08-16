import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seen/global%20cubits/get_chat_data_and_messages_cubit/get_chat_data_and_messages_cubit.dart';
import 'package:seen/global%20cubits/screen_actions_cubit/screen_actions_cubit.dart';
import 'package:seen/screens/chat/cubits/messages_control_cubit/messages_control_cubit.dart';

import '../../../generated/l10n.dart';
import '../../../models/message_model.dart';
import 'message_bubble.dart';

class MessageBodyWidget extends StatefulWidget {
  const MessageBodyWidget({
    super.key,
    required this.anotherUserId,
    required this.chatId,
  });
  final String anotherUserId;
  final String chatId;

  @override
  State<MessageBodyWidget> createState() => _MessageBodyWidgetState();
}

class _MessageBodyWidgetState extends State<MessageBodyWidget> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  final List<Message> _messages = [];
  DocumentSnapshot? _lastDocument;

  @override
  void initState() {
    super.initState();
    _messages.clear();
    _loadInitialMessages();

    _scrollController.addListener(() {
      if (_scrollController.offset + 10 >=
              _scrollController.position.maxScrollExtent &&
          !_isLoadingMore) {
        _loadMoreMessages();
      }
    });
  }

  Future<void> _loadInitialMessages() async {
    _messages.clear();

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .orderBy('sentAt', descending: true)
        .limit(10)
        .get();

    setState(() {
      _messages.addAll(snapshot.docs.map((doc) {
        return Message.fromSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>);
      }).toList());
      _messages.sort((a, b) => a.sentAt!.compareTo(b.sentAt!));
      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
      }
    });
  }

  Future<void> _loadMoreMessages() async {
    if (_isLoadingMore || _lastDocument == null) return;

    setState(() {
      _isLoadingMore = true;
    });

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .orderBy('sentAt', descending: true)
        .startAfterDocument(_lastDocument!)
        .limit(10)
        .get();

    setState(() {
      _messages.addAll(snapshot.docs.map((doc) {
        return Message.fromSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>);
      }).toList());
      _messages.sort((a, b) => a.sentAt!.compareTo(b.sentAt!));
      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
      } else {
        _lastDocument = null; // No more messages to load
      }
      _isLoadingMore = false;
    });
  }

  Stream<QuerySnapshot> getMessages() {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .orderBy('sentAt', descending: true)
        .limit(10)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetChatDataAndMessagesCubit()
        ..getChatId(anotheUserUid: widget.anotherUserId),
      child: BlocListener<ScreenActionsCubit, ScreenActionsState>(
        listener: (context, state) {
          if (state is ScreenActionsGoToReplayMessage) {
            final position = _scrollController.position.maxScrollExtent *
                (state.indexOfmessage / _messages.length);
            _scrollController.animateTo(
              position,
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
            );
          }
        },
        child: Expanded(
          child: CustomScrollView(
            controller: _scrollController,
            // reverse: true,
            slivers: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc(widget.chatId)
                    .collection('messages')
                    .orderBy('sentAt', descending: true)
                    .limit(10)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()));
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return SliverFillRemaining(
                        child: Center(child: Text(S.of(context).noMessages)));
                  }

                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollController
                          .jumpTo(_scrollController.position.maxScrollExtent);
                    }
                  });
                  List<Message> messages = snapshot.data!.docs
                      .map((doc) => Message.fromSnapshot(
                          doc as DocumentSnapshot<Map<String, dynamic>>))
                      .toList();

                  messages.sort((a, b) => a.sentAt!.compareTo(b.sentAt!));

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: GestureDetector(
                            onTap: () {
                              final position =
                                  _scrollController.position.maxScrollExtent *
                                      (index / messages.length);
                              _scrollController.animateTo(
                                position,
                                duration: const Duration(seconds: 1),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: BlocProvider(
                              create: (context) => MessagesControlCubit(),
                              child: MessageBubble(
                                isLoading: false,
                                message: messages[index],
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: messages.length,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
