import 'package:e_comm/Future/Auth/Pages/login_screen.dart';
import 'package:e_comm/Future/Auth/Widgets/my_button_widget.dart';
import 'package:e_comm/Future/Auth/Widgets/text_field_widget.dart';
import 'package:e_comm/Future/Auth/cubit/auth_cubit.dart';
import 'package:e_comm/Future/Home/Widgets/home_screen/back_widget.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/Utils/colors.dart';
import 'package:e_comm/Utils/enums.dart';
import 'package:e_comm/Utils/images.dart';
import 'package:e_comm/Utils/lottie.dart';
import 'package:e_comm/Utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailOrPhoneNumberController =
      TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

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
          if (state is AuthSuccessfulState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  content: Container(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    decoration: BoxDecoration(
                        color: Colors.green[400],
                        borderRadius: BorderRadius.circular(2.w)),
                    margin: EdgeInsets.symmetric(horizontal: 0.1.w),
                    child: Text(
                      state.msg!,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  duration: const Duration(seconds: 5)),
            );
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (builder) {
                return LoginScreen();
              }),
              (route) => false,
            );
          }
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(state.message),
                  duration: const Duration(seconds: 2)),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: _key,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              children: [
                SizedBox(
                  height: 10.h,
                ),
                // FlutterLogo(
                //   size: 15.h,
                // ),
                Image.asset(
                  AppImagesAssets.logoNoBg,
                  height: 15.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  child: Text(
                    "reset_password".tr(context),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                TextFieldWidget(
                  validatorFun: (p0) => validation(p0, ValidationState.normal),
                  text: "emailOrPhone".tr(context),
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
                  height: 2.h,
                ),
                state is AuthLoadingState
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
                          if (_key.currentState!.validate() &&
                              confirmPasswordController.text ==
                                  passwordController.text) {
                            context.read<AuthCubit>().resetPassword(
                                email: emailOrPhoneNumberController.text.trim(),
                                confirmPassword:
                                    confirmPasswordController.text.trim(),
                                password: passwordController.text.trim());
                            // Navigator.of(context).pushAndRemoveUntil(
                            //   MaterialPageRoute(builder: (builder) {
                            //     return LoginScreen();
                            //   }),
                            //   (route) => false,
                            // );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text("confirm_password_msg".tr(context))));
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
