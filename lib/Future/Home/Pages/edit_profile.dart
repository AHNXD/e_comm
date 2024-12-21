import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_comm/Future/Home/Cubits/get_user/get_user_cubit.dart';
import 'package:e_comm/Future/Home/Widgets/error_widget.dart';
import 'package:e_comm/Future/Home/models/user_model.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:sizer/sizer.dart';

import '../../../Utils/colors.dart';
import '../../../Utils/enums.dart';
import '../../../Utils/validation.dart';
import '../../Auth/Widgets/my_button_widget.dart';
import '../../Auth/Widgets/phone_field_widget.dart';
import '../../Auth/Widgets/text_field_widget.dart';
import '../Cubits/edit_profile/edit_profile_cubit.dart';
import '../Widgets/custom_snak_bar.dart';

class EditeProfile extends StatefulWidget {
  const EditeProfile({super.key});

  @override
  State<EditeProfile> createState() => _EditeProfileState();
}

class _EditeProfileState extends State<EditeProfile> {
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController emailController;
  late final TextEditingController addressController;
  late final PhoneController phoneController;
  int? gender;
  final GlobalKey<FormState> key1 = GlobalKey<FormState>();
  @override
  void initState() {
    context.read<GetUserCubit>().getUserProfile();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    addressController = TextEditingController();
    phoneController = PhoneController(
        initialValue: const PhoneNumber(isoCode: IsoCode.SY, nsn: ""));
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    addressController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfileCubit, EditProfileState>(
      listener: (context, state) {
        if (state is EditProfileSuccess) {
          showAwesomeDialog(message: state.msg);
          context.read<EditProfileCubit>().resetToInintState();
          key1.currentState!.reset();
        } else if (state is EditProfileError) {
          CustomSnackBar.showMessage(
            context,
            state.msg,
            Colors.red,
          );
          context.read<EditProfileCubit>().resetToInintState();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          scrolledUnderElevation: 0,
          backgroundColor: AppColors.primaryColors,
          centerTitle: true,
          title: Text(
            'edit_profile'.tr(context),
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: BlocBuilder<GetUserCubit, GetUserState>(
          builder: (context, state) {
            if (state is GetUserErorre) {
              return Center(
                child: MyErrorWidget(
                    msg: state.msg,
                    onPressed: context.read<GetUserCubit>().getUserProfile),
              );
            } else if (state is GetUserSuccess) {
              gender ??= state.userProfile.gender;
              firstNameController.text = state.userProfile.firstName!;
              lastNameController.text = state.userProfile.lastName!;
              emailController.text = state.userProfile.email!;
              addressController.text = state.userProfile.address!;
              phoneController.changeNationalNumber(state.userProfile.phone);

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                child: Form(
                  key: key1,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFieldWidget(
                            validatorFun: (p0) =>
                                validation(p0, ValidationState.normal),
                            text: "FN_info".tr(context),
                            isPassword: false,
                            controller: firstNameController),
                        TextFieldWidget(
                            validatorFun: (p0) =>
                                validation(p0, ValidationState.normal),
                            text: 'LN_info'.tr(context),
                            isPassword: false,
                            controller: lastNameController),
                        PhoneFieldWidget(
                          controller: phoneController,
                        ),
                        TextFieldWidget(
                          validatorFun: (p0) =>
                              validation(p0, ValidationState.email),
                          text: "email".tr(context),
                          isPassword: false,
                          controller: emailController,
                        ),
                        TextFieldWidget(
                            validatorFun: (p0) =>
                                validation(p0, ValidationState.normal),
                            text: "address".tr(context),
                            isPassword: false,
                            controller: addressController),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RadioMenuButton<int>(
                              value: 1,
                              groupValue: gender,
                              onChanged: (s) {
                                setState(() {
                                  gender = s;
                                });
                              },
                              child: Text("male".tr(context)),
                            ),
                            // mail = 1;
                            // fmail = 0;
                            RadioMenuButton<int>(
                              value: 0,
                              groupValue: gender,
                              onChanged: (s) {
                                setState(() {
                                  gender = s;
                                });
                              },
                              child: Text("fmale".tr(context)),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        MyButtonWidget(
                          color: AppColors.buttonCategoryColor,
                          verticalHieght: 2.h,
                          text: 'submit'.tr(context),
                          onPressed: submit,
                          horizontalWidth: 5.w,
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            return Center(
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColors,
                  )),
            );
          },
        ),
      ),
    );
  }

  void submit() {
    if (key1.currentState!.validate()) {
      showAwesomeDialogForConfirm(
          userProfile: UserProfile(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        address: addressController.text,
        email: emailController.text,
        gender: gender,
        phone:
            "00${phoneController.value.countryCode}${phoneController.value.nsn}",
      ));
    }
  }

  void showAwesomeDialogForConfirm({
    required UserProfile userProfile,
  }) async {
    await AwesomeDialog(
            descTextStyle: TextStyle(fontSize: 15.sp),
            btnOkText: "yes".tr(context),
            btnCancelText: "no".tr(context),
            context: context,
            dialogType: DialogType.infoReverse,
            animType: AnimType.scale,
            title: "confirm_info".tr(context),
            btnOkOnPress: () {
              context.read<EditProfileCubit>().editProfile(userProfile);
            },
            btnCancelOnPress: () {})
        .show();
  }

  void showAwesomeDialog({required String message}) async {
    await AwesomeDialog(
      descTextStyle: TextStyle(fontSize: 15.sp),
      btnOkText: "ok".tr(context),
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: message,
      btnOkOnPress: () {
        Navigator.of(context).pop();
      },
    ).show();
  }
}
