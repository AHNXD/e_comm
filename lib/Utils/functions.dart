// ignore_for_file: avoid_function_literals_in_foreach_calls
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_comm/Future/Home/Cubits/cartCubit/cart.bloc.dart';
import 'package:e_comm/Future/Home/Cubits/favoriteCubit/favorite_cubit.dart';
import 'package:e_comm/Future/Home/Cubits/getCatigories/get_catigories_cubit.dart';
import 'package:e_comm/Future/Home/Cubits/searchProductsCubit/search_products_cubit.dart';
import 'package:e_comm/Future/Home/models/catigories_model.dart';
import 'package:e_comm/Future/Home/models/order_information.dart';
import 'package:e_comm/Future/Home/models/product_model.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../Future/Auth/Widgets/text_field_widget.dart';
import '../Future/Home/Cubits/GetCatigoriesOffers/get_catigories_offers_cubit.dart';
import '../Future/Home/Cubits/getProducts/get_products_cubit.dart';
import '../Future/Home/Cubits/postOrders/post_orders_cubit.dart';

List<MainProduct> getGridById(int id, BuildContext context) {
  List<MainProduct> l = <MainProduct>[];
  final m = context.read<GetProductsCubit>().model!.data;
  for (int i = 0; i < m!.length; i++) {
    if (m[i].categoryId == id) {
      l.add(m[i]);
    }
  }
  return l;
}

List<CatigoriesData> getMainCategoryByParentId(CatigoriesModel model) {
  List<CatigoriesData> l = <CatigoriesData>[];
  model.data!.forEach((element) {
    if (element.parentId == 0) {
      l.add(element);
    }
  });
  return l;
}

List<CatigoriesData> getCategoryByParentId(int parentId, BuildContext context) {
  List<CatigoriesData> l = <CatigoriesData>[];
  context.read<GetCatigoriesCubit>().catigoriesModel!.data!.forEach((e) {
    if (e.parentId == parentId) {
      l.add(e);
    }
  });

  return l;
}

List<String> getPruductsName(BuildContext context) {
  List<String> l = <String>[];
  context.read<GetProductsCubit>().model!.data!.forEach((e) {
    l.add(e.name!);
  });
  return l;
}

MainProduct getPruductByName(BuildContext context, String name) {
  MainProduct p = MainProduct();
  context.read<GetProductsCubit>().model!.data!.forEach((e) {
    if (e.name == name) {
      p = e;
    }
  });
  return p;
}

List<MainProduct> getSearchProduct(BuildContext context) {
  return context.read<GetProductsCubit>().model!.data!.where((product) {
    return context
        .read<SearchProductsCubit>()
        .resault
        .data!
        .any((p) => p.id == product.id);
  }).toList();
}

// void getFavorite(BuildContext context) {
//   if (context.read<FavoriteCubit>().fvModel!.data!.isNotEmpty) {
//     final l = context.read<GetProductsCubit>().model!.data!;
//     context.read<FavoriteCubit>().fvModel!.data!.forEach((e) {
//       l[l.indexWhere((product) => product.id! == e.productId)].isFavorite =
//           true;
//       debugPrint("inside ============================================== ");
//     });
//   }
// }

// List<MainProduct> getFavoriteProduct(BuildContext context) {
//   return context
//       .read<GetProductsCubit>()
//       .model!
//       .data!
//       .where((product) => product.isFavorite)
//       .toList();
// }

void showSuccessSnackBar({required String message}) {
  ScaffoldMessenger.of(scaffoldKey.currentState!.context).showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.symmetric(
      horizontal: 3.w,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.w)),
    backgroundColor: Colors.green,
    duration: const Duration(seconds: 3),
    content: Text(message),
  ));
}

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

void showErrorSnackBar({required String message}) {
  ScaffoldMessenger.of(scaffoldKey.currentState!.context).showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.symmetric(
      horizontal: 3.w,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.w)),
    backgroundColor: Colors.red,
    duration: const Duration(seconds: 2),
    content: Text(message),
  ));
}

List<int> getListOfProductsId(BuildContext context) {
  List<int> ids = <int>[];
  context.read<CartCubit>().pcw.forEach((product) {
    ids.add(product.id!);
  });
  return ids;
}

List<int> getListOfProductsQuantity(BuildContext context) {
  List<int> quantity = <int>[];
  context.read<CartCubit>().pcw.forEach((product) {
    quantity.add(product.userQuantity);
  });
  return quantity;
}

List<String?> getListOfProductsSizes(BuildContext context) {
  List<String?> sizes = <String?>[];
  context.read<CartCubit>().pcw.forEach((product) {
    sizes.add(product.selectedSize);
  });
  return sizes;
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
          context.read<PostOrdersCubit>().sendOrder(order);
        },
      ).show();
    },
  ).show();
}

void getAllApiInMainPage(BuildContext context) {
  BlocProvider.of<GetCatigoriesOffersCubit>(context).getOffersCatigories();
  BlocProvider.of<GetCatigoriesCubit>(context).getCatigories();
  BlocProvider.of<GetProductsCubit>(context).getProducts();
  BlocProvider.of<FavoriteCubit>(context).getProductsFavorite();
}
