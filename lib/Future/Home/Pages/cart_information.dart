import 'package:zein_store/Future/Home/Cubits/cartCubit/cart.bloc.dart';
import 'package:zein_store/Future/Home/Pages/navbar_screen.dart';
import 'package:zein_store/Future/Home/Widgets/custom_snak_bar.dart';
import 'package:zein_store/Future/Home/models/order_information.dart';
import 'package:zein_store/Utils/app_localizations.dart';
import '../Cubits/get_user/get_user_cubit.dart';
import '/Future/Auth/Widgets/my_button_widget.dart';
import '/Future/Auth/Widgets/phone_field_widget.dart';
import '/Future/Auth/Widgets/text_field_widget.dart';
import '/Utils/colors.dart';
import '/Utils/enums.dart';
import '/Utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:sizer/sizer.dart';
import '../../../Utils/app_lottie_assets_manager.dart';
import '../../../Utils/functions.dart';
import '../Cubits/postOrders/post_orders_cubit.dart';

class CartInformation extends StatefulWidget {
  const CartInformation({super.key});

  @override
  State<CartInformation> createState() => _CartInformationState();
}

class _CartInformationState extends State<CartInformation> {
  late final TextEditingController firstNameController;

  late final TextEditingController lastNameController;

  late final PhoneController phoneController;

  late final TextEditingController address1Controller;

  late final TextEditingController address2Controller;

  late final TextEditingController countryController;

  late final TextEditingController cityController;

  late final TextEditingController noteController;

  late final TextEditingController codeController;

  final GlobalKey<FormState> key1 = GlobalKey<FormState>();
  @override
  void initState() {
    firstNameController = TextEditingController(
        text: context.read<GetUserCubit>().userProfile != null
            ? context.read<GetUserCubit>().userProfile!.firstName
            : "");

    lastNameController = TextEditingController(
        text: context.read<GetUserCubit>().userProfile != null
            ? context.read<GetUserCubit>().userProfile!.lastName
            : "");

    phoneController = PhoneController(
        initialValue: const PhoneNumber(isoCode: IsoCode.SY, nsn: ""));

    address1Controller = TextEditingController(
        text: context.read<GetUserCubit>().userProfile != null
            ? context.read<GetUserCubit>().userProfile!.address
            : "");

    address2Controller = TextEditingController();

    countryController = TextEditingController();

    cityController = TextEditingController();

    noteController = TextEditingController();

    codeController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();

    lastNameController.dispose();

    phoneController.dispose();

    address1Controller.dispose();

    address2Controller.dispose();

    countryController.dispose();

    cityController.dispose();

    noteController.dispose();

    codeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    phoneController.changeNationalNumber(
        context.read<GetUserCubit>().userProfile != null
            ? context.read<GetUserCubit>().userProfile!.phone
            : "");
    return BlocConsumer<GetUserCubit, GetUserState>(
      listener: (context, state) {
        if (state is GetUserSuccess) {
          phoneController.changeNationalNumber(state.userProfile.phone);
          firstNameController.text = state.userProfile.firstName!;
          lastNameController.text = state.userProfile.lastName!;
          address1Controller.text = state.userProfile.address!;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: AppColors.primaryColors,
            foregroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              "confirm_orders".tr(context),
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          body: BlocConsumer<PostOrdersCubit, PostOrdersState>(
            listener: (context, state) {
              if (state is PostOrdersSuccessfulState) {
                CustomSnackBar.showMessage(
                    context,
                    "the_order_was_send_successfully".tr(context),
                    Colors.green);
                context.read<CartCubit>().refreshCartOnLanguageChange();
                Navigator.pop(context);
              } else if (state is PostOrdersErrorState) {
                CustomSnackBar.showMessage(context, state.msg, Colors.red);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (builder) {
                    return const NavBarPage();
                  }),
                  (route) => false,
                );
              }
            },
            builder: (context, state) {
              return ModalProgressHUD(
                color: Colors.black,
                progressIndicator: Lottie.asset(
                    AppLottieAssetsManager.telegramLoadingAnimation,
                    animate: true,
                    repeat: true),
                inAsyncCall: state is PostOrdersLoadingState,
                child: ListView(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.h),
                      child: Text(
                        "please_enter_your_information_to_check_order"
                            .tr(context),
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                      child: Form(
                        key: key1,
                        child: Column(
                          children: [
                            TextFieldWidget(
                                validatorFun: (p0) =>
                                    validation(p0, ValidationState.normal),
                                text: "FN_info".tr(context),
                                isPassword: false,
                                controller: firstNameController),
                            TextFieldWidget(
                                validatorFun: (p0) =>
                                    validation(p0, ValidationState.normal),
                                text: "LN_info".tr(context),
                                isPassword: false,
                                controller: lastNameController),
                            PhoneFieldWidget(controller: phoneController),
                            TextFieldWidget(
                                validatorFun: (p0) =>
                                    validation(p0, ValidationState.normal),
                                text: "province".tr(context),
                                isPassword: false,
                                controller: countryController),
                            TextFieldWidget(
                                validatorFun: (p0) =>
                                    validation(p0, ValidationState.normal),
                                text: "region".tr(context),
                                isPassword: false,
                                controller: cityController),
                            TextFieldWidget(
                                validatorFun: (p0) =>
                                    validation(p0, ValidationState.normal),
                                text: "address".tr(context),
                                isPassword: false,
                                controller: address1Controller),
                            TextFieldWidget(
                                text: "note".tr(context),
                                isPassword: false,
                                controller: noteController),
                            MyButtonWidget(
                                text: "send_order".tr(context),
                                onPressed: () async {
                                  if (key1.currentState!.validate()) {
                                    showAwesomeDialogForAskCode(
                                        context: context,
                                        order: OrderInformation(
                                          code: codeController.text.trim(),
                                          address:
                                              address1Controller.text.trim(),
                                          city: cityController.text,
                                          country: countryController.text,
                                          firstName:
                                              firstNameController.text.trim(),
                                          lastName:
                                              lastNameController.text.trim(),
                                          note: noteController.text,
                                          phone:
                                              "00${phoneController.value.countryCode}${phoneController.value.nsn}",
                                        ),
                                        codeController: codeController);
                                  }
                                },
                                color: AppColors.buttonCategoryColor)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
