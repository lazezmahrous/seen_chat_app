part of 'network_conectivty_cubit.dart';

@immutable
sealed class NetworkConectivtyState {}

final class NetworkConectivtyInitial extends NetworkConectivtyState {}
final class NetworkConectivtyTrue extends NetworkConectivtyState {}
final class NetworkConectivtyFalse extends NetworkConectivtyState {}
