part of 'get_image_cubit.dart';

@immutable
sealed class GetImageState {}

final class GetImageInitial extends GetImageState {}
final class GetImageSuccess extends GetImageState {
  final String imagePath;
  GetImageSuccess({required this.imagePath});
}
final class GetImageDelete extends GetImageState {}
