import 'package:e_comm/Future/Auth/Pages/forget_password.dart';
import 'package:e_comm/Future/Auth/Pages/signup_screen.dart';
import 'package:e_comm/Future/Auth/Widgets/my_button_widget.dart';
import 'package:e_comm/Future/Auth/Widgets/text_field_widget.dart';
import 'package:e_comm/Future/Auth/cubit/auth_cubit.dart';
import 'package:e_comm/Future/Home/Pages/navbar_screen.dart';
import 'package:e_comm/Future/Home/Widgets/home_screen/back_widget.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/Utils/colors.dart';
import 'package:e_comm/Utils/enums.dart';
import 'package:e_comm/Utils/images.dart';
import 'package:e_comm/Utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final TextEditingController emailOrPhoneNumberController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
          text: "login".tr(context),
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is LoginSuccessfulState) {
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
                      "login_success".tr(context),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  duration: const Duration(seconds: 2)),
            );
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (builder) {
              return const NavBarPage();
            }));
          }
          if (state is LoginErrorState) {
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
            key: formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Image.asset(
                  AppImagesAssets.logoNoBg,
                  height: 15.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  child: Text(
                    "login_msg".tr(context),
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
                  validatorFun: (p0) =>
                      validation(p0, ValidationState.password),
                  controller: passwordController,
                  text: "password".tr(context),
                  isPassword: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (builder) {
                          return const SignupScreen();
                        }));
                      },
                      child: Text(
                        "create_account".tr(context),
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationThickness: 0.6,
                            decorationColor: AppColors.buttonCategoryColor,
                            color: AppColors.buttonCategoryColor,
                            fontSize: 12.sp),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (_) {
                          return ForgetPassword();
                        }));
                      },
                      child: Text(
                        "forgot_password".tr(context),
                        style: TextStyle(
                            decorationThickness: 0.6,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.buttonCategoryColor,
                            color: AppColors.buttonCategoryColor,
                            fontSize: 12.sp),
                      ),
                    ),
                  ],
                ),
                state is LoginLoadingState
                    ? const Center(child: CircularProgressIndicator())
                    : MyButtonWidget(
                        color: AppColors.buttonCategoryColor,
                        verticalHieght: 0,
                        horizontalWidth: 0,
                        text: "login".tr(context),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<AuthCubit>().login(
                                email: emailOrPhoneNumberController.text.trim(),
                                password: passwordController.text.trim());
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
