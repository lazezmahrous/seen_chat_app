part of 'get_chats_cubit.dart';

@immutable
sealed class GetChatsState {}

final class GetChatsInitial extends GetChatsState {}

// get chats body start
final class FetchUserChatsLoading extends GetChatsState {}

final class FetchUserChatsSuccess extends GetChatsState {
  final QuerySnapshot<Map<String, dynamic>> chats;
  FetchUserChatsSuccess({required this.chats});
}

final class FetchUserChatsIsEmpty extends GetChatsState {}

final class FetchUserChatsFailure extends GetChatsState {
  final String errMessage;
  FetchUserChatsFailure({required this.errMessage});
}

final class GetDataOfAnotherUsersOfchatsLoading extends GetChatsState {}

final class GetDataOfAnotherUsersOfchatsSuccess extends GetChatsState {
  final model.User userData;
  GetDataOfAnotherUsersOfchatsSuccess({required this.userData});
}

final class GetDataOfAnotherUsersOfchatsFailure extends GetChatsState {
  final String errMessage;
  GetDataOfAnotherUsersOfchatsFailure({required this.errMessage});
}

// get chats body end

// delete chats by id start
final class DeleteChatLoading extends GetChatsState {}
final class DeleteChatSuccess extends GetChatsState {}
final class DeleteChatFailure extends GetChatsState {
  final String errMessage;
  DeleteChatFailure({required this.errMessage});
}
// delete chats by id end
