import 'package:e_comm/Future/Home/Cubits/get_print_sizes_cubit/get_print_sizes_cubit.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:sizer/sizer.dart';

import '../../../../Utils/enums.dart';
import '../../../../Utils/validation.dart';
import '../../../Auth/Widgets/phone_field_widget.dart';
import '../../../Auth/Widgets/text_field_widget.dart';

class PrintImageForm extends StatelessWidget {
  const PrintImageForm({
    super.key,
    required this.key1,
    required this.phoneController,
    required this.firstNameController,
    required this.lastNameController,
    required this.provinceController,
    required this.regionController,
    required this.addressController,
    required this.printSizeIdController,
    required this.quantityController,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController provinceController;
  final TextEditingController regionController;
  final TextEditingController addressController;

  final TextEditingController printSizeIdController;
  final TextEditingController quantityController;
  final PhoneController phoneController;
  final GlobalKey<FormState> key1;

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
                controller: firstNameController),
            TextFieldWidget(
                validatorFun: (p0) => validation(p0, ValidationState.normal),
                text: 'LN_info'.tr(context),
                isPassword: false,
                controller: lastNameController),
            PhoneFieldWidget(controller: phoneController),
            TextFieldWidget(
                validatorFun: (p0) => validation(p0, ValidationState.normal),
                text: "province".tr(context),
                isPassword: false,
                controller: provinceController),
            TextFieldWidget(
              validatorFun: (p0) => validation(p0, ValidationState.normal),
              text: "region".tr(context),
              isPassword: false,
              controller: regionController,
            ),
            TextFieldWidget(
                validatorFun: (p0) => validation(p0, ValidationState.normal),
                text: "address".tr(context),
                isPassword: false,
                controller: addressController),
            TextFieldWidget(
              validatorFun: (p0) => validation(p0, ValidationState.price),
              text: "quantity".tr(context),
              isPassword: false,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              controller: quantityController,
            ),
            SizedBox(height: 2.h),
            BlocBuilder<GetPrintSizesCubit, GetPrintSizesState>(
              builder: (context, state) {
                List<String> printSizes = [];

                if (state is GetPrintSizesSuccess) {
                  state.printSizes
                      .map((e) => printSizes
                          .add("width: ${e.width!} * height: ${e.height!}"))
                      .toList();

                  return CustomDropDownWidget(
                      printSizeIdController: printSizeIdController,
                      printSizes: printSizes);
                }
                return CustomDropDownWidget(
                    printSizeIdController: printSizeIdController,
                    printSizes: printSizes);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDropDownWidget extends StatelessWidget {
  const CustomDropDownWidget({
    super.key,
    required this.printSizeIdController,
    required this.printSizes,
  });

  final TextEditingController printSizeIdController;
  final List<String> printSizes;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "print_size_id".tr(context),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      value: printSizeIdController.text.isNotEmpty
          ? printSizeIdController.text
          : null,
      items: printSizes.map((String size) {
        return DropdownMenuItem<String>(
          value: size,
          child: Text(size),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          printSizeIdController.text = newValue;
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "please_select_a_size".tr(context);
        }
        return null;
      },
    );
  }
}
