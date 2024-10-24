import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../Apis/Network.dart';
import '../../../../Apis/Urls.dart';

part 'get_min_max_state.dart';

class GetMinMaxCubit extends Cubit<GetMinMaxState> {
  GetMinMaxCubit() : super(GetMinMaxInitial());
  String? minPrice;
  String? maxPrice;
  Future<void> getMinMax(int? gategoryId) async {
    var response =
        await Network.getData(url: "${Urls.getMinMax}?category=$gategoryId");
    if (response.statusCode == 200 || response.statusCode == 201) {
      minPrice = response.data['min'];
      maxPrice = response.data['max'];
      print("ttt$maxPrice");
      emit(GetMinMaxsuccess(maxPrice: maxPrice!, minPrice: minPrice!));
    }
  }
}
