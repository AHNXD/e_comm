// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:e_comm/Future/Home/Pages/product_screen.dart';
import 'package:e_comm/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../Utils/functions.dart';
import '../../Blocs/get_products_by_cat_id/get_products_by_cat_id_bloc.dart';

class CategoriesButtonWidget extends StatefulWidget {
  const CategoriesButtonWidget({
    super.key,
    required this.firstText,
    required this.parentId,
  });

  final String firstText;
  final parentId;
  @override
  State<CategoriesButtonWidget> createState() => _CategoriesButtonWidgetState();
}

class _CategoriesButtonWidgetState extends State<CategoriesButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: getCategoryByParentId(widget.parentId, context).length + 1,
      itemBuilder: (context, index) {
        List l = getCategoryByParentId(widget.parentId, context);
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          child: MaterialButton(
            animationDuration: const Duration(seconds: 2),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9.w)),
            color: index == 0 ? const Color.fromARGB(255, 251, 254, 255) : null,
            onPressed: () async {
              if (index != 0) {
                //context.read<GetProductsCubit>().getProductsByCategory();
                await Navigator.push(context,
                    MaterialPageRoute(builder: (builder) {
                  return ProductScreen(
                    cData: l[index - 1],
                    isNotHome: true,
                  );
                }));
                // context
                //     .read<GetPorductByIdCubit>()
                //     .getProductsByCategory(widget.parentId);
                context.read<GetProductsByCatIdBloc>().add(ResetPagination());
                context.read<GetProductsByCatIdBloc>().add(
                    GetPoductsAllByCatIdEvent(categoryID: widget.parentId));
              }
            },
            child: Text(
              index == 0 ? widget.firstText : l[index - 1].name!,
              style: TextStyle(
                  color:
                      index == 0 ? AppColors.textButtonColors : Colors.white),
            ),
          ),
        );
        // }
      },
      scrollDirection: Axis.horizontal,
    );
  }
}
