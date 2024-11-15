import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../../../Apis/ExceptionsHandle.dart';
import '../../../../Apis/Network.dart';
import '../../../../Apis/Urls.dart';
import '../../../../Utils/SharedPreferences/SharedPreferencesHelper.dart';

part 'delete_profile_state.dart';

class DeleteProfileCubit extends Cubit<DeleteProfileState> {
  DeleteProfileCubit() : super(DeleteProfileInitial());

  Future<void> deleteProfile() async {
    try {
      var response = await Network.postData(url: Urls.deleteProfile);
      if (response.statusCode == 200 || response.statusCode == 201) {
        AppSharedPreferences.removeToken();
        emit(DeleteProfileSuccess(msg: response.data['msg']));
      }
    } catch (error) {
      if (error is DioException) {
        emit(DeleteProfileError(msg: exceptionsHandle(error: error)));
      } else {
        emit(DeleteProfileError(msg: error.toString()));
      }
    }
  }
}
