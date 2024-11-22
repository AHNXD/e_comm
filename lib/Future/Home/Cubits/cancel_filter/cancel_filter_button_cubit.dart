import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'cancel_filter_button_state.dart';

class CancelFilterButtonCubit extends Cubit<CancelFilterButtonState> {
  CancelFilterButtonCubit() : super(CancelFilterButtonInitial());
  bool isFilter = false;
  void setIsFilter() {
    isFilter = true;
    emit(CancelFilterButtonIsFiltter());
  }

  void setCancelFilter() {
    isFilter = false;
    emit(CancelFilterButtonIsNotFillter());
  }
}
