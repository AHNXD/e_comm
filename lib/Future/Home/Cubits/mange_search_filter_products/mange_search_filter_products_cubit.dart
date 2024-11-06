import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'mange_search_filter_products_state.dart';

class MangeSearchFilterProductsCubit
    extends Cubit<MangeSearchFilterProductsState> {
  MangeSearchFilterProductsCubit() : super(MangeSearchFilterProductsInitial());
  bool isSearchProducts = false;
  bool isFilterProducts = false;
  String? searchText;
  double? min;
  double? max;
}
