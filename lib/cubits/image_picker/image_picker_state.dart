part of 'image_picker_cubit.dart';

enum ImageStatus {
  empty,
  loaded,
}

class ImagePickerState extends Equatable {
  final ImageStatus imageStatus;
  String? imagePath;
  ImagePickerState({
    required this.imageStatus,
    required this.imagePath,
  });

  factory ImagePickerState.initial() => ImagePickerState(
        imagePath: null,
        imageStatus: ImageStatus.empty,
      );

  @override
  List<Object?> get props => [imagePath];

  @override
  String toString() => 'ImagePickerState(imagePath: $imagePath)';

  ImagePickerState copyWith({
    ImageStatus? imageStatus,
    String? imagePath,
  }) {
    return ImagePickerState(
      imageStatus: imageStatus ?? this.imageStatus,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
