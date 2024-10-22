import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sizer/sizer.dart';

import 'package:e_comm/Future/Auth/Pages/login_screen.dart';
import 'package:e_comm/Future/Home/Cubits/Maintenance/maintenance_cubit.dart';
import 'package:e_comm/Future/Home/Cubits/aboutUs/about_us_cubit.dart';
import 'package:e_comm/Future/Home/Cubits/all_proudcts_by_all_cat/all_products_by_all_category_cubit.dart';
import 'package:e_comm/Future/Home/Cubits/contactUsCubit/contact_us_cubit.dart';
import 'package:e_comm/Future/Home/Cubits/favoriteCubit/favorite_cubit.dart';
import 'package:e_comm/Future/Home/Cubits/getCatigories/get_catigories_cubit.dart';
import 'package:e_comm/Future/Home/Cubits/getMyOrders/get_my_orders_cubit.dart';
import 'package:e_comm/Future/Home/Cubits/getProductById/get_porduct_by_id_cubit.dart';
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
import 'Future/Home/Cubits/CompairPruductsCubit/compair_products_cubit.dart';
import 'Future/Home/Cubits/GetCatigoriesOffers/get_catigories_offers_cubit.dart';
import 'Future/Home/Cubits/cartCubit/cart.bloc.dart';
import 'Future/Home/Cubits/pages_cubit/pages_cubit.dart';
import 'Future/Home/Cubits/postOrders/post_orders_cubit.dart';
import 'Future/Home/Cubits/rangeSliderCubit/range_slider_cubit.dart';
import 'Future/Home/Cubits/searchProductsCubit/search_products_cubit.dart';
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

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => LocaleCubit()..getSaveLanguage()),
          BlocProvider(
              create: (_) => GetCatigoriesOffersCubit()..getOffersCatigories()),
          BlocProvider(create: (_) => AuthCubit()),
          BlocProvider(create: (_) => GetCatigoriesCubit()..getCatigories()),
          BlocProvider(create: (_) => GetProductsCubit()..getProducts()),
          BlocProvider(create: (_) => FavoriteCubit()..getProductsFavorite()),
          BlocProvider(create: (_) => RangeSliderCubit()),
          BlocProvider(create: (_) => GetMyOrdersCubit()..getMyOrders()),
          BlocProvider(create: (_) => CartCubit()),
          BlocProvider(create: (_) => CompairProductsCubit()),
          BlocProvider(create: (_) => PostOrdersCubit()),
          BlocProvider(create: (_) => GetPorductByIdCubit()),
          BlocProvider(create: (_) => AboutUsCubit()),
          BlocProvider(create: (_) => MaintenanceCubit()),
          BlocProvider(create: (_) => ContactUsCubit()),
          BlocProvider(
              create: (_) =>
                  PagesScreenCubit()..changedScreen(AppScreen.home, context)),
          BlocProvider(
            create: (_) => SearchProductsCubit(),
          ),
          BlocProvider(create: (_) => SellProductCubit()),
          BlocProvider(create: (_) => PrintImageCubit()),
          BlocProvider(create: (_) => AllProductsByAllCategoryCubit()),
          BlocProvider(create: (_) => GetPrintSizesCubit()..getPrintSizes())
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
              home:
                  //  ProductScreen(clickIndex: 2,)
                  // const NavBarPage(),
                  LoginScreen(),
            );
          },
        ),
      ),
    );
  }
}
