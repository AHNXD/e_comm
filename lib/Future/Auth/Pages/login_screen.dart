import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:zein_store/Future/Auth/Pages/forget_password.dart';
import 'package:zein_store/Future/Auth/Pages/signup_screen.dart';
import 'package:zein_store/Future/Auth/Widgets/my_button_widget.dart';
import 'package:zein_store/Future/Auth/Widgets/text_field_widget.dart';
import 'package:zein_store/Future/Auth/cubit/auth_cubit.dart';
import 'package:zein_store/Future/Home/Pages/navbar_screen.dart';
import 'package:zein_store/Future/Home/Widgets/custom_circular_progress_indicator.dart';
import 'package:zein_store/Future/Home/Widgets/custom_snak_bar.dart';
import 'package:zein_store/Utils/app_localizations.dart';
import 'package:zein_store/Utils/colors.dart';
import 'package:zein_store/Utils/enums.dart';
import 'package:zein_store/Utils/images.dart';
import 'package:zein_store/Utils/validation.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailOrPhoneNumberController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7), // Light clean background
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is LoginSuccessfulState) {
            CustomSnackBar.showMessage(
                context, "login_success".tr(context), Colors.green);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const NavBarPage()));
          }
          if (state is LoginErrorState) {
            CustomSnackBar.showMessage(context, state.message, Colors.red);
          }
        },
        builder: (context, state) {
          return GestureDetector(
            onTap: () =>
                FocusScope.of(context).unfocus(), // Close keyboard on tap
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
                      SizedBox(height: 2.h), // Safe area spacing
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

                      Text(
                        "login_msg".tr(context),
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10.sp,
                        ),
                      ),
                      SizedBox(height: 4.h), // Push content up slightly
                    ],
                  ),
                ),

                // --- 2. Form Section ---
                SingleChildScrollView(
                  padding: EdgeInsets.only(
                      top: 30.h, left: 5.w, right: 5.w, bottom: 5.h),
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
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Email Field
                              TextFieldWidget(
                                validatorFun: (p0) =>
                                    validation(p0, ValidationState.normal),
                                text: "email".tr(context),
                                controller: emailOrPhoneNumberController,
                                isPassword: false,
                              ),

                              // Password Field
                              TextFieldWidget(
                                validatorFun: (p0) =>
                                    validation(p0, ValidationState.password),
                                controller: passwordController,
                                text: "password".tr(context),
                                isPassword: true,
                              ),

                              // Forgot Password (Right Aligned)
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => ForgetPassword()));
                                  },
                                  child: Text(
                                    "forgot_password".tr(context),
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),

                              SizedBox(height: 2.h),

                              // Login Button
                              state is LoginLoadingState
                                  ? const Center(
                                      child: CustomCircularProgressIndicator())
                                  : MyButtonWidget(
                                      color: AppColors.buttonCategoryColor,
                                      text: "login".tr(context),
                                      icon: Icons
                                          .login_rounded, // Assuming you updated widget to accept icons
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          FocusScope.of(context).unfocus();
                                          context.read<AuthCubit>().login(
                                              email:
                                                  emailOrPhoneNumberController
                                                      .text
                                                      .trim(),
                                              password: passwordController.text
                                                  .trim());
                                        }
                                      },
                                    ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // --- 3. Sign Up Option ---
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SignupScreen()));
                        },
                        child: Text(
                          "create_account".tr(context),
                          style: TextStyle(
                            color: AppColors.buttonCategoryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
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
