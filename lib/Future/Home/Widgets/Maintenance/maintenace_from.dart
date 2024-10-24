import 'package:e_comm/Utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:sizer/sizer.dart';

import '../../../../Utils/enums.dart';
import '../../../../Utils/validation.dart';
import '../../../Auth/Widgets/phone_field_widget.dart';
import '../../../Auth/Widgets/text_field_widget.dart';

class MaintenaceForm extends StatelessWidget {
  const MaintenaceForm({
    super.key,
    required this.key1,
    required this.FNController,
    required this.LNController,
    required this.phoneController,
    required this.provinceController,
    required this.regionController,
    required this.addressController,
    required this.problemController,
    required this.descriptionController,
  });

  final GlobalKey<FormState> key1;
  final TextEditingController FNController;
  final TextEditingController LNController;
  final PhoneController phoneController;
  final TextEditingController provinceController;
  final TextEditingController regionController;
  final TextEditingController addressController;
  final TextEditingController problemController;
  final TextEditingController descriptionController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      child: Form(
        key: key1,
        child: Column(
          children: [
            TextFieldWidget(
                validatorFun: (p0) => validation(p0, ValidationState.normal),
                text: "FN_info".tr(context),
                isPassword: false,
                controller: FNController),
            TextFieldWidget(
                validatorFun: (p0) => validation(p0, ValidationState.normal),
                text: "LN_info".tr(context),
                isPassword: false,
                controller: LNController),
            PhoneFieldWidget(controller: phoneController),
            TextFieldWidget(
                validatorFun: (p0) => validation(p0, ValidationState.normal),
                text: "province".tr(context),
                isPassword: false,
                controller: provinceController),
            TextFieldWidget(
                validatorFun: (p0) => validation(p0, ValidationState.normal),
                text: 'region'.tr(context),
                isPassword: false,
                controller: regionController),
            TextFieldWidget(
                validatorFun: (p0) => validation(p0, ValidationState.normal),
                text: "address".tr(context),
                isPassword: false,
                controller: addressController),
            TextFieldWidget(
              validatorFun: (p0) => validation(p0, ValidationState.normal),
              text: "problem_info".tr(context),
              isPassword: false,
              controller: problemController,
              maxLine: 3,
            ),
            TextFieldWidget(
              validatorFun: (p0) => validation(p0, ValidationState.normal),
              text: "description_info".tr(context),
              isPassword: false,
              controller: descriptionController,
              maxLine: 3,
            )
          ],
        ),
      ),
    );
  }
}
