// ignore_for_file: avoid_function_literals_in_foreach_calls
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_comm/Future/Home/models/order_information.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../Future/Auth/Widgets/text_field_widget.dart';
import '../Future/Home/Cubits/postOrders/post_orders_cubit.dart';

void massege(BuildContext context, String error, Color c) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.symmetric(
      horizontal: 3.w,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.w)),
    backgroundColor: c,
    content: Center(child: Text(error)),
    duration: const Duration(seconds: 2),
  ));
}

void showAwesomeDialogForAskCode(
    {required BuildContext context,
    required OrderInformation order,
    required TextEditingController codeController}) async {
  await AwesomeDialog(
    descTextStyle: TextStyle(fontSize: 15.sp),
    btnOkText: "yes".tr(context),
    btnCancelText: "no".tr(context),
    context: context,
    dialogType: DialogType.infoReverse,
    animType: AnimType.scale,
    title: 'cobon_code_title'.tr(context),
    desc: 'cobon_code_msg'.tr(context),
    btnCancelOnPress: () {
      order.code = "";
      context.read<PostOrdersCubit>().sendOrder(order);
    },
    btnOkOnPress: () async {
      await AwesomeDialog(
        body: TextFieldWidget(
          text: "enter_code".tr(context),
          controller: codeController,
          isPassword: false,
        ),
        descTextStyle: TextStyle(fontSize: 15.sp, color: Colors.black),
        btnOkText: "confirm".tr(context),
        context: context,
        dialogType: DialogType.infoReverse,
        animType: AnimType.scale,
        title: 'cobon_code_title'.tr(context),
        desc: 'cobon_code_msg'.tr(context),
        btnOkOnPress: () {
          order.code = codeController.text.trim();
          context.read<PostOrdersCubit>().sendOrder(order);
        },
      ).show();
    },
  ).show();
}

NumberFormat formatter = NumberFormat('#,###');
// void getAllApiInMainPage(BuildContext context) {
//   BlocProvider.of<GetOffersCubit>(context).getOffers();
//   BlocProvider.of<GetCatigoriesCubit>(context).getCatigories();
//   BlocProvider.of<GetProductsCubit>(context).getProducts();
//   BlocProvider.of<FavoriteCubit>(context).getProductsFavorite();
// }
