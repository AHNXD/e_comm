part of 'range_slider_cubit.dart';

@immutable
sealed class RangeSliderState {}

final class RangeSliderInitial extends RangeSliderState {}

final class RangeSliderSuccessfulState extends RangeSliderState {}

final class RangeSliderErrorState extends RangeSliderState {
  final String message;
  RangeSliderErrorState(this.message);
}

final class RangeSliderLoadingState extends RangeSliderState {}
