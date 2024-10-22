// ignore_for_file: depend_on_referenced_packages, unnecessary_import, avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:e_comm/Apis/ExceptionsHandle.dart';
import 'package:e_comm/Apis/Network.dart';
import 'package:e_comm/Apis/Urls.dart';
import 'package:e_comm/Future/Auth/Widgets/switch_text_widget.dart';
import 'package:e_comm/Utils/SharedPreferences/SharedPreferencesHelper.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:phone_form_field/phone_form_field.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState());
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final PhoneController? phoneNumberController = PhoneController();

  final TextEditingController addressController = TextEditingController();
  bool _signUpState = false;
  int genderState = 1; //male=1;fmale=0;
  SwitchStateWael swichState = SwitchStateWael.email;
  set setSwitchState(SwitchStateWael s) {
    swichState = s;
    emit(SwitchState());
  }

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
        "email_or_phone": email,
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
        AuthErrorState(error.toString());
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
        if (phoneNumberController!.value.nsn != "")
          "phone": phoneNumberController!.value.nsn.trim(),
        if (phoneNumberController!.value.nsn != "")
          "code": phoneNumberController!.value.countryCode,
        "address": addressController.text.trim(),
        "gender": gender,
        "password": passwordController.text.trim(),
        "password_confirmation": passwordController.text.trim(),
      }).then((value) {
        // print(l);
        if (value.data['success'] == false) {
          Map t = value.data["data"];
          List l = [];
          l.add(value.data['success']);
          l.addAll(t.values);
          emit(AuthErrorState(l.toString()));
        }
        print(value.data['status']);
        if (value.data['status'] == true) {
          print(value.data["msg"]);
          emit(AuthSuccessfulState(value.data["msg"]));
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
        if (value.data['success'] == false) {
          Map t = value.data["data"];
          List l = [];
          l.add(value.data['success']);
          l.addAll(t.values);
          emit(AuthErrorState(l.toString()));
        }
        print(value.data['status']);
        if (value.data['status'] == true) {
          print(value.data["msg"]);
          emit(AuthSuccessfulState(value.data["msg"]));
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
      required String confirmPassword}) async {
    emit(AuthLoadingState());
    try {
      await Network.postData(url: Urls.resetPassword, data: {
        "email": email,
        "password": password,
        "password_confirmation": confirmPassword,
        "token": AppSharedPreferences.getToken,
      }).then((value) {
        if (value.data['success'] == false) {
          Map t = value.data["data"];
          List l = [];
          l.add(value.data['success']);
          l.addAll(t.values);
          emit(AuthErrorState(l.toString()));
        }
        print(value.data['status']);
        if (value.data['status'] == true) {
          print(value.data["msg"]);
          emit(AuthSuccessfulState(value.data["msg"]));
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
        if (value.statusCode == 200 || value.statusCode == 201) {
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

  void logOut() async {
    emit(AuthLoadingState());
    try {
      await Network.postData(url: Urls.verificationCode, data: {})
          .then((value) {
        if (value.statusCode == 200 || value.statusCode == 201) {
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

  bool get getSignUpStateIsEmail {
    return _signUpState;
  }
}
