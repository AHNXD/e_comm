import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:e_comm/Utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:sizer/sizer.dart';

import '../../../Utils/colors.dart';
import '../../../Utils/constants.dart';

import '../../Auth/Widgets/my_button_widget.dart';
import '../Cubits/print_image_cubit/print_image_cubit.dart';
import '../Widgets/print_image/print_image_form.dart';
import '../models/print_image_model.dart';

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
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    provinceController = TextEditingController();
    regionController = TextEditingController();
    addressController = TextEditingController();

    phoneController = PhoneController(
        initialValue: const PhoneNumber(isoCode: IsoCode.SY, nsn: ""));

    quantityController = TextEditingController();

    printSizeIdController = TextEditingController();
    super.initState();
  }

  Future<void> submit() async {
    if (key1.currentState!.validate()) {
      if (imageUploaded && productImage != null) {
        final int? quantity = int.tryParse(quantityController.text);
        if (quantity == null) {
          showMessage(
              Colors.red[400]!,
              lang == 'en'
                  ? "Please enter a valid number"
                  : "الرجاء ادخال رقم صحيح");
          return;
        }

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

        context.read<PrintImageCubit>().sendPrintImageOrder(printOrder);
      } else {
        showMessage(Colors.red[400]!,
            'please_upload_an_image_before_submitting'.tr(context));
      }
    } else {
      showMessage(Colors.red[400]!, 'failed_to_add_product'.tr(context));
    }
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
        showMessage(Colors.green[400]!, "image_uploded".tr(context));
      }
    } catch (e) {
      showMessage(Colors.red[400]!, "image_isn't_upoalded".tr(context));
    }
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showMessage(
      Color color, String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: Container(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(2.w)),
            margin: EdgeInsets.symmetric(horizontal: 0.1.w),
            child: Text(
              message,
              textAlign: TextAlign.center,
            ),
          ),
          duration: const Duration(seconds: 3)),
    );
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<PrintImageCubit, PrintImageState>(
      listener: (context, state) {
        if (state is PrintImageSuccess) {
          showAwesomeDialog(message: state.msg);
          key1.currentState!.reset();
          setState(() {
            imageUploaded = false;
            productImage = null;
          });
        } else if (state is PrintImageError) {
          showMessage(Colors.red[400]!, state.error);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          scrolledUnderElevation: 0,
          backgroundColor: AppColors.primaryColors,
          centerTitle: true,
          title: Text(
            'print_image_order_btn'.tr(context),
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.h),
              child: Text(
                "sell_product_hint".tr(context),
                style: TextStyle(fontSize: 12.sp, color: Colors.black),
              ),
            ),
            PrintImageForm(
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
                      'upload_img'.tr(context),
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
              text: 'print_img'.tr(context),
              onPressed: submit,
              horizontalWidth: 8.w,
            )
            // Container(
            //   margin: const EdgeInsets.all(15),
            //   decoration: BoxDecoration(
            //       color: AppColors.primaryColors,
            //       borderRadius: BorderRadius.circular(10)),
            //   height: 75,
            //   child: TextButton(
            //     onPressed: submit,
            //     child: Text(
            //       'print_img'.tr(context),
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
