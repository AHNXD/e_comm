import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:zein_store/Future/Auth/Pages/reset_password_screen.dart';
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

class ForgetPassword extends StatelessWidget {
  ForgetPassword({super.key});

  final TextEditingController emailOrPhoneNumberController =
      TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final AuthCubit cubit = AuthCubit();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: BlocProvider(
        create: (context) => cubit,
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is ForgetPasswordSuccessfulState) {
              CustomSnackBar.showMessage(
                  context, state.msg ?? "OTP Sent", Colors.green);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
              );
            } else if (state is ForgetPasswordErrorState) {
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
                    height: 35.h,
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
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5))
                              ]),
                          child: Image.asset(AppImagesAssets.logoNoBg,
                              height: 8.h),
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

                  // --- 3. Form Card ---
                  SingleChildScrollView(
                    padding: EdgeInsets.only(top: 32.h, left: 5.w, right: 5.w),
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
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _key,
                            child: Column(
                              children: [
                                Text(
                                  "forgot_password".tr(context),
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                ),
                                SizedBox(height: 3.h),
                                TextFieldWidget(
                                  validatorFun: (p0) =>
                                      validation(p0, ValidationState.normal),
                                  text: "email".tr(context),
                                  controller: emailOrPhoneNumberController,
                                  isPassword: false,
                                ),
                                SizedBox(height: 4.h),
                                state is ForgetPasswordLoadingState
                                    ? const Center(
                                        child:
                                            CustomCircularProgressIndicator())
                                    : MyButtonWidget(
                                        color: AppColors.buttonCategoryColor,
                                        text: "next".tr(context),
                                        icon: Icons.send_rounded,
                                        onPressed: () {
                                          if (_key.currentState!.validate()) {
                                            cubit.emailForgetPassword(
                                                email:
                                                    emailOrPhoneNumberController
                                                        .text
                                                        .trim());
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
      ),
    );
  }
}
