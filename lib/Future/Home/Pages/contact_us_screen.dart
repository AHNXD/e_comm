import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:zein_store/Future/Auth/Widgets/my_button_widget.dart'; // Ensure this uses the updated widget
import 'package:zein_store/Future/Home/Cubits/contactUsCubit/contact_us_cubit.dart';
import 'package:zein_store/Future/Home/Cubits/get_user/get_user_cubit.dart';
import 'package:zein_store/Future/Home/Widgets/Contact_Us_Screen/contact_us_from.dart';
import 'package:zein_store/Future/Home/models/contactUs_model.dart';
import 'package:zein_store/Utils/app_localizations.dart';
import 'package:zein_store/Utils/colors.dart';
import 'package:zein_store/Utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../Widgets/custom_snak_bar.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

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
    super.initState();
    final userProfile = context.read<GetUserCubit>().userProfile;

    userNameController = TextEditingController(
        text: userProfile != null
            ? "${userProfile.firstName} ${userProfile.lastName}"
            : "");

    emailOrPhoneController = TextEditingController(
        text: userProfile != null ? userProfile.phone : "");

    messageController = TextEditingController();
  }

  @override
  void dispose() {
    userNameController.dispose();
    emailOrPhoneController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (key1.currentState!.validate()) {
      // Close keyboard
      FocusScope.of(context).unfocus();

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

  void showAwesomeDialogForConfirm({required ContactusModel order}) async {
    await AwesomeDialog(
      descTextStyle: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
      titleTextStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
      btnOkText: "yes".tr(context),
      btnCancelText: "no".tr(context),
      context: context,
      dialogType: DialogType.question, // Changed to Question for better UX
      animType: AnimType.bottomSlide,
      title: "confirm_info".tr(context),

      btnOkOnPress: () {
        context.read<ContactUsCubit>().contactUsMessageSend(order);
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
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Light Grey Background
      appBar: AppBar(
        foregroundColor: Colors.black87,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "contact_us".tr(context),
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textTitleAppBarColor,
          ),
        ),
      ),
      body: BlocListener<ContactUsCubit, ContactUsState>(
        listener: (context, state) {
          if (state is ContactUsSuccessfulState) {
            showSuccessDialog(message: state.msg);
            userNameController.clear();
            emailOrPhoneController.clear();
            messageController.clear();
          } else if (state is ContactUsErrorState) {
            CustomSnackBar.showMessage(
              context,
              state.error,
              Colors.red,
            );
          }
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
          child: Column(
            children: [
              // --- 1. Header Section ---
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Image.asset(
                      AppImagesAssets.logoNoBg,
                      width: 80.sp, // Reduced size for cleaner look
                      height: 80.sp,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 4.h),

              // --- 2. Form Card ---
              Container(
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF909090).withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: ContactUsFrom(
                  key1: key1,
                  userNameController: userNameController,
                  emailOrPhoneController: emailOrPhoneController,
                  descriptionController: messageController,
                ),
              ),

              SizedBox(height: 4.h),

              // --- 3. Submit Button ---
              // Assuming MyButtonWidget is the one refactored previously
              MyButtonWidget(
                text: "submit".tr(context),
                color: AppColors.buttonCategoryColor,
                icon: Icons.send_rounded,
                onPressed: submit,
              ),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
