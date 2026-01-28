import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:sizer/sizer.dart';
import 'package:zein_store/Future/Auth/Pages/login_screen.dart';
import 'package:zein_store/Future/Auth/Widgets/my_button_widget.dart';
import 'package:zein_store/Future/Auth/Widgets/text_field_widget.dart';
import 'package:zein_store/Future/Auth/cubit/auth_cubit.dart';
import 'package:zein_store/Future/Home/Widgets/custom_circular_progress_indicator.dart';
import 'package:zein_store/Future/Home/Widgets/custom_snak_bar.dart';
import 'package:zein_store/Utils/app_localizations.dart';
import 'package:zein_store/Utils/colors.dart';
import 'package:zein_store/Utils/images.dart';
import 'package:zein_store/Utils/validation.dart';

import '../../../Utils/enums.dart';

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
  String otpValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccessfulState) {
            CustomSnackBar.showMessage(
                context, state.msg ?? "Password Reset!", Colors.green);
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => LoginScreen()),
              (route) => false,
            );
          }
          if (state is ResetPasswordErrorState) {
            CustomSnackBar.showMessage(context, state.message, Colors.red);
          }
        },
        builder: (context, state) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: [
                // --- 1. Top Header ---
                Container(
                  height: 30.h,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColors,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 2.h),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10)
                            ]),
                        child:
                            Image.asset(AppImagesAssets.logoNoBg, height: 6.h),
                      ),
                      SizedBox(height: 2.h),
                    ],
                  ),
                ),

                // --- 2. Back Button ---
                Positioned(
                  top: 5.h,
                  left: 4.w,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white),
                  ),
                ),

                // --- 3. Form Section ---
                SingleChildScrollView(
                  padding: EdgeInsets.only(
                      top: 25.h, left: 5.w, right: 5.w, bottom: 5.h),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10)),
                          ],
                        ),
                        child: Form(
                          key: _key,
                          child: Column(
                            children: [
                              // OTP Section
                              Text(
                                "verification_code_msg".tr(context),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 10.sp,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: OtpTextField(
                                  onSubmit: (val) =>
                                      setState(() => otpValue = val),
                                  onCodeChanged: (val) => otpValue = val,
                                  borderColor: AppColors.buttonCategoryColor,
                                  focusedBorderColor:
                                      AppColors.buttonCategoryColor,
                                  fieldWidth: 12.w,
                                  showFieldAsBox: true,
                                  numberOfFields: 5,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),

                              SizedBox(height: 3.h),
                              const Divider(),
                              SizedBox(height: 2.h),

                              // Fields
                              TextFieldWidget(
                                validatorFun: (p0) =>
                                    validation(p0, ValidationState.normal),
                                text: "email".tr(context),
                                controller: emailOrPhoneNumberController,
                                isPassword: false,
                              ),
                              TextFieldWidget(
                                controller: passwordController,
                                text: "password".tr(context), // "password"
                                isPassword: true,
                              ),
                              TextFieldWidget(
                                controller: confirmPasswordController,
                                text: "confirm_password".tr(context),
                                isPassword: true,
                              ),

                              SizedBox(height: 4.h),

                              // Submit
                              state is ResetPasswordLoadingState
                                  ? const Center(
                                      child: CustomCircularProgressIndicator())
                                  : MyButtonWidget(
                                      color: AppColors.buttonCategoryColor,
                                      text: "next".tr(context),
                                      icon: Icons.lock_reset_rounded,
                                      onPressed: () {
                                        if (otpValue.length >= 5) {
                                          if (_key.currentState!.validate() &&
                                              confirmPasswordController.text ==
                                                  passwordController.text) {
                                            context.read<AuthCubit>().resetPassword(
                                                email:
                                                    emailOrPhoneNumberController
                                                        .text
                                                        .trim(),
                                                confirmPassword:
                                                    confirmPasswordController
                                                        .text
                                                        .trim(),
                                                password: passwordController
                                                    .text
                                                    .trim(),
                                                otp: otpValue);
                                          } else {
                                            CustomSnackBar.showMessage(
                                                context,
                                                "confirm_password_msg"
                                                    .tr(context),
                                                Colors.red);
                                          }
                                        } else {
                                          CustomSnackBar.showMessage(
                                              context,
                                              "ver_code_error".tr(context),
                                              Colors.red);
                                        }
                                      },
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
