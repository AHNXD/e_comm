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
  // SwitchStateWael swichState = SwitchStateWael.email;

  // set setSwitchState(SwitchStateWael s) {
  //   swichState = s;
  //   emit(SwitchState());
  // }

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
    emit(AuthLoadingState());

    try {
      await Network.postData(url: Urls.logInApi, data: {
        "email": email,
        "password": password,
      }).then((value) {
        if (value.data['status'] == true) {
          AppSharedPreferences.saveToken(value.data['data']);
        }
      });

      emit(AuthSuccessfulState());
    } catch (error) {
      if (error is DioException) {
        emit(
          AuthErrorState(
            exceptionsHandle(error: error),
          ),
        );
      } else {
        AuthErrorState(error.toString());
      }
    }
  }

  void checkForgetPassoword({required String emailOrPhoneNumber}) async {
    emit(AuthLoadingState());

    try {
      await Network.postData(
          url: Urls.logInApi,
          data: {"email": emailOrPhoneNumber}).then((value) {
        if (value.data['status'] == true) {
          AppSharedPreferences.saveToken(value.data['data']);
        }
      });

      emit(AuthSuccessfulState());
    } catch (error) {
      if (error is DioException) {
        emit(
          AuthErrorState(
            exceptionsHandle(error: error),
          ),
        );
      } else {
        emit(AuthErrorState(error.toString()));
      }
    }
  }

  void createAccount({
    required int gender,
  }) async {
    emit(AuthLoadingState());
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
            emit(AuthSuccessfulState(value.data["msg"]));
          } else {
            Map t = value.data["errors"];
            List l = [];
            l.add(value.data['status']);
            l.addAll(t.values);
            emit(AuthErrorState(l.toString()));
          }
        }
      });
    } catch (error) {
      if (error is DioException) {
        emit(
          AuthErrorState(
            exceptionsHandle(error: error),
          ),
        );
      } else {
        AuthErrorState(error.toString());
      }
    }
  }

  void emailForgetPassword({
    required String email,
  }) async {
    emit(AuthLoadingState());
    try {
      await Network.postData(url: Urls.forgetPassword, data: {
        "email": email,
      }).then((value) {
        // print(l);
        if ((value.statusCode == 200 || value.statusCode == 201)) {
          print(value.data['status']);
          if (value.data['status'] == true) {
            print(value.data["msg"]);
            emit(AuthSuccessfulState(value.data["msg"]));
          } else {
            Map t = value.data["message"];
            List l = [];
            l.add(value.data['status']);
            l.addAll(t.values);
            emit(AuthErrorState(l.toString()));
          }
        }
      });
    } catch (error) {
      if (error is DioException) {
        emit(
          AuthErrorState(
            exceptionsHandle(error: error),
          ),
        );
      } else {
        AuthErrorState(error.toString());
      }
    }
  }

  void resetPassword(
      {required String email,
      required String password,
      required String confirmPassword,
      required String otp}) async {
    emit(AuthLoadingState());
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
            emit(AuthSuccessfulState(value.data["msg"]));
          } else {
            Map t = value.data["message"];
            List l = [];
            l.add(value.data['status']);
            l.addAll(t.values);
            emit(AuthErrorState(l.toString()));
          }
        }
      });
    } catch (error) {
      if (error is DioException) {
        emit(
          AuthErrorState(
            exceptionsHandle(error: error),
          ),
        );
      } else {
        AuthErrorState(error.toString());
      }
    }
  }

  void veridicationCodeByCreateAccount(
      {required String otp, required String email}) async {
    emit(AuthLoadingState());
    try {
      await Network.postData(
          url: Urls.verificationCode,
          data: {"email": email, "otp": otp}).then((value) {
        if ((value.statusCode == 200 || value.statusCode == 201)) {
          AppSharedPreferences.saveToken(value.data['data']);
          emit(AuthSuccessfulState("the Account Created successfully"));
        }
      });
    } catch (error) {
      if (error is DioException) {
        emit(
          AuthErrorState(
            exceptionsHandle(error: error),
          ),
        );
      } else {
        AuthErrorState(error.toString());
      }
    }
  }

  void checkToken() async {
    emit(AuthLoadingState());
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
          AuthErrorState(
            exceptionsHandle(error: error),
          ),
        );
      } else {
        AuthErrorState(error.toString());
      }
    }
  }

  void logOut() async {
    emit(AuthLoadingState());
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
          AuthErrorState(
            exceptionsHandle(error: error),
          ),
        );
      } else {
        AuthErrorState(error.toString());
      }
    }
  }

  bool get getSignUpStateIsEmail {
    return _signUpState;
  }
}
