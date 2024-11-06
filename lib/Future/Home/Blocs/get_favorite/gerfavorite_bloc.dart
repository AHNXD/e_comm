import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'gerfavorite_event.dart';
part 'gerfavorite_state.dart';

class GerfavoriteBloc extends Bloc<GerfavoriteEvent, GerfavoriteState> {
  GerfavoriteBloc() : super(GerfavoriteInitial()) {
    on<GerfavoriteEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
