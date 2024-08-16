import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';

part 'network_conectivty_state.dart';

class NetworkConectivtyCubit extends Cubit<NetworkConectivtyState> {
  NetworkConectivtyCubit() : super(NetworkConectivtyInitial());

  void networkBack() {
    emit(NetworkConectivtyTrue());
  }

  void networkLost() {
    emit(NetworkConectivtyFalse());
  }
}
