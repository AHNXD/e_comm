import 'package:bloc/bloc.dart';
import 'package:e_comm/Apis/Network.dart';
import 'package:e_comm/Apis/Urls.dart';
import 'package:e_comm/Future/Home/models/print_size_model.dart';
import 'package:meta/meta.dart';

part 'get_print_sizes_state.dart';

class GetPrintSizesCubit extends Cubit<GetPrintSizesState> {
  GetPrintSizesCubit() : super(GetPrintSizesInitial());

  Future<void> getPrintSizes() async {
    var response = await Network.getData(url: Urls.getPrintSizes);
    if (response.statusCode == 200 || response.statusCode == 201) {
      PrintSizeModel printSizeModel = PrintSizeModel.fromJson(response.data);

      emit(GetPrintSizesSuccess(printSizes: printSizeModel.data!));
    }
  }
}