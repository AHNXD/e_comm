import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:zein_store/Future/Home/Cubits/get_user/get_user_cubit.dart';
import 'package:zein_store/Future/Home/Widgets/error_widget.dart';
import 'package:zein_store/Future/Home/models/user_model.dart';
import 'package:zein_store/Utils/app_localizations.dart';
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
import '../Widgets/custom_circular_progress_indicator.dart';
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
    super.initState();
    context.read<GetUserCubit>().getUserProfile();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    addressController = TextEditingController();
    phoneController = PhoneController(
        initialValue: const PhoneNumber(isoCode: IsoCode.SY, nsn: ""));
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

  void submit() {
    if (key1.currentState!.validate()) {
      // Unfocus
      FocusScope.of(context).unfocus();

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

  // --- Dialogs ---

  void showAwesomeDialogForConfirm({required UserProfile userProfile}) async {
    await AwesomeDialog(
      descTextStyle: TextStyle(fontSize: 12.sp),
      titleTextStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
      btnOkText: "yes".tr(context),
      btnCancelText: "no".tr(context),
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      title: "confirm_info".tr(context),
      desc: "Are you sure you want to save these changes?",
      btnOkOnPress: () {
        context.read<EditProfileCubit>().editProfile(userProfile);
      },
      btnCancelOnPress: () {},
      btnOkColor: AppColors.primaryColors,
      btnCancelColor: Colors.grey,
    ).show();
  }

  void showSuccessDialog({required String message}) async {
    await AwesomeDialog(
      descTextStyle: TextStyle(fontSize: 12.sp),
      btnOkText: "ok".tr(context),
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: "Success",
      desc: message,
      btnOkOnPress: () {
        Navigator.of(context).pop();
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfileCubit, EditProfileState>(
      listener: (context, state) {
        if (state is EditProfileSuccess) {
          showSuccessDialog(message: state.msg);
          context.read<EditProfileCubit>().resetToInintState();
          // We don't reset the form key here usually, because we want the new data to stay visible
          // But if you want to clear inputs: key1.currentState!.reset();
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
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: AppBar(
          foregroundColor: Colors.black87,
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'edit_profile'.tr(context),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textTitleAppBarColor,
                fontSize: 14.sp),
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
              // Only update controllers if they are empty (to prevent overwriting user typing during rebuilds)
              if (firstNameController.text.isEmpty) {
                gender ??= state.userProfile.gender;
                firstNameController.text = state.userProfile.firstName!;
                lastNameController.text = state.userProfile.lastName!;
                emailController.text = state.userProfile.email!;
                addressController.text = state.userProfile.address!;
                phoneController.changeNationalNumber(state.userProfile.phone);
              }

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                child: Form(
                  key: key1,
                  child: Column(
                    children: [
                      // --- 1. Avatar Placeholder ---
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  color:
                                      AppColors.primaryColors.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 4),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10)
                                  ]),
                              child: Center(
                                child: Text(
                                  firstNameController.text.isNotEmpty
                                      ? firstNameController.text[0]
                                          .toUpperCase()
                                      : "U",
                                  style: TextStyle(
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryColors),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    color: AppColors.buttonCategoryColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 2)),
                                child: Icon(Icons.edit,
                                    color: Colors.white, size: 12.sp),
                              ),
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 3.h),

                      // --- 2. Form Container ---
                      Container(
                        padding: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFieldWidget(
                                    validatorFun: (p0) =>
                                        validation(p0, ValidationState.normal),
                                    text: "FN_info".tr(context),
                                    isPassword: false,
                                    controller: firstNameController,
                                    // Make sure TextFieldWidget supports hint or label
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: TextFieldWidget(
                                      validatorFun: (p0) => validation(
                                          p0, ValidationState.normal),
                                      text: 'LN_info'.tr(context),
                                      isPassword: false,
                                      controller: lastNameController),
                                ),
                              ],
                            ),

                            SizedBox(height: 1.h),

                            // Custom Gender Selector
                            Text("gender".tr(context),
                                style: TextStyle(
                                    fontSize: 10.sp, color: Colors.grey[600])),
                            SizedBox(height: 1.h),
                            Row(
                              children: [
                                Expanded(
                                    child: _GenderCard(
                                        label: "male".tr(context),
                                        icon: Icons.male,
                                        value: 1,
                                        groupValue: gender,
                                        onTap: (v) =>
                                            setState(() => gender = v))),
                                SizedBox(width: 3.w),
                                Expanded(
                                    child: _GenderCard(
                                        label: "fmale".tr(context),
                                        icon: Icons.female,
                                        value: 0,
                                        groupValue: gender,
                                        onTap: (v) =>
                                            setState(() => gender = v))),
                              ],
                            ),

                            SizedBox(height: 3.h),
                            Divider(color: Colors.grey[100]),
                            SizedBox(height: 2.h),

                            PhoneFieldWidget(controller: phoneController),

                            // Spacing handled inside widgets hopefully, if not add SizedBox

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
                          ],
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // --- 3. Submit Button ---
                      MyButtonWidget(
                        color: AppColors.buttonCategoryColor,
                        text: 'submit'
                            .tr(context), // Use "Save Changes" if possible
                        icon: Icons.save_rounded,
                        onPressed: submit,
                      ),

                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              );
            }
            return const Center(child: CustomCircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

// --- Helper Widgets ---

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
