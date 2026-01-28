import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

import '../../../Utils/enums.dart'; // Ensure validation is imported

class SignupScreenTow extends StatelessWidget {
  SignupScreenTow({super.key});

  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is RegisterSuccessfulState) {
            CustomSnackBar.showMessage(
                context, state.msg ?? "Success", Colors.green);
            // Navigate to Login and remove all previous routes
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false);
          } else if (state is RegisterErrorState) {
            CustomSnackBar.showMessage(context, state.message, Colors.red);
          }
        },
        builder: (context, state) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: [
                // --- 1. Top Background Decoration ---
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
                        child: Image.asset(
                          AppImagesAssets.logoNoBg,
                          height: 10.h,
                        ),
                      ),
                      SizedBox(height: 2.h),
                    ],
                  ),
                ),

                // --- 2. Form Section ---
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
                              // Password Field
                              TextFieldWidget(
                                validatorFun: (val) =>
                                    validation(val, ValidationState.password),
                                controller: context
                                    .read<AuthCubit>()
                                    .passwordController,
                                text: "password".tr(context),
                                isPassword: true,
                              ),

                              // Confirm Password Field
                              TextFieldWidget(
                                validatorFun: (val) {
                                  if (val !=
                                      context
                                          .read<AuthCubit>()
                                          .passwordController
                                          .text) {
                                    return "Passwords do not match";
                                  }
                                  return validation(
                                      val, ValidationState.password);
                                },
                                controller: confirmPasswordController,
                                text: "confirm_password".tr(context),
                                isPassword: true,
                              ),

                              SizedBox(height: 4.h),

                              // Submit Button
                              state is RegisterLoadingState
                                  ? const Center(
                                      child: CustomCircularProgressIndicator())
                                  : MyButtonWidget(
                                      color: AppColors.buttonCategoryColor,
                                      text: "Create Account"
                                          .tr(context), // "signUp"
                                      icon: Icons.check_circle_outline,
                                      onPressed: () {
                                        if (_key.currentState!.validate()) {
                                          context
                                              .read<AuthCubit>()
                                              .createAccount(
                                                  gender: context
                                                      .read<AuthCubit>()
                                                      .genderState);
                                        }
                                      },
                                    ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 3.h),

                      // Back Navigation
                      TextButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back,
                            size: 14.sp, color: Colors.grey[600]),
                        label: Text(
                          "",
                          style: TextStyle(
                              color: Colors.grey[600], fontSize: 11.sp),
                        ),
                      )
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
