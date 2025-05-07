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
    final userProfile = context.read<GetUserCubit>().userProfile;

    firstNameController = TextEditingController(
      text: userProfile?.firstName ?? '',
    );

    lastNameController = TextEditingController(
      text: userProfile?.lastName ?? '',
    );

    phoneController = PhoneController(
      initialValue: PhoneNumber(
        isoCode: IsoCode.SY,
        nsn: "",
      ),
    );

    descriptionController = TextEditingController();
    notesController = TextEditingController();

    super.initState();
  }

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

  void showAwesomeDialogForConfirm({required OrderProductModel ordermodel}) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.infoReverse,
      title: "confirm_product".tr(context),
      btnOkText: "yes".tr(context),
      btnCancelText: "no".tr(context),
      btnOkOnPress: () {
        context.read<OrderProductCubit>().sendOrder(ordermodel);
      },
      btnCancelOnPress: () {},
    ).show();
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
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    descriptionController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    phoneController.changeNationalNumber(
        context.read<GetUserCubit>().userProfile != null
            ? context.read<GetUserCubit>().userProfile!.phone
            : "");
    return BlocListener<OrderProductCubit, OrderProductState>(
      listener: (context, state) {
        if (state is OrderProductSuccess) {
          showAwesomeDialog(message: state.msg);
          formKey.currentState!.reset();
          setState(() {
            imageUploaded = false;
            orderImage = null;
          });
        } else if (state is OrderProductError) {
          CustomSnackBar.showMessage(
            context,
            state.error,
            Colors.red,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('order_product'.tr(context)),
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primaryColors,
          centerTitle: true,
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
            OrderProductForm(
              formKey: formKey,
              firstNameController: firstNameController,
              lastNameController: lastNameController,
              phoneController: phoneController,
              descriptionController: descriptionController,
              notesController: notesController,
            ),
            _buildImageUploadSection(),
            if (imageUploaded && orderImage != null)
              _buildUploadedImagePreview(),
            MyButtonWidget(
              text: 'submit'.tr(context),
              onPressed: submitOrder,
              color: AppColors.primaryColors,
              verticalHieght: 2.h,
              horizontalWidth: 8.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return GestureDetector(
      onTap: pickImage,
      child: Container(
        margin: EdgeInsets.all(4.w),
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 234, 240, 255),
          borderRadius: BorderRadius.circular(12),
        ),
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
            Icon(
              Icons.file_upload_outlined,
              color: AppColors.textButtonColors,
              size: 27,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadedImagePreview() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              orderImage!,
              width: double.infinity,
              height: 30.h,
              fit: BoxFit.cover,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.red),
            onPressed: () => setState(() {
              orderImage = null;
              imageUploaded = false;
            }),
          ),
        ],
      ),
    );
  }
}
