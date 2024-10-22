// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:sizer/sizer.dart';

class PhoneFieldWidget extends StatefulWidget {
  const PhoneFieldWidget({super.key, required this.controller});
  final PhoneController controller;

  @override
  State<PhoneFieldWidget> createState() => _PhoneFieldWidgetState();
}

class _PhoneFieldWidgetState extends State<PhoneFieldWidget> {
  final FocusNode fNode = FocusNode();
  bool isFill = true;
  Color fillColor = const Color(0xffF4F7FE);
  @override
  void initState() {
    fNode.addListener(() {
      if (fNode.hasFocus) {
        setState(() {
          fillColor = Colors.transparent;
          isFill = false;
        });
      } else {
        setState(() {
          fillColor = const Color(0xffF4F7FE);
          isFill = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: PhoneFormField(
          textInputAction: TextInputAction.next,
          controller: widget.controller,
          focusNode: fNode,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xffB2B9C6)),
              borderRadius: BorderRadius.circular(3.w),
            ),
            filled: true,
            fillColor: fillColor,
            contentPadding:
                EdgeInsets.symmetric(vertical: 1.2.h, horizontal: 2.5.w),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2.w),
                borderSide: BorderSide.none),
          ),
          // or use the controller
          validator: PhoneValidator.compose([
            PhoneValidator.required(context),
            PhoneValidator.validMobile(context),
          ]),
          // countrySelectorNavigator: const CountrySelectorNavigator.page(),
          onChanged: (phoneNumber) => print(
              "+${widget.controller.value.countryCode}${widget.controller.value.nsn}"),
          enabled: true,
          isCountrySelectionEnabled: true,
          showDialCode: true,
          showIsoCodeInInput: true,
          showFlagInInput: true,
          flagSize: 16),
    );
  }
}
