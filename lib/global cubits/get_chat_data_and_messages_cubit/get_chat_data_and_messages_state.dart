part of 'get_chat_data_and_messages_cubit.dart';

@immutable
sealed class GetChatDataAndMessagesState {}

final class GetChatDataAndMessagesInitial extends GetChatDataAndMessagesState {}

final class GetChatIdSuccess extends GetChatDataAndMessagesState {
  final String chatId;
  GetChatIdSuccess({required this.chatId});
}
final class GetChatIdLoading extends GetChatDataAndMessagesState {
}
final class GetChatIdFailure extends GetChatDataAndMessagesState {
}
