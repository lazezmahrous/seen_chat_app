import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seen/global cubits/screen_actions_cubit/screen_actions_cubit.dart';
import 'package:seen/models/message_model.dart';

part 'replay_messages_state.dart';

class ReplayMessagesCubit extends Cubit<ReplayMessagesState> {
  ReplayMessagesCubit() : super(ReplayMessagesInitial());

  void getMessageToReplay(
      {required Message message, required BuildContext context}) {
    emit(GetReplayMessageLoading());
    try {
      BlocProvider.of<ScreenActionsCubit>(context).openKeyboard();

      emit(GetReplayMessageSuccesss(message: message));
    } catch (e) {
      emit(GetReplayMessageFailure());
    }
  }

  void deleteReplayWidget() {
    emit(DeleteReplayWidget());
  }
}
