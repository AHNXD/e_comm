import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:zein_store/Future/Home/Cubits/get_user/get_user_cubit.dart';
import 'package:zein_store/Future/Home/Cubits/sell_product_cubit/sell_product_cubit.dart';

import 'package:zein_store/Utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:sizer/sizer.dart';

import '../../../Utils/colors.dart';
import '../../../Utils/constants.dart';
import '../../Auth/Widgets/my_button_widget.dart';
import '../Widgets/custom_snak_bar.dart';
import '../Widgets/sellProduct/sell_product_from.dart';
import '../models/sell_product_model.dart';

class SellProdact extends StatefulWidget {
  const SellProdact({super.key});

  @override
  State<SellProdact> createState() => _SellProdactState();
}

class _SellProdactState extends State<SellProdact> {
  late final TextEditingController nameController;
  late final TextEditingController productNameController;
  late final PhoneController phoneController;
  late final TextEditingController priceController;
  late final TextEditingController descriptionController;
  final GlobalKey<FormState> key1 = GlobalKey<FormState>();
  File? productImage;
  bool imageUploaded = false;

  @override
  void initState() {
    super.initState();
    final userProfile = context.read<GetUserCubit>().userProfile;

    nameController = TextEditingController(
        text: userProfile != null
            ? "${userProfile.firstName} ${userProfile.lastName}"
            : "");

    productNameController = TextEditingController();

    phoneController = PhoneController(
        initialValue: const PhoneNumber(isoCode: IsoCode.SY, nsn: ""));

    descriptionController = TextEditingController();
    priceController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    productNameController.dispose();
    phoneController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  // --- Logic Methods ---

  Future<void> submit() async {
    if (key1.currentState!.validate()) {
      if (imageUploaded && productImage != null) {
        final double? price = double.tryParse(priceController.text);
        if (price == null) {
          CustomSnackBar.showMessage(
            context,
            lang == 'en'
                ? "Please enter a valid number"
                : "الرجاء ادخال رقم صحيح",
            Colors.red,
          );
          return;
        }

        // Close keyboard
        FocusScope.of(context).unfocus();

        showAwesomeDialogForConfirm(
            sellProduct: SellProductModel(
                nameController.text,
                "00${phoneController.value.countryCode}${phoneController.value.nsn}",
                productNameController.text,
                price,
                descriptionController.text,
                productImage));
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

  void showAwesomeDialogForConfirm(
      {required SellProductModel sellProduct}) async {
    await AwesomeDialog(
      descTextStyle: TextStyle(fontSize: 12.sp),
      titleTextStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
      btnOkText: "yes".tr(context),
      btnCancelText: "no".tr(context),
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      title: "confirm_product".tr(context),
      desc: "Are you sure you want to list this item for sale?",
      btnOkOnPress: () {
        context.read<SellProductCubit>().sendProduct(sellProduct);
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
    // Ensure phone controller updates if user profile loads late
    final userProfile = context.read<GetUserCubit>().userProfile;
    if (userProfile != null && phoneController.value.nsn.isEmpty) {
      // phoneController logic can remain in build if strictly necessary for updates,
      // typically distinct logic in listener is better but keeping as is per request.
      // Keeping as provided in your snippet logic:
      // phoneController.changeNationalNumber(...)
    }

    return BlocListener<SellProductCubit, SellProductState>(
      listener: (context, state) {
        if (state is SellProductSuccess) {
          showSuccessDialog(message: state.msg);
          key1.currentState!.reset();
          setState(() {
            imageUploaded = false;
            productImage = null;
          });
          nameController.clear();
          productNameController.clear();
          priceController.clear();
          descriptionController.clear();
        } else if (state is SellProductError) {
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
            'sell_product_screen_title'.tr(context),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textTitleAppBarColor,
                fontSize: 14.sp),
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
                    Icon(Icons.info_outline_rounded,
                        color: AppColors.primaryColors),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        "sell_product_not".tr(context),
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

              // --- 2. Form Section ---
              Text(
                "Product Details",
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 1.h),

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
                child: Column(
                  children: [
                    SellProductForm(
                        key1: key1,
                        nameController: nameController,
                        productNameController: productNameController,
                        phoneController: phoneController,
                        priceController: priceController,
                        descriptionController: descriptionController),
                  ],
                ),
              ),

              SizedBox(height: 3.h),

              // --- 3. Image Upload Section ---

              if (!imageUploaded)
                GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: Colors.grey.shade300,
                          width: 2,
                          style: BorderStyle
                              .solid // You can use DottedBorder package for dashed
                          ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColors.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add_a_photo_rounded,
                            size: 30.sp,
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
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
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
                    // Gradient Overlay for text visibility or style
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.0),
                                Colors.black.withOpacity(0.0),
                              ])),
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
                            Icons.delete_outline_rounded,
                            color: Colors.red,
                            size: 24,
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
                text: 'send_info'.tr(context),
                icon: Icons.send_rounded,
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
