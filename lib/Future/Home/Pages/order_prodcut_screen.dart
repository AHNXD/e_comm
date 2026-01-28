import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:sizer/sizer.dart';
import 'package:zein_store/Future/Auth/Widgets/my_button_widget.dart';
import 'package:zein_store/Future/Home/Cubits/get_user/get_user_cubit.dart';
import 'package:zein_store/Future/Home/Cubits/order_product/order_product_cubit.dart';
import 'package:zein_store/Future/Home/Widgets/custom_snak_bar.dart';
import 'package:zein_store/Utils/app_localizations.dart';

import '../../../Utils/colors.dart';
import '../Widgets/order_product/order_product_form.dart';
import '../models/order_product_model.dart';

class OrderProduct extends StatefulWidget {
  const OrderProduct({super.key});

  @override
  State<OrderProduct> createState() => _OrderProductState();
}

class _OrderProductState extends State<OrderProduct> {
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final PhoneController phoneController;
  late final TextEditingController descriptionController;
  late final TextEditingController notesController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File? orderImage;
  bool imageUploaded = false;

  @override
  void initState() {
    super.initState();
    final userProfile = context.read<GetUserCubit>().userProfile;

    firstNameController = TextEditingController(
      text: userProfile?.firstName ?? '',
    );

    lastNameController = TextEditingController(
      text: userProfile?.lastName ?? '',
    );

    phoneController = PhoneController(
      initialValue: const PhoneNumber(
        isoCode: IsoCode.SY,
        nsn: "",
      ),
    );

    descriptionController = TextEditingController();
    notesController = TextEditingController();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    descriptionController.dispose();
    notesController.dispose();
    super.dispose();
  }

  // --- Logic ---

  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          orderImage = File(pickedFile.path);
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

  void submitOrder() {
    if (formKey.currentState!.validate()) {
      // Unfocus keyboard
      FocusScope.of(context).unfocus();

      final orderModel = OrderProductModel(
          firstNameController.text,
          lastNameController.text,
          "00${phoneController.value.countryCode}${phoneController.value.nsn}",
          descriptionController.text,
          notesController.text,
          orderImage);
      showAwesomeDialogForConfirm(ordermodel: orderModel);
    }
  }

  // --- Dialogs ---

  void showAwesomeDialogForConfirm({required OrderProductModel ordermodel}) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      title: "confirm_product".tr(context),
      btnOkText: "yes".tr(context),
      btnCancelText: "no".tr(context),
      btnOkOnPress: () {
        context.read<OrderProductCubit>().sendOrder(ordermodel);
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
      title: "success".tr(context),
      desc: message,
      btnOkOnPress: () {
        Navigator.of(context).pop();
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    // Keep existing logic for updating phone if profile loads late
    final userProfile = context.read<GetUserCubit>().userProfile;
    if (userProfile != null) {
      phoneController.changeNationalNumber(userProfile.phone);
    }

    return BlocListener<OrderProductCubit, OrderProductState>(
      listener: (context, state) {
        if (state is OrderProductSuccess) {
          showSuccessDialog(message: state.msg);
          formKey.currentState!.reset();
          setState(() {
            imageUploaded = false;
            orderImage = null;
          });
          // Clear text manually if needed
          descriptionController.clear();
          notesController.clear();
        } else if (state is OrderProductError) {
          CustomSnackBar.showMessage(
            context,
            state.error,
            Colors.red,
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: AppBar(
          foregroundColor: Colors.black87,
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'order_product'.tr(context),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textTitleAppBarColor,
              fontSize: 14.sp,
            ),
          ),
        ),
        body: SingleChildScrollView(
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
                    Icon(Icons.lightbulb_outline,
                        color: AppColors.primaryColors),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        "sell_product_hint".tr(context),
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

              // --- 2. Request Details Form ---

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
                child: OrderProductForm(
                  formKey: formKey,
                  firstNameController: firstNameController,
                  lastNameController: lastNameController,
                  phoneController: phoneController,
                  descriptionController: descriptionController,
                  notesController: notesController,
                ),
              ),

              SizedBox(height: 3.h),

              // --- 3. Image Reference Section ---

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
                        // Add Dotted styling visually or assume solid for standard
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
                          'upload_photo_info'.tr(context),
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
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          orderImage!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Gradient Overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.05),
                                Colors.transparent,
                              ]),
                        ),
                      ),
                    ),
                    // Delete Button
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            orderImage = null;
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
                text: 'submit'.tr(context),
                icon: Icons.check_circle_outline_rounded,
                color: AppColors.primaryColors,
                onPressed: submitOrder,
              ),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
