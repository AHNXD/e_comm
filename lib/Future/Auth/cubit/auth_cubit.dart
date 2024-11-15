// ignore_for_file: depend_on_referenced_packages, unnecessary_import, avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:e_comm/Apis/ExceptionsHandle.dart';
import 'package:e_comm/Apis/Network.dart';
import 'package:e_comm/Apis/Urls.dart';
import 'package:e_comm/Utils/SharedPreferences/SharedPreferencesHelper.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:phone_form_field/phone_form_field.dart';

import '../../../Utils/constants.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState());
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final PhoneController? phoneNumberController = PhoneController(
      initialValue: const PhoneNumber(isoCode: IsoCode.SY, nsn: ""));
  final TextEditingController addressController = TextEditingController();

  bool _signUpState = false;
  int genderState = 1; //male=1;fmale=0;

  set setSignUpStatusIsEmail(bool isEmail) {
    _signUpState = isEmail;
    emit(SignUpState());
  }

  set setSignUpStatusIsMail(int isMail) {
    genderState = isMail;
    emit(GenderState());
  }

  void login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoadingState());

    try {
      await Network.postData(url: Urls.logInApi, data: {
        "email": email,
        "password": password,
      }).then((value) {
        if (value.data['status'] == true) {
          AppSharedPreferences.saveToken(value.data['data']);
        }
      });

      emit(LoginSuccessfulState());
    } catch (error) {
      if (error is DioException) {
        emit(
          LoginErrorState(
            exceptionsHandle(error: error),
          ),
        );
      } else {
        LoginErrorState(error.toString());
      }
    }
  }

  void createAccount({
    required int gender,
  }) async {
    emit(RegisterLoadingState());
    try {
      await Network.postData(url: Urls.registerApi, data: {
        "first_name": firstNameController.text.trim(),
        "last_name": lastNameController.text.trim(),
        "email": emailController.text.trim(),
        "phone":
            "+${phoneNumberController!.value.countryCode.trim()}${phoneNumberController!.value.nsn.trim()}",
        "address": addressController.text.trim(),
        "gender": gender,
        "password": passwordController.text.trim(),
        "password_confirmation": passwordController.text.trim(),
      }).then((value) {
        if ((value.statusCode == 200 || value.statusCode == 201)) {
          print(value.data['status']);
          if (value.data['status'] == true) {
            print(value.data["msg"]);
            emit(RegisterSuccessfulState(value.data["msg"]));
          } else {
            Map t = value.data["errors"];
            List l = [];
            l.add(value.data['status']);
            l.addAll(t.values);
            emit(RegisterErrorState(l.toString()));
          }
        }
      });
    } catch (error) {
      if (error is DioException) {
        emit(
          RegisterErrorState(
            exceptionsHandle(error: error),
          ),
        );
      } else {
        RegisterErrorState(error.toString());
      }
    }
  }

  void emailForgetPassword({
    required String email,
  }) async {
    emit(ForgetPasswordLoadingState());
    try {
      await Network.postData(url: Urls.forgetPassword, data: {
        "email": email,
      }).then((value) {
        // print(l);
        if ((value.statusCode == 200 || value.statusCode == 201)) {
          print(value.data['status']);
          if (value.data['status'] == true) {
            print(value.data["msg"]);
            emit(ForgetPasswordSuccessfulState(value.data["msg"]));
          } else {
            Map t = value.data["message"];
            List l = [];
            l.add(value.data['status']);
            l.addAll(t.values);
            emit(ForgetPasswordErrorState(l.toString()));
          }
        }
      });
    } catch (error) {
      if (error is DioException) {
        emit(
          ForgetPasswordErrorState(
            exceptionsHandle(error: error),
          ),
        );
      } else {
        ForgetPasswordErrorState(error.toString());
      }
    }
  }

  void resetPassword(
      {required String email,
      required String password,
      required String confirmPassword,
      required String otp}) async {
    emit(ResetPasswordLoadingState());
    try {
      await Network.postData(url: Urls.resetPassword, data: {
        "email": email,
        "password": password,
        "password_confirmation": confirmPassword,
        "token": otp,
      }).then((value) {
        if ((value.statusCode == 200 || value.statusCode == 201)) {
          print(value.data['status']);
          if (value.data['status'] == true) {
            print(value.data["msg"]);
            emit(ResetPasswordSuccessfulState(value.data["msg"]));
          } else {
            Map t = value.data["message"];
            List l = [];
            l.add(value.data['status']);
            l.addAll(t.values);
            emit(ResetPasswordErrorState(l.toString()));
          }
        }
      });
    } catch (error) {
      if (error is DioException) {
        emit(
          ResetPasswordErrorState(
            exceptionsHandle(error: error),
          ),
        );
      } else {
        ResetPasswordErrorState(error.toString());
      }
    }
  }

  void checkToken() async {
    emit(TokenLoadingState());
    final String fullToken = AppSharedPreferences.getToken;

    final String token = fullToken.split('|').last;
    print(token);
    try {
      await Network.postData(url: Urls.checkToken, data: {"token": token})
          .then((value) {
        if (value.statusCode == 200 || value.statusCode == 201) {
          if (value.data["status"]) {
            if (value.data["IsValid"]) {
              emit(IsVaildToken());
            } else {
              emit(IsNotVaildToken());
            }
          } else {
            emit(IsNotVaildToken());
          }
        }
      });
    } catch (error) {
      if (error is DioException) {
        emit(
          TokenErrorState(
            exceptionsHandle(error: error),
          ),
        );
      } else {
        TokenErrorState(error.toString());
      }
    }
  }

  void logOut() async {
    emit(LogoutLoadingState());
    try {
      await Network.postData(
        url: Urls.logout,
      ).then((value) {
        if (value.statusCode == 200 || value.statusCode == 201) {
          AppSharedPreferences.removeToken();
          emit(LogoutSuccessState(
              message: lang == 'en'
                  ? "You have successfully logged out"
                  : "لقد قمت بتسجيل الخروج بنجاح"));
        }
      });
    } catch (error) {
      if (error is DioException) {
        emit(
          LogoutErrorState(
            exceptionsHandle(error: error),
          ),
        );
      } else {
        LogoutErrorState(error.toString());
      }
    }
  }

  bool get getSignUpStateIsEmail {
    return _signUpState;
  }
}
