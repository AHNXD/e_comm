import 'package:zein_store/Utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../Utils/enums.dart';
import '../../../../Utils/validation.dart';
import '../../../Auth/Widgets/text_field_widget.dart';

class ContactUsFrom extends StatelessWidget {
  const ContactUsFrom({
    super.key,
    required this.key1,
    required this.userNameController,
    required this.emailOrPhoneController,
    required this.descriptionController,
  });

  final GlobalKey<FormState> key1;
  final TextEditingController userNameController;
  final TextEditingController emailOrPhoneController;
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
                text: "user_name".tr(context),
                isPassword: false,
                controller: userNameController),
            TextFieldWidget(
                validatorFun: (p0) => validation(p0, ValidationState.normal),
                text: "emailOrPhone".tr(context),
                isPassword: false,
                controller: emailOrPhoneController),
            TextFieldWidget(
              validatorFun: (p0) => validation(p0, ValidationState.normal),
              text: "msg".tr(context),
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
