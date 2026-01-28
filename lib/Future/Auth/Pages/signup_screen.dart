import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:zein_store/Future/Auth/Pages/login_screen.dart';
import 'package:zein_store/Future/Auth/Pages/signup_screen_two.dart';
import 'package:zein_store/Future/Auth/Widgets/my_button_widget.dart';
import 'package:zein_store/Future/Auth/Widgets/phone_field_widget.dart';
import 'package:zein_store/Future/Auth/Widgets/text_field_widget.dart';
import 'package:zein_store/Future/Auth/cubit/auth_cubit.dart';
import 'package:zein_store/Utils/app_localizations.dart';
import 'package:zein_store/Utils/colors.dart';
import 'package:zein_store/Utils/images.dart';
import 'package:zein_store/Utils/validation.dart';

import '../../../Utils/enums.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7), // Light clean background
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: [
                // --- 1. Top Background Decoration ---
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
                    children: [
                      SizedBox(height: 6.h),
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
                          height: 8.h,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "create_your_account".tr(context),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5),
                      ),
                    ],
                  ),
                ),

                // --- 2. Form Section ---
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
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _key,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFieldWidget(
                                      validatorFun: (p0) => validation(
                                          p0, ValidationState.normal),
                                      text: "FN_info".tr(context),
                                      isPassword: false,
                                      controller: context
                                          .read<AuthCubit>()
                                          .firstNameController,
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                    child: TextFieldWidget(
                                      validatorFun: (p0) => validation(
                                          p0, ValidationState.normal),
                                      text: "LN_info".tr(context),
                                      isPassword: false,
                                      controller: context
                                          .read<AuthCubit>()
                                          .lastNameController,
                                    ),
                                  ),
                                ],
                              ),

                              // Phone
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: PhoneFieldWidget(
                                  controller: context
                                      .read<AuthCubit>()
                                      .phoneNumberController!,
                                ),
                              ),

                              // Email
                              TextFieldWidget(
                                validatorFun: (p0) =>
                                    validation(p0, ValidationState.email),
                                text: "email".tr(context),
                                isPassword: false,
                                controller:
                                    context.read<AuthCubit>().emailController,
                              ),

                              // Address
                              TextFieldWidget(
                                validatorFun: (p0) =>
                                    validation(p0, ValidationState.normal),
                                controller:
                                    context.read<AuthCubit>().addressController,
                                text: "address".tr(context),
                                isPassword: false,
                              ),

                              SizedBox(height: 1.h),
                              Text("gender".tr(context),
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      color: Colors.grey[600])),
                              SizedBox(height: 1.h),

                              // Custom Gender Selector
                              Row(
                                children: [
                                  Expanded(
                                    child: _GenderCard(
                                      label: "male".tr(context),
                                      icon: Icons.male,
                                      value: 1,
                                      groupValue:
                                          context.read<AuthCubit>().genderState,
                                      onTap: (val) {
                                        context
                                            .read<AuthCubit>()
                                            .setSignUpStatusIsMail = val;
                                        // Trigger rebuild to update UI if Cubit doesn't emit state immediately for this
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                    child: _GenderCard(
                                      label: "fmale".tr(context),
                                      icon: Icons.female,
                                      value: 0,
                                      groupValue:
                                          context.read<AuthCubit>().genderState,
                                      onTap: (val) {
                                        context
                                            .read<AuthCubit>()
                                            .setSignUpStatusIsMail = val;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 4.h),

                              // Next Button
                              MyButtonWidget(
                                color: AppColors.buttonCategoryColor,
                                text: "next".tr(context),
                                icon: Icons.arrow_forward_rounded,
                                onPressed: () {
                                  if (_key.currentState!.validate()) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (builder) {
                                      return SignupScreenTow();
                                    }));
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 3.h),

                      // Login Link
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (builder) {
                            return LoginScreen();
                          }));
                        },
                        child: Text(
                          "login".tr(context),
                          style: TextStyle(
                            color: AppColors.buttonCategoryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 11.sp,
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

// --- Helper Widget: Gender Card ---
class _GenderCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final int value;
  final int? groupValue;
  final Function(int) onTap;

  const _GenderCard({
    required this.label,
    required this.icon,
    required this.value,
    required this.groupValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = groupValue == value;
    Color color = isSelected ? AppColors.primaryColors : Colors.grey;
    Color bgColor = isSelected
        ? AppColors.primaryColors.withOpacity(0.05)
        : Colors.transparent;

    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color:
                    isSelected ? AppColors.primaryColors : Colors.grey.shade300,
                width: isSelected ? 1.5 : 1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16.sp),
            SizedBox(width: 2.w),
            Text(
              label,
              style: TextStyle(
                  color: color,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 10.sp),
            )
          ],
        ),
      ),
    );
  }
}
