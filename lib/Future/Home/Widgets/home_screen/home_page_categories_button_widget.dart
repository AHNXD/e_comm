import 'package:e_comm/Future/Home/Pages/product_screen.dart';
import 'package:e_comm/Future/Home/Widgets/error_widget.dart';
import 'package:e_comm/Future/Home/models/catigories_model.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/Utils/colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../Cubits/getCatigories/get_catigories_cubit.dart';
import '../../Cubits/getProductById/get_porduct_by_id_cubit.dart';

class HomePageCategoriesButtonWidget extends StatefulWidget {
  const HomePageCategoriesButtonWidget({
    super.key,
  });

  @override
  State<HomePageCategoriesButtonWidget> createState() =>
      _CategoriesButtonWidgetState();
}

class _CategoriesButtonWidgetState
    extends State<HomePageCategoriesButtonWidget> {
  // int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetCatigoriesCubit, GetCatigoriesState>(
      builder: (context, state) {
        if (state is GetCatigoriesLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is GetCatigoriesErrorState) {
          return MyErrorWidget(
              msg: state.msg,
              onPressed: () {
                context.read<GetCatigoriesCubit>().getCatigories();
              });
        }
        List<CatigoriesData> model =
            context.read<GetCatigoriesCubit>().homeData;
        return ListView.builder(
          itemCount: model.length + 1,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              child: MaterialButton(
                animationDuration: const Duration(seconds: 2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9.w)),
                color:
                    index == 0 ? AppColors.buttonCategoryColor : Colors.white,
                onPressed: () {
                  if (index != 0) {
                    context
                        .read<GetPorductByIdCubit>()
                        .getProductsByCategory(model[index - 1].id!);
                    setState(() {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (builder) {
                        return ProductScreen(
                          isNotHome: false,
                          cData: model[index - 1],
                        );
                      }));
                    });
                  }
                },
                child: Text(
                  index == 0 ? "all".tr(context) : model[index - 1].name!,
                  style: TextStyle(
                      color: index == 0 ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            );
            // }
          },
          scrollDirection: Axis.horizontal,
        );
      },
    );
  }
}
