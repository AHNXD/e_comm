import 'package:zein_store/Utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:sizer/sizer.dart';
import '../../../../Utils/enums.dart';
import '../../../../Utils/validation.dart';
import '../../../Auth/Widgets/phone_field_widget.dart';
import '../../../Auth/Widgets/text_field_widget.dart';

class OrderProductForm extends StatelessWidget {
  const OrderProductForm({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.descriptionController,
    required this.notesController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final PhoneController phoneController;
  final TextEditingController descriptionController;
  final TextEditingController notesController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            TextFieldWidget(
              validatorFun: (p0) => validation(p0, ValidationState.normal),
              text: "FN_info".tr(context),
              isPassword: false,
              controller: firstNameController,
            ),
            TextFieldWidget(
              validatorFun: (p0) => validation(p0, ValidationState.normal),
              text: 'LN_info'.tr(context),
              isPassword: false,
              controller: lastNameController,
            ),
            PhoneFieldWidget(controller: phoneController),
            TextFieldWidget(
              validatorFun: (p0) => validation(p0, ValidationState.normal),
              text: "description_info".tr(context),
              isPassword: false,
              controller: descriptionController,
              maxLine: 3,
            ),
            TextFieldWidget(
              text: "order_notes".tr(context),
              isPassword: false,
              controller: notesController,
              maxLine: 2,
            ),
          ],
        ),
      ),
    );
  }
}
