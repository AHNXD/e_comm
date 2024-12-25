import 'package:e_comm/Future/Auth/Pages/login_screen.dart';
import 'package:e_comm/Future/Auth/Widgets/my_button_widget.dart';
import 'package:e_comm/Future/Auth/Widgets/text_field_widget.dart';
import 'package:e_comm/Future/Auth/cubit/auth_cubit.dart';
import 'package:e_comm/Future/Home/Widgets/custom_snak_bar.dart';
import 'package:e_comm/Future/Home/Widgets/home_screen/back_widget.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/Utils/colors.dart';
import 'package:e_comm/Utils/images.dart';
import 'package:e_comm/Utils/lottie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class SignupScreenTow extends StatelessWidget {
  SignupScreenTow({super.key});

  // final TextEditingController passwordController = TextEditingController();
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
          text: "signUp".tr(context),
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is RegisterSuccessfulState) {
            CustomSnackBar.showMessage(context, state.msg!, Colors.green);

            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (builder) {
              return LoginScreen();
            }));
          }
          if (state is RegisterErrorState) {
            CustomSnackBar.showMessage(context, state.message, Colors.red);
          }
          if (state is RegisterErrorState) {
            CustomSnackBar.showMessage(context, state.message, Colors.red);
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
                    "create_your_account".tr(context),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                TextFieldWidget(
                  controller: context.read<AuthCubit>().passwordController,
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

                state is RegisterLoadingState
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
                                  context
                                      .read<AuthCubit>()
                                      .passwordController
                                      .text) {
                            context.read<AuthCubit>().createAccount(
                                gender: context.read<AuthCubit>().genderState);
                          }
                        })
              ],
            ),
          );
        },
      ),
    );
  }
}
