import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_comm/Future/Home/Cubits/sell_product_cubit/sell_product_cubit.dart';

import 'package:e_comm/Utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:sizer/sizer.dart';

import '../../../Utils/colors.dart';
import '../../../Utils/constants.dart';
import '../../Auth/Widgets/my_button_widget.dart';
import '../Widgets/custom_note_label.dart';
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
    nameController = TextEditingController();

    productNameController = TextEditingController();

    phoneController = PhoneController(
        initialValue: const PhoneNumber(isoCode: IsoCode.SY, nsn: ""));

    descriptionController = TextEditingController();

    priceController = TextEditingController();

    super.initState();
  }

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

  void showAwesomeDialogForConfirm({
    required SellProductModel sellProduct,
  }) async {
    await AwesomeDialog(
            descTextStyle: TextStyle(fontSize: 15.sp),
            btnOkText: "yes".tr(context),
            btnCancelText: "no".tr(context),
            context: context,
            dialogType: DialogType.infoReverse,
            animType: AnimType.scale,
            title: "confirm_product".tr(context),
            btnOkOnPress: () {
              context.read<SellProductCubit>().sendProduct(sellProduct);
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

  @override
  void dispose() {
    nameController.dispose();
    productNameController.dispose();
    phoneController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SellProductCubit, SellProductState>(
      listener: (context, state) {
        if (state is SellProductSuccess) {
          showAwesomeDialog(message: state.msg);
          key1.currentState!.reset();
          setState(() {
            imageUploaded = false;
            productImage = null;
          });
        } else if (state is SellProductError) {
          CustomSnackBar.showMessage(
            context,
            state.error,
            Colors.red,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          scrolledUnderElevation: 0,
          backgroundColor: AppColors.primaryColors,
          centerTitle: true,
          title: Text(
            'sell_product_screen_title'.tr(context),
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: CustomNoteLabel(
                noteText: "sell_product_not".tr(context),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.h),
              child: Text(
                "sell_product_hint".tr(context),
                style: TextStyle(fontSize: 12.sp, color: Colors.black),
              ),
            ),
            SellProductForm(
                key1: key1,
                nameController: nameController,
                productNameController: productNameController,
                phoneController: phoneController,
                priceController: priceController,
                descriptionController: descriptionController),
            GestureDetector(
              onTap: pickImage,
              child: Container(
                margin: const EdgeInsets.all(25),
                height: 75,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 234, 240, 255),
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'upload_photo_info'.tr(context),
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                    const Icon(
                      Icons.file_upload_outlined,
                      size: 27,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ),
            if (imageUploaded && productImage != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          image: DecorationImage(
                              image: FileImage(productImage!),
                              fit: BoxFit.cover)),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            productImage = null;
                            imageUploaded = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            MyButtonWidget(
              color: AppColors.buttonCategoryColor,
              verticalHieght: 2.h,
              text: 'send_info'.tr(context),
              onPressed: submit,
              horizontalWidth: 8.w,
            ),
            // Container(
            //   margin: const EdgeInsets.all(15),
            //   decoration: BoxDecoration(
            //       color: AppColors.primaryColors,
            //       borderRadius: BorderRadius.circular(10)),
            //   height: 75,
            //   child: TextButton(
            //     onPressed: submit,
            //     child: Text(
            //       'send_info'.tr(context),
            //       style: const TextStyle(
            //           color: Colors.white,
            //           fontWeight: FontWeight.w500,
            //           fontSize: 20),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
