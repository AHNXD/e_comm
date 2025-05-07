// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:zein_store/Future/Home/Blocs/search_filter_products/search_filter_poducts_bloc.dart';
import 'package:zein_store/Future/Home/Cubits/get_min_max_cubit/get_min_max_cubit.dart';
import 'package:zein_store/Future/Home/Cubits/mange_search_filter_products/mange_search_filter_products_cubit.dart';
import 'package:zein_store/Future/Home/Pages/product_screen.dart';
import 'package:zein_store/Future/Home/models/catigories_model.dart';
import 'package:zein_store/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../Blocs/get_products_by_cat_id/get_products_by_cat_id_bloc.dart';

class CategoriesButtonWidget extends StatefulWidget {
  const CategoriesButtonWidget(
      {super.key,
      required this.firstText,
      required this.parentId,
      required this.children});

  final String firstText;
  final parentId;
  final List<CatigoriesData> children;

  @override
  State<CategoriesButtonWidget> createState() => _CategoriesButtonWidgetState();
}

class _CategoriesButtonWidgetState extends State<CategoriesButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.children.length + 1,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          child: MaterialButton(
            animationDuration: const Duration(seconds: 2),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9.w)),
            color: index == 0 ? AppColors.navBarColor : Colors.white,
            onPressed: () async {
              if (index != 0) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (builder) {
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider<GetProductsByCatIdBloc>(
                          create: (_) => GetProductsByCatIdBloc()
                            ..add(ResetPagination())
                            ..add(GetAllPoductsByCatIdEvent(
                                categoryID: widget.children[index - 1].id!)),
                        ),
                        BlocProvider<MangeSearchFilterProductsCubit>(
                          create: (_) => MangeSearchFilterProductsCubit(),
                        ),
                        BlocProvider<GetMinMaxCubit>(
                          create: (_) => GetMinMaxCubit()
                            ..getMinMax(widget.children[index - 1].id),
                        ),
                        BlocProvider<SearchFilterPoductsBloc>(
                          create: (_) => SearchFilterPoductsBloc()
                            ..add(ResetSearchFilterToInit()),
                        ),
                      ],
                      child: ProductScreen(
                        key: ValueKey(widget.children[index - 1].id),
                        cData: widget.children[index - 1],
                        isNotHome: true,
                      ),
                    );
                  }),
                );

                context.read<GetProductsByCatIdBloc>().add(ResetPagination());
                context.read<GetProductsByCatIdBloc>().add(
                    GetAllPoductsByCatIdEvent(categoryID: widget.parentId));
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  index == 0
                      ? widget.firstText
                      : widget.children[index - 1].name!,
                ),
                const SizedBox(width: 8),
                if (index != 0 && widget.children[index - 1].isOffer != null)
                  if (widget.children[index - 1].isOffer!)
                    const Text(
                      "%",
                      style: TextStyle(color: Colors.red),
                    ),
              ],
            ),
          ),
        );
        // }
      },
      scrollDirection: Axis.horizontal,
    );
  }
}
