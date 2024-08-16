part of 'messages_control_cubit.dart';

@immutable
sealed class MessagesControlState {}

final class MessagesControlInitial extends MessagesControlState {}

final class DeleteMessageLoading extends MessagesControlState {}

final class DeleteMessageSuccess extends MessagesControlState {}

final class DeleteMessageFailure extends MessagesControlState {}

final class TranslateMessageLoading extends MessagesControlState {}

final class TranslateMessageSuccess extends MessagesControlState {
  final String newMessage;
  TranslateMessageSuccess({required this.newMessage});
}
final class TranslateMessageFailure extends MessagesControlState {}
final class DeleteTranslateMessage extends MessagesControlState {}
