import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_comm/Future/Auth/Widgets/my_button_widget.dart';
import 'package:e_comm/Future/Home/Cubits/Maintenance/maintenance_cubit.dart';
import 'package:e_comm/Future/Home/Widgets/Maintenance/maintenace_from.dart';
import 'package:e_comm/Future/Home/models/maintenace_model.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:sizer/sizer.dart';

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
    FNController = TextEditingController();
    LNController = TextEditingController();
    phoneController = PhoneController(
        initialValue: const PhoneNumber(isoCode: IsoCode.SY, nsn: ""));
    provinceController = TextEditingController();
    regionController = TextEditingController();
    addressController = TextEditingController();
    problemController = TextEditingController();
    descriptionController = TextEditingController();
    super.initState();
  }

  Future<void> submit() async {
    if (key1.currentState!.validate()) {
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
      showMessage(Colors.red[400]!, 'error_msg'.tr(context));
    }
  }

  void showAwesomeDialogForConfirm({
    required MaintenaceModel order,
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
              context.read<MaintenanceCubit>().sendMaintenanceOrder(order);
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
          duration: const Duration(seconds: 5)),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.primaryColors,
        centerTitle: true,
        title: Text(
          'maintenance_btn'.tr(context),
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: BlocListener<MaintenanceCubit, MaintenanceState>(
        listener: (context, state) {
          if (state is MaintenanceSuccess) {
            showAwesomeDialog(message: state.msg);
            key1.currentState!.reset();
          } else if (state is MaintenanceError) {
            showMessage(Colors.red[400]!, state.error);
          }
        },
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.h),
              child: Text(
                "sell_product_hint".tr(context),
                style: TextStyle(fontSize: 12.sp, color: Colors.black),
              ),
            ),
            MaintenaceForm(
                key1: key1,
                FNController: FNController,
                LNController: LNController,
                phoneController: phoneController,
                provinceController: provinceController,
                regionController: regionController,
                addressController: addressController,
                problemController: problemController,
                descriptionController: descriptionController),

            MyButtonWidget(
              color: AppColors.buttonCategoryColor,
              verticalHieght: 2.h,
              text: 'submit'.tr(context),
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
