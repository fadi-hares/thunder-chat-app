import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thunder_chat_app/repo/auth_repo.dart';

part 'image_picker_state.dart';

class ImagePickerCubit extends Cubit<ImagePickerState> {
  final AuthRepo authRepo;
  ImagePickerCubit({required this.authRepo})
      : super(ImagePickerState.initial());

  Future<void> pickImage() async {
    final String? imagePath = await authRepo.pickImage();
    if (imagePath != null) {
      emit(state.copyWith(
          imagePath: imagePath, imageStatus: ImageStatus.loaded));
    } else {
      emit(state.copyWith(imagePath: null, imageStatus: ImageStatus.empty));
    }
  }
}
