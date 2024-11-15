// ignore_for_file: avoid_print

import 'package:animate_do/animate_do.dart';
import 'package:e_comm/Future/Auth/Pages/reset_password_screen.dart';
import 'package:e_comm/Future/Auth/Widgets/my_button_widget.dart';
import 'package:e_comm/Future/Auth/cubit/auth_cubit.dart';
import 'package:e_comm/Future/Home/Pages/navbar_screen.dart';
import 'package:e_comm/Future/Home/Widgets/home_screen/back_widget.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/Utils/colors.dart';
import 'package:e_comm/Utils/lottie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen(
      {super.key, required this.prevScreen, required this.prvEmail});
  final String prevScreen;
  final String prvEmail;
  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
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
          text: widget.prevScreen == "forgetpassword"
              ? "verification_code".tr(context)
              : "signUp".tr(context),
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
            Navigator.of(context).push(MaterialPageRoute(builder: (builder) {
              if (widget.prevScreen == "forgetpassword") {
                return const ResetPasswordScreen();
              } else {
                return const NavBarPage();
              }
            }));
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
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // BuildTopAuth(width: width),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
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
                        )),
                    SizedBox(
                      height: 3.h,
                    ),
                    state is AuthLoadingState
                        ? Center(
                            child: Lottie.asset(LottieAssets.loadingAnimation1,
                                animate: true,
                                repeat: true,
                                height: 15.h,
                                fit: BoxFit.fill))
                        : MyButtonWidget(
                            color: AppColors.buttonCategoryColor,
                            verticalHieght: 0,
                            horizontalWidth: 4.w,
                            text: "next".tr(context),
                            onPressed: () {
                              if (value.isNotEmpty && value.length > 4) {
                                context
                                    .read<AuthCubit>()
                                    .veridicationCodeByCreateAccount(
                                        email: widget.prvEmail, otp: value);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "ver_code_error".tr(context))));
                              }
                            },
                          )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
