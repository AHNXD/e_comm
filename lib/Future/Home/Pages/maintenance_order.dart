import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:zein_store/Future/Auth/Widgets/my_button_widget.dart';
import 'package:zein_store/Future/Home/Cubits/Maintenance/maintenance_cubit.dart';
import 'package:zein_store/Future/Home/Widgets/Maintenance/maintenace_from.dart';
import 'package:zein_store/Future/Home/models/maintenace_model.dart';
import 'package:zein_store/Utils/app_localizations.dart';
import 'package:zein_store/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:sizer/sizer.dart';

import '../Cubits/get_user/get_user_cubit.dart';
import '../Widgets/custom_snak_bar.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  late final TextEditingController FNController;
  late final TextEditingController LNController;
  late final PhoneController phoneController;
  late final TextEditingController provinceController;
  late final TextEditingController regionController;
  late final TextEditingController addressController;
  late final TextEditingController problemController;
  late final TextEditingController descriptionController;

  final GlobalKey<FormState> key1 = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final userProfile = context.read<GetUserCubit>().userProfile;

    FNController = TextEditingController(text: userProfile?.firstName ?? "");
    LNController = TextEditingController(text: userProfile?.lastName ?? "");

    phoneController = PhoneController(
        initialValue: const PhoneNumber(isoCode: IsoCode.SY, nsn: ""));

    provinceController = TextEditingController();
    regionController = TextEditingController();
    addressController = TextEditingController(text: userProfile?.address ?? "");
    problemController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    FNController.dispose();
    LNController.dispose();
    phoneController.dispose();
    provinceController.dispose();
    regionController.dispose();
    addressController.dispose();
    problemController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (key1.currentState!.validate()) {
      // Unfocus keyboard
      FocusScope.of(context).unfocus();

      showAwesomeDialogForConfirm(
          order: MaintenaceModel(
              firstName: FNController.text,
              lastName: LNController.text,
              phone:
                  "00${phoneController.value.countryCode}${phoneController.value.nsn}",
              province: provinceController.text,
              region: regionController.text,
              address: addressController.text,
              problemCause: problemController.text,
              description: descriptionController.text));
    } else {
      CustomSnackBar.showMessage(
        context,
        'error_msg'.tr(context),
        Colors.red,
      );
    }
  }

  // --- Dialogs ---

  void showAwesomeDialogForConfirm({required MaintenaceModel order}) async {
    await AwesomeDialog(
      descTextStyle: TextStyle(fontSize: 12.sp),
      titleTextStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
      btnOkText: "yes".tr(context),
      btnCancelText: "no".tr(context),
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      title: "confirm_info".tr(context),
      btnOkOnPress: () {
        context.read<MaintenanceCubit>().sendMaintenanceOrder(order);
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
    // Keep user phone update logic
    final userProfile = context.read<GetUserCubit>().userProfile;
    if (userProfile != null) {
      phoneController.changeNationalNumber(userProfile.phone);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Light Grey Background
      appBar: AppBar(
        foregroundColor: Colors.black87,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'maintenance_btn'.tr(context),
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textTitleAppBarColor,
          ),
        ),
      ),
      body: BlocListener<MaintenanceCubit, MaintenanceState>(
        listener: (context, state) {
          if (state is MaintenanceSuccess) {
            showSuccessDialog(message: state.msg);
            key1.currentState!.reset();
            // Optional: Clear controllers manually if reset doesn't cover everything
            problemController.clear();
            descriptionController.clear();
          } else if (state is MaintenanceError) {
            CustomSnackBar.showMessage(context, state.error, Colors.red);
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
                    Icon(Icons.build_circle_outlined,
                        color: AppColors.primaryColors),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        "sell_product_hint".tr(
                            context), // Assuming this key contains relevant info
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
                child: MaintenaceForm(
                    key1: key1,
                    FNController: FNController,
                    LNController: LNController,
                    phoneController: phoneController,
                    provinceController: provinceController,
                    regionController: regionController,
                    addressController: addressController,
                    problemController: problemController,
                    descriptionController: descriptionController),
              ),

              SizedBox(height: 5.h),

              // --- 3. Submit Button ---
              MyButtonWidget(
                color: AppColors.buttonCategoryColor,
                text: 'submit'.tr(context),
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
