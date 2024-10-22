part of 'get_print_sizes_cubit.dart';

@immutable
sealed class GetPrintSizesState {}

final class GetPrintSizesInitial extends GetPrintSizesState {}

final class GetPrintSizesSuccess extends GetPrintSizesState {
  final List<PrintSizeData> printSizes;

  GetPrintSizesSuccess({required this.printSizes});
}
