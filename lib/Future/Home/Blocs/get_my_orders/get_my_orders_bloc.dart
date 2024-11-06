import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_my_orders_event.dart';
part 'get_my_orders_state.dart';

class GetMyOrdersBloc extends Bloc<GetMyOrdersEvent, GetMyOrdersState> {
  GetMyOrdersBloc() : super(GetMyOrdersInitial()) {
    on<GetMyOrdersEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
