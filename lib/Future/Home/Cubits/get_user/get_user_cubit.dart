import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:e_comm/Apis/ExceptionsHandle.dart';
import 'package:e_comm/Future/Home/models/user_model.dart';
import 'package:equatable/equatable.dart';

import '../../../../Apis/Network.dart';
import '../../../../Apis/Urls.dart';

part 'get_user_state.dart';

class GetUserCubit extends Cubit<GetUserState> {
  GetUserCubit() : super(GetUserInitial());
  UserProfile? userProfile;
  void getUserProfile() async {
    emit(GetUserLoadin());
    try {
      var response = await Network.getData(url: Urls.getUser);
      if (response.statusCode == 200 || response.statusCode == 201) {
        User user = User.fromJson(response.data);
        userProfile = user.data;
        emit(GetUserSuccess(userProfile: user.data!));
      }
    } catch (error) {
      if (error is DioException) {
        emit(GetUserErorre(msg: exceptionsHandle(error: error)));
      } else {
        emit(GetUserErorre(msg: error.toString()));
      }
    }
  }
}
