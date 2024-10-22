import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TextFieldWidget extends StatefulWidget {
  const TextFieldWidget(
      {super.key,
      this.borderColor,
      required this.text,
      required this.isPassword,
      this.maxLine = 1,
      required this.controller,
      this.validatorFun,
      this.keyboardType});
  final String text;
  final bool isPassword;
  final int maxLine;
  final TextEditingController controller;
  final String? Function(String?)? validatorFun;
  final Color? borderColor;
  final TextInputType? keyboardType;

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  void dispose() {
    // focusNode.dispose();
    // widget.controller.dispose();
    widget.controller.clear();
    super.dispose();
  }

  bool showPassowrd = false;
  FocusNode focusNode = FocusNode();
  // bool isFill = true;
  Color fillColor = const Color(0xffF4F7FE);
  @override
  void initState() {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          fillColor = Colors.transparent;
        });
      } else {
        setState(() {
          fillColor = const Color(0xffF4F7FE);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: TextFormField(
        keyboardType: widget.keyboardType,
        textInputAction: TextInputAction.next,
        validator: widget.validatorFun,
        controller: widget.controller,
        focusNode: focusNode,
        maxLines: widget.maxLine,
        obscureText: widget.isPassword ? !showPassowrd : false,
        decoration: InputDecoration(
          labelStyle: const TextStyle(color: Colors.black),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: widget.borderColor == null
                    ? const Color(0xffB2B9C6)
                    : widget.borderColor!),
            borderRadius: BorderRadius.circular(3.w),
          ),
          labelText: widget.text,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    showPassowrd ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      showPassowrd = !showPassowrd;
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.w),
              borderSide: BorderSide.none),
          fillColor: fillColor,
          filled: true,
        ),
      ),
    );
  }
}
