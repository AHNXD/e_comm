import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:zein_store/Future/Auth/Widgets/my_button_widget.dart';
import 'package:zein_store/Future/Home/Cubits/get_user/get_user_cubit.dart';
import 'package:zein_store/Future/Home/Cubits/print_image_cubit/print_image_cubit.dart';
import 'package:zein_store/Future/Home/Widgets/custom_snak_bar.dart';
import 'package:zein_store/Future/Home/Widgets/print_image/print_image_form.dart';
import 'package:zein_store/Future/Home/models/print_image_model.dart';
import 'package:zein_store/Utils/app_localizations.dart';
import 'package:zein_store/Utils/colors.dart';
import 'package:zein_store/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:sizer/sizer.dart';

class PrintImageScreen extends StatefulWidget {
  const PrintImageScreen({super.key});

  @override
  State<PrintImageScreen> createState() => _PrintImageState();
}

class _PrintImageState extends State<PrintImageScreen> {
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController provinceController;
  late final TextEditingController regionController;
  late final TextEditingController addressController;

  late final TextEditingController printSizeIdController;
  late final TextEditingController quantityController;
  late final PhoneController phoneController;
  final GlobalKey<FormState> key1 = GlobalKey<FormState>();
  File? productImage;
  bool imageUploaded = false;

  @override
  void initState() {
    super.initState();
    final userProfile = context.read<GetUserCubit>().userProfile;

    firstNameController =
        TextEditingController(text: userProfile?.firstName ?? "");
    lastNameController =
        TextEditingController(text: userProfile?.lastName ?? "");
    provinceController = TextEditingController();
    regionController = TextEditingController();
    addressController = TextEditingController(text: userProfile?.address ?? "");

    phoneController = PhoneController(
        initialValue: const PhoneNumber(isoCode: IsoCode.SY, nsn: ""));

    quantityController = TextEditingController();
    printSizeIdController = TextEditingController();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    provinceController.dispose();
    regionController.dispose();
    quantityController.dispose();
    addressController.dispose();
    phoneController.dispose();
    printSizeIdController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (key1.currentState!.validate()) {
      if (imageUploaded && productImage != null) {
        final int? quantity = int.tryParse(quantityController.text);
        if (quantity == null) {
          CustomSnackBar.showMessage(
            context,
            lang == 'en'
                ? "Please enter a valid number"
                : "الرجاء ادخال رقم صحيح",
            Colors.red,
          );
          return;
        }

        // Unfocus
        FocusScope.of(context).unfocus();

        final PrintImageModel printOrder = PrintImageModel(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          phone:
              "00${phoneController.value.countryCode}${phoneController.value.nsn}",
          province: provinceController.text,
          region: regionController.text,
          address: addressController.text,
          printSizeId: printSizeIdController.text,
          quantity: quantity,
          image: productImage,
        );

        // Show confirmation dialog before sending
        showConfirmationDialog(printOrder);
      } else {
        CustomSnackBar.showMessage(
          context,
          'please_upload_an_image_before_submitting'.tr(context),
          Colors.red,
        );
      }
    } else {
      CustomSnackBar.showMessage(
        context,
        'failed_to_add_product'.tr(context),
        Colors.red,
      );
    }
  }

  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          productImage = File(pickedFile.path);
          imageUploaded = true;
        });
        CustomSnackBar.showMessage(
          context,
          "image_uploded".tr(context),
          Colors.green,
        );
      }
    } catch (e) {
      CustomSnackBar.showMessage(
        context,
        "image_isn't_upoalded".tr(context),
        Colors.red,
      );
    }
  }

  // --- Dialogs ---

  void showConfirmationDialog(PrintImageModel printOrder) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      title: "confirm_product".tr(context), // Use appropriate key
      desc: "Are you sure you want to submit this print request?",
      btnOkText: "yes".tr(context),
      btnCancelText: "no".tr(context),
      btnOkOnPress: () {
        context.read<PrintImageCubit>().sendPrintImageOrder(printOrder);
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
    // Keep user phone update logic if needed
    final userProfile = context.read<GetUserCubit>().userProfile;
    if (userProfile != null) {
      phoneController.changeNationalNumber(userProfile.phone);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        foregroundColor: Colors.black87,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'print_image_order_btn'.tr(context),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textTitleAppBarColor,
              fontSize: 14.sp),
        ),
      ),
      body: BlocListener<PrintImageCubit, PrintImageState>(
        listener: (context, state) {
          if (state is PrintImageSuccess) {
            showSuccessDialog(message: state.msg);
            key1.currentState!.reset();
            setState(() {
              imageUploaded = false;
              productImage = null;
            });
          } else if (state is PrintImageError) {
            CustomSnackBar.showMessage(
              context,
              state.error,
              Colors.red,
            );
          }
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. Info Banner ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryColors.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.primaryColors.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.print_rounded, color: AppColors.primaryColors),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        "sell_product_hint".tr(
                            context), // Reuse generic hint or create specific
                        style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.primaryColors,
                            height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 3.h),

              // --- 2. Print Details Form ---

              Container(
                padding: const EdgeInsets.all(20),
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
                child: PrintImageForm(
                  key1: key1,
                  addressController: addressController,
                  firstNameController: firstNameController,
                  lastNameController: lastNameController,
                  phoneController: phoneController,
                  printSizeIdController: printSizeIdController,
                  provinceController: provinceController,
                  quantityController: quantityController,
                  regionController: regionController,
                ),
              ),

              SizedBox(height: 3.h),

              // --- 3. Image Upload Section ---

              if (!imageUploaded)
                GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColors.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 24.sp,
                            color: AppColors.primaryColors,
                          ),
                        ),
                        SizedBox(height: 1.5.h),
                        Text(
                          'upload_img'.tr(context),
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                              fontSize: 11.sp),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Stack(
                  children: [
                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                          image: DecorationImage(
                            image: FileImage(productImage!),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4))
                          ]),
                    ),
                    // Delete Button
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            productImage = null;
                            imageUploaded = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 5)
                              ]),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              SizedBox(height: 5.h),

              // --- 4. Submit Button ---
              MyButtonWidget(
                color: AppColors.buttonCategoryColor,
                text: 'print_img'.tr(context),
                icon: Icons.print_rounded,
                onPressed: submit,
              ),

              SizedBox(height: 3.h),
            ],
          ),
        ),
      ),
    );
  }
}
