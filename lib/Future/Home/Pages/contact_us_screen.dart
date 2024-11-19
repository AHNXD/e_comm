import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_comm/Future/Auth/Widgets/my_button_widget.dart';
import 'package:e_comm/Future/Home/Cubits/contactUsCubit/contact_us_cubit.dart';
import 'package:e_comm/Future/Home/Widgets/Contact_Us_Screen/contact_us_from.dart';
import 'package:e_comm/Future/Home/models/contactUs_model.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/Utils/colors.dart';
import 'package:e_comm/Utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../Widgets/custom_snak_bar.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({
    super.key,
  });

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  late final TextEditingController userNameController;

  late final TextEditingController emailOrPhoneController;

  late final TextEditingController messageController;

  final GlobalKey<FormState> key1 = GlobalKey<FormState>();

  @override
  void initState() {
    userNameController = TextEditingController();
    emailOrPhoneController = TextEditingController();
    messageController = TextEditingController();
    super.initState();
  }

  Future<void> submit() async {
    if (key1.currentState!.validate()) {
      showAwesomeDialogForConfirm(
          order: ContactusModel(
        username: userNameController.text,
        emailOrPhone: emailOrPhoneController.text,
        msg: messageController.text,
      ));
    } else {
      CustomSnackBar.showMessage(context, 'error_msg'.tr(context), Colors.red);
    }
  }

  void showAwesomeDialogForConfirm({
    required ContactusModel order,
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
              context.read<ContactUsCubit>().contactUsMessageSend(order);
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

  @override
  void dispose() {
    userNameController.dispose();
    emailOrPhoneController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: AppColors.primaryColors,
        title: Text(
          "contact_us".tr(context),
          style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
      body: BlocListener<ContactUsCubit, ContactUsState>(
        listener: (context, state) {
          if (state is ContactUsSuccessfulState) {
            showAwesomeDialog(message: state.msg);
            key1.currentState!.reset();
          } else if (state is ContactUsErrorState) {
            CustomSnackBar.showMessage(
              context,
              state.error,
              Colors.red,
            );
          }
        },
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Image.asset(
                AppImagesAssets.logoNoBg,
                width: 140.sp,
                height: 140.sp,
                // fit: BoxFit.cover,
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                child: ContactUsFrom(
                    key1: key1,
                    userNameController: userNameController,
                    emailOrPhoneController: emailOrPhoneController,
                    descriptionController: messageController)),
            MyButtonWidget(
              color: AppColors.buttonCategoryColor,
              verticalHieght: 2.h,
              text: "submit".tr(context),
              onPressed: submit,
              horizontalWidth: 8.w,
            )
          ],
        ),
      ),
    );
  }
}
