part of 'send_message_cubit.dart';

@immutable
sealed class SendMessageState {}

final class SendMessageInitial extends SendMessageState {}

final class SendMessageLoading extends SendMessageState {
  final Message message;

  SendMessageLoading({required this.message});
}

final class SendMessageSuccess extends SendMessageState {
  final Message message;

  SendMessageSuccess({required this.message});
}

final class SendMessageFailure extends SendMessageState {
  final String errMessage;
  Message? message;

  SendMessageFailure({required this.errMessage,  this.message});
}
