import 'package:zein_store/Future/Home/Cubits/getProducts/get_products_cubit.dart';
import 'package:zein_store/Future/Home/models/product_model.dart';
import 'package:zein_store/main.dart';
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
