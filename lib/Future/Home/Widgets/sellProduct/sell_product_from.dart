import 'package:e_comm/Utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:sizer/sizer.dart';

import '../../../../Utils/enums.dart';
import '../../../../Utils/validation.dart';
import '../../../Auth/Widgets/phone_field_widget.dart';
import '../../../Auth/Widgets/text_field_widget.dart';

class SellProductForm extends StatelessWidget {
  const SellProductForm({
    super.key,
    required this.key1,
    required this.nameController,
    required this.productNameController,
    required this.phoneController,
    required this.priceController,
    required this.descriptionController,
  });

  final GlobalKey<FormState> key1;
  final TextEditingController nameController;
  final TextEditingController productNameController;
  final PhoneController phoneController;
  final TextEditingController priceController;
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
                text: "your_name".tr(context),
                isPassword: false,
                controller: nameController),
            PhoneFieldWidget(controller: phoneController),
            TextFieldWidget(
                validatorFun: (p0) => validation(p0, ValidationState.normal),
                text: 'product_name'.tr(context),
                isPassword: false,
                controller: productNameController),
            TextFieldWidget(
                validatorFun: (p0) => validation(p0, ValidationState.price),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                text: "price_info".tr(context),
                isPassword: false,
                controller: priceController),
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
