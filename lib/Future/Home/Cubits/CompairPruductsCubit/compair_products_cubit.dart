import 'package:e_comm/Future/Home/Cubits/getProducts/get_products_cubit.dart';
import 'package:e_comm/Future/Home/models/product_model.dart';
import 'package:e_comm/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'compair_products_state.dart';

class CompairProductsCubit extends Cubit<CompairProductsState> {
  CompairProductsCubit() : super(CompairProductsInitial());
  MainProduct productOne =
      BlocProvider.of<GetProductsCubit>(scaffoldKey.currentState!.context)
          .model!
          .data!
          .first;
  MainProduct productTwo =
      BlocProvider.of<GetProductsCubit>(scaffoldKey.currentState!.context)
          .model!
          .data!
          .elementAt(1);
  void changeProduct(MainProduct p, int i) {
    if (i == 1) {
      productOne = p;
    }
    if (i == 2) {
      productTwo = p;
    }
    emit(CompairProducts());
  }
}
