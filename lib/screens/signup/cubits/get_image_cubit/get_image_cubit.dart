import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'get_image_state.dart';

class GetImageCubit extends Cubit<GetImageState> {
  GetImageCubit() : super(GetImageInitial());

  void getImagePath(String path) {
    emit(GetImageSuccess(imagePath: path));
  }
  void deletImage() {
    emit(GetImageDelete());
  }
}
