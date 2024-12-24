import 'package:e_comm/Future/Home/Blocs/get_categories/get_categories_bloc.dart';
import 'package:e_comm/Future/Home/Blocs/get_favorite/get_favorite_bloc.dart';
import 'package:e_comm/Future/Home/Blocs/get_latest_products/get_latest_products_bloc.dart';
import 'package:e_comm/Future/Home/Blocs/get_my_orders/get_my_orders_bloc.dart';
import 'package:e_comm/Future/Home/Blocs/get_offers/get_offers_bloc.dart';

import 'package:e_comm/Future/Home/Blocs/get_products_by_cat_id/get_products_by_cat_id_bloc.dart';
import 'package:e_comm/Future/Home/Cubits/cancel_filter/cancel_filter_button_cubit.dart';
import 'package:e_comm/Future/Home/Cubits/delete_profile/delete_profile_cubit.dart';
import 'package:e_comm/Future/Home/Cubits/get_min_max_cubit/get_min_max_cubit.dart';
import 'package:e_comm/Future/Home/Cubits/get_user/get_user_cubit.dart';
import 'package:e_comm/Future/Home/Cubits/mange_search_filter_products/mange_search_filter_products_cubit.dart';
import 'package:e_comm/conditions.dart';
import 'package:e_comm/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sizer/sizer.dart';

import 'package:e_comm/Future/Home/Cubits/Maintenance/maintenance_cubit.dart';
import 'package:e_comm/Future/Home/Cubits/aboutUs/about_us_cubit.dart';
import 'package:e_comm/Future/Home/Cubits/all_proudcts_by_all_cat/all_products_by_all_category_cubit.dart';
import 'package:e_comm/Future/Home/Cubits/contactUsCubit/contact_us_cubit.dart';
import 'package:e_comm/Future/Home/Cubits/favoriteCubit/favorite_cubit.dart';
import 'package:e_comm/Future/Home/Cubits/getProducts/get_products_cubit.dart';
import 'package:e_comm/Future/Home/Cubits/get_print_sizes_cubit/get_print_sizes_cubit.dart';
import 'package:e_comm/Future/Home/Cubits/locale/locale_cubit.dart';
import 'package:e_comm/Future/Home/Cubits/print_image_cubit/print_image_cubit.dart';
import 'package:e_comm/Future/Home/Cubits/sell_product_cubit/sell_product_cubit.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/Utils/colors.dart';

import '/Apis/Network.dart';
import '/Future/Auth/cubit/auth_cubit.dart';
import '/Utils/SharedPreferences/SharedPreferencesHelper.dart';
import 'Future/Home/Blocs/search_filter_products/search_filter_poducts_bloc.dart';
import 'Future/Home/Blocs/search_products/search_products_bloc.dart';
import 'Future/Home/Cubits/CompairPruductsCubit/compair_products_cubit.dart';
import 'Future/Home/Cubits/cartCubit/cart.bloc.dart';
import 'Future/Home/Cubits/edit_profile/edit_profile_cubit.dart';
import 'Future/Home/Cubits/getCatigories/get_catigories_cubit.dart';
import 'Future/Home/Cubits/pages_cubit/pages_cubit.dart';
import 'Future/Home/Cubits/postOrders/post_orders_cubit.dart';
import 'Future/Home/Cubits/rangeSliderCubit/range_slider_cubit.dart';
import 'Utils/enums.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSharedPreferences.init();
  await Network.init();
  // AppSharedPreferences.saveToken(
  //     "96|BdyqtuKyMt7rXbHxGsCZ7PJq4NWvb2tmA3BPA70aee914310");
  debugPrint("token is ${AppSharedPreferences.getToken}");

  runApp(const MyApp());
}

final scaffoldKey = GlobalKey<ScaffoldState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<dynamic> onBackPressed(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('are_you_sure'.tr(context)),
        content: Text('do_you_want_to_exit_the_app'.tr(context)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('no'.tr(context)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('yes'.tr(context)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => LocaleCubit()..getSaveLanguage()),
          BlocProvider(create: (_) => AuthCubit()..checkFirstUse()),
          BlocProvider(create: (_) => GetUserCubit()..getUserProfile()),
          BlocProvider(
              create: (_) => GetMyOrdersBloc()..add(GetAllMyOrdersEvent())),
          BlocProvider(
              create: (_) => GetFavoriteBloc()..add(GetAllFavoriteEvent())),
          BlocProvider(
              create: (_) => GetOffersBloc()..add(GetAllOffersEvent())),
          BlocProvider(
              create: (_) => GetCategoriesBloc()..add(GetAllCategoriesEvent())),
          BlocProvider(
              create: (_) => CartCubit()..refreshCartOnLanguageChange()),
          BlocProvider(
            create: (_) => GetPrintSizesCubit()..getPrintSizes(),
          ),
          BlocProvider(
              create: (_) =>
                  GetLatestProductsBloc()..add(GetAllLatestProductsEvent())),
          BlocProvider(create: (_) => GetCatigoriesCubit()),
          BlocProvider(create: (_) => GetProductsCubit()),
          BlocProvider(create: (_) => FavoriteCubit()),
          BlocProvider(create: (_) => RangeSliderCubit()),
          BlocProvider(create: (_) => CompairProductsCubit()),
          BlocProvider(create: (_) => PostOrdersCubit()),
          BlocProvider(create: (_) => GetProductsByCatIdBloc()),
          BlocProvider(create: (_) => AboutUsCubit()),
          BlocProvider(create: (_) => MaintenanceCubit()),
          BlocProvider(create: (_) => ContactUsCubit()),
          BlocProvider(
              create: (_) =>
                  PagesScreenCubit()..changedScreen(AppScreen.home, context)),
          BlocProvider(create: (_) => SearchProductsBloc()),
          BlocProvider(create: (_) => SellProductCubit()),
          BlocProvider(create: (_) => PrintImageCubit()),
          BlocProvider(create: (_) => AllProductsByAllCategoryCubit()),
          BlocProvider(
            create: (_) => GetMinMaxCubit(),
          ),
          BlocProvider(
            create: (_) => SearchFilterPoductsBloc(),
          ),
          BlocProvider(create: (_) => MangeSearchFilterProductsCubit()),
          BlocProvider(create: (_) => EditProfileCubit()),
          BlocProvider(create: (_) => DeleteProfileCubit()),
          BlocProvider(create: (_) => CancelFilterButtonCubit())
        ],
        child: BlocBuilder<LocaleCubit, ChangeLocaleState>(
          builder: (context, state) {
            return MaterialApp(
                locale: state.locale,
                supportedLocales: const [
                  Locale("en"),
                  Locale("ar"),
                ],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                localeResolutionCallback: (deviceLocal, supportedLocales) {
                  for (var locale in supportedLocales) {
                    if (deviceLocal != null &&
                        deviceLocal.languageCode == locale.languageCode) {
                      return deviceLocal;
                    }
                  }
                  return supportedLocales.first;
                },
                debugShowCheckedModeBanner: false,
                title: 'E-Commerce',
                theme: ThemeData(
                  fontFamily: "cocon-next-arabic",
                  colorScheme:
                      ColorScheme.fromSeed(seedColor: AppColors.primaryColors),
                  // useMaterial3: true,
                ),
                home: const SplashScreen());
          },
        ),
      ),
    );
  }
}
