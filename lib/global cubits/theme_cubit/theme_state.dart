part of 'theme_cubit.dart';

@immutable
sealed class ThemeState {}

final class ThemeInitial extends ThemeState {
  final ThemeData initialTheme;
  ThemeInitial({required this.initialTheme});
}
final class SavedTheme extends ThemeState {
  final String savedTheme;
  SavedTheme({required this.savedTheme});
}


