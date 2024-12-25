import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:zein_store/Apis/ExceptionsHandle.dart';
import 'package:zein_store/Apis/Network.dart';
import 'package:zein_store/Future/Home/models/user_model.dart';
import 'package:equatable/equatable.dart';

import '../../../../Apis/Urls.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitial());

  Future<void> editProfile(UserProfile userProfile) async {
    try {
      final formData = userProfile.toJson();
      final response =
          await Network.postData(url: Urls.editProfile, data: formData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(EditProfileSuccess(msg: response.data['msg']));
      }
    } catch (error) {
      if (error is DioException) {
        emit(EditProfileError(msg: exceptionsHandle(error: error)));
      } else {
        emit(EditProfileError(msg: error.toString()));
      }
    }
  }

  void resetToInintState() {
    emit(EditProfileInitial());
  }
}
