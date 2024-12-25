import 'package:animate_do/animate_do.dart';
import 'package:e_comm/Future/Auth/Pages/login_screen.dart';
import 'package:e_comm/Future/Auth/Widgets/my_button_widget.dart';
import 'package:e_comm/Future/Auth/Widgets/text_field_widget.dart';
import 'package:e_comm/Future/Auth/cubit/auth_cubit.dart';
import 'package:e_comm/Future/Home/Widgets/custom_snak_bar.dart';
import 'package:e_comm/Future/Home/Widgets/home_screen/back_widget.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/Utils/colors.dart';
import 'package:e_comm/Utils/enums.dart';
import 'package:e_comm/Utils/lottie.dart';
import 'package:e_comm/Utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController emailOrPhoneNumberController =
      TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String value = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 7.h),
        child: BackWidget(
          canPop: true,
          hasBackButton: false,
          hasStyle: false,
          iconColor: Colors.black,
          textColor: Colors.black,
          text: "reset_password".tr(context),
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccessfulState) {
            CustomSnackBar.showMessage(context, state.msg!, Colors.green);

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (builder) {
                return LoginScreen();
              }),
              (route) => false,
            );
          }
          if (state is ResetPasswordErrorState) {
            CustomSnackBar.showMessage(context, state.message, Colors.red);
          }
        },
        builder: (context, state) {
          return Form(
            key: _key,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              children: [
                FadeInLeft(
                    duration: const Duration(milliseconds: 1500),
                    child: Text(
                      "verification_code_msg".tr(context),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color.fromRGBO(49, 39, 79, 1),
                        fontWeight: FontWeight.w400,
                        // fontSize: 30,
                        fontSize: 12.sp,
                      ),
                    )),
                SizedBox(
                  height: 3.h,
                ),
                FadeInLeft(
                    duration: const Duration(microseconds: 1700),
                    child: SizedBox(
                      height: 7.5.h,
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: OtpTextField(
                          onSubmit: (valu) {
                            setState(() {
                              value = valu;
                              print(value);
                            });
                          },
                          borderColor: AppColors.buttonCategoryColor,
                          fieldWidth: 15.w,
                          showFieldAsBox: true,
                          numberOfFields: 5,
                          borderRadius: BorderRadius.circular(5.w),
                        ),
                      ),
                    )),
                SizedBox(
                  height: 1.h,
                ),
                TextFieldWidget(
                  validatorFun: (p0) => validation(p0, ValidationState.normal),
                  text: "email".tr(context),
                  controller: emailOrPhoneNumberController,
                  isPassword: false,
                ),
                TextFieldWidget(
                  controller: passwordController,
                  text: "password".tr(context),
                  isPassword: true,
                ),
                SizedBox(
                  height: 2.h,
                ),
                TextFieldWidget(
                  controller: confirmPasswordController,
                  text: "confirm_password".tr(context),
                  isPassword: true,
                ),
                SizedBox(
                  height: 1.h,
                ),
                state is ResetPasswordLoadingState
                    ? Center(
                        child: Lottie.asset(LottieAssets.loadingAnimation1,
                            animate: true,
                            repeat: true,
                            height: 10.h,
                            fit: BoxFit.fill))
                    : MyButtonWidget(
                        color: AppColors.buttonCategoryColor,
                        verticalHieght: 0,
                        horizontalWidth: 0,
                        text: "next".tr(context),
                        onPressed: () {
                          if (value.isNotEmpty && value.length > 4) {
                            if (_key.currentState!.validate() &&
                                confirmPasswordController.text ==
                                    passwordController.text) {
                              context.read<AuthCubit>().resetPassword(
                                  email:
                                      emailOrPhoneNumberController.text.trim(),
                                  confirmPassword:
                                      confirmPasswordController.text.trim(),
                                  password: passwordController.text.trim(),
                                  otp: value);
                            } else {
                              CustomSnackBar.showMessage(
                                  context,
                                  "confirm_password_msg".tr(context),
                                  Colors.red);
                            }
                          } else {
                            CustomSnackBar.showMessage(context,
                                "ver_code_error".tr(context), Colors.red);
                          }
                        },
                      )
              ],
            ),
          );
        },
      ),
    );
  }
}
