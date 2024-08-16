part of 'replay_messages_cubit.dart';

@immutable
sealed class ReplayMessagesState {}

final class ReplayMessagesInitial extends ReplayMessagesState {}

final class GetReplayMessageLoading extends ReplayMessagesState {}

final class GetReplayMessageSuccesss extends ReplayMessagesState {
  final Message message;

  GetReplayMessageSuccesss({required this.message});
}

final class GetReplayMessageFailure extends ReplayMessagesState {}


final class DeleteReplayWidget extends ReplayMessagesState {}
