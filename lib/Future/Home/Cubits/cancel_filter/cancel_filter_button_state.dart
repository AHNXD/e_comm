part of 'cancel_filter_button_cubit.dart';

sealed class CancelFilterButtonState extends Equatable {
  const CancelFilterButtonState();

  @override
  List<Object> get props => [];
}

final class CancelFilterButtonInitial extends CancelFilterButtonState {}

final class CancelFilterButtonIsFiltter extends CancelFilterButtonState {}

final class CancelFilterButtonIsNotFillter extends CancelFilterButtonState {}
