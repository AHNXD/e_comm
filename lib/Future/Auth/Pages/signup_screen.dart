import 'package:e_comm/Future/Auth/Pages/forget_password.dart';
import 'package:e_comm/Future/Auth/Pages/login_screen.dart';
import 'package:e_comm/Future/Auth/Pages/signup_screen_two.dart';
import 'package:e_comm/Future/Auth/Widgets/my_button_widget.dart';
import 'package:e_comm/Future/Auth/Widgets/phone_field_widget.dart';
import 'package:e_comm/Future/Auth/Widgets/text_field_widget.dart';
import 'package:e_comm/Future/Auth/cubit/auth_cubit.dart';
import 'package:e_comm/Future/Home/Widgets/home_screen/back_widget.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/Utils/colors.dart';
import 'package:e_comm/Utils/enums.dart';
import 'package:e_comm/Utils/images.dart';
import 'package:e_comm/Utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

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
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return Form(
            key: _key,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              children: [
                SizedBox(
                  height: 6.h,
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
                  validatorFun: (p0) => validation(p0, ValidationState.normal),
                  text: "FN_info".tr(context),
                  isPassword: false,
                  controller: context.read<AuthCubit>().firstNameController,
                ),
                TextFieldWidget(
                  validatorFun: (p0) => validation(p0, ValidationState.normal),
                  text: "LN_info".tr(context),
                  isPassword: false,
                  controller: context.read<AuthCubit>().lastNameController,
                ),
                // const SwitchWidget(),
                // SizedBox(
                //   height: 2.h,
                // ),
                // const SwitchTextWidget(),
                // SizedBox(
                //   height: 2.h,
                // ),
                TextFieldWidget(
                  validatorFun: (p0) => validation(p0, ValidationState.email),
                  text:
                      "${"please_Enter_your".tr(context)} ${"email".tr(context)}",
                  isPassword: false,
                  controller: context.read<AuthCubit>().emailController,
                ),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: PhoneFieldWidget(
                    controller:
                        context.read<AuthCubit>().phoneNumberController!,
                  ),
                ),
                TextFieldWidget(
                  validatorFun: (p0) => validation(p0, ValidationState.normal),
                  controller: context.read<AuthCubit>().addressController,
                  text: "address".tr(context),
                  isPassword: false,
                ),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RadioMenuButton<int>(
                          value: 1,
                          groupValue: context.read<AuthCubit>().genderState,
                          onChanged: (s) {
                            context.read<AuthCubit>().setSignUpStatusIsMail =
                                s!;
                          },
                          child: Text("male".tr(context)),
                        ),
                        // mail = 1;
                        // fmail = 0;
                        RadioMenuButton<int>(
                          value: 0,
                          groupValue: context.read<AuthCubit>().genderState,
                          onChanged: (s) {
                            context.read<AuthCubit>().setSignUpStatusIsMail =
                                s!;
                          },
                          child: Text("fmale".tr(context)),
                        ),
                      ],
                    );
                  },
                ),
                // TextFieldWidget(
                //   controller: passwordController,
                //   text: "Password",
                //   isPassword: true,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                MyButtonWidget(
                  color: AppColors.buttonCategoryColor,
                  verticalHieght: 0,
                  horizontalWidth: 0,
                  text: "next".tr(context),
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (builder) {
                        return SignupScreenTow();
                      }));
                    }
                  },
                ),
                SizedBox(
                  height: 4.h,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
