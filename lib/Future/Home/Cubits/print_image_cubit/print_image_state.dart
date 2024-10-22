part of 'print_image_cubit.dart';

@immutable
sealed class PrintImageState {}

final class PrintImageInitial extends PrintImageState {}

class PrintImageSuccess extends PrintImageState {
  final String msg;

  PrintImageSuccess({required this.msg});
}

class PrintImageError extends PrintImageState {
  final String error;

  PrintImageError({required this.error});
}
