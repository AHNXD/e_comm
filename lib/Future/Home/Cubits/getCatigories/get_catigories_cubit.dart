import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../../Utils/functions.dart';
import '/Apis/ExceptionsHandle.dart';
import '/Apis/Network.dart';
import '/Apis/Urls.dart';
import '/Future/Home/models/catigories_model.dart';

part 'get_catigories_state.dart';

class GetCatigoriesCubit extends Cubit<GetCatigoriesState> {
  GetCatigoriesCubit() : super(GetCatigoriesInitial());
  CatigoriesModel? catigoriesModel;
  List<CatigoriesData> homeData = [];
  int? categoryId;
  void setId(int cid) {
    categoryId = cid;
    emit(SetIdState());
  }

  void getCatigories() async {
    emit(GetCatigoriesLoadingState());
    try {
      await Network.getData(url: Urls.getCatigories).then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          catigoriesModel = CatigoriesModel.fromJson(response.data);
          homeData = getMainCategoryByParentId(catigoriesModel!);
          emit(GetCatigoriesSuccessfulState());
        }
      });
    } catch (error) {
      if (error is DioException) {
        emit(
          GetCatigoriesErrorState(
            exceptionsHandle(error: error),
          ),
        );
      } else {
        GetCatigoriesErrorState(error.toString());
      }
    }
  }
}
