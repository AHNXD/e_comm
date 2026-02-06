import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:zein_store/Future/Home/Blocs/get_products_by_cat_id/get_products_by_cat_id_bloc.dart';
import 'package:zein_store/Future/Home/Blocs/search_filter_products/search_filter_poducts_bloc.dart';
import 'package:zein_store/Future/Home/Cubits/get_min_max_cubit/get_min_max_cubit.dart';
import 'package:zein_store/Future/Home/Cubits/mange_search_filter_products/mange_search_filter_products_cubit.dart';
import 'package:zein_store/Future/Home/Pages/product_screen.dart';
import 'package:zein_store/Future/Home/models/catigories_model.dart';

class CategoriesButtonWidget extends StatelessWidget {
  const CategoriesButtonWidget({
    super.key,
    required this.firstText,
    required this.parentId,
    required this.children,
  });

  final String firstText;
  final int parentId;
  final List<CatigoriesData> children;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: children.length + 1,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      separatorBuilder: (context, index) => SizedBox(width: 2.w),
      itemBuilder: (context, index) {
        bool isHeader = index == 0;
        String text = isHeader ? firstText : children[index - 1].name!;
        bool isOffer = !isHeader && (children[index - 1].isOffer ?? false);

        return GestureDetector(
          onTap: () {
            if (!isHeader) {
              _navigateToSubCategory(context, children[index - 1]);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isHeader ? Colors.white.withOpacity(0.2) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border:
                  isHeader ? Border.all(color: Colors.white, width: 1.5) : null,
            ),
            alignment: Alignment.center,
            child: Row(
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: isHeader ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
                  ),
                ),
                if (isOffer) ...[
                  SizedBox(width: 1.5.w),
                  Icon(Icons.local_fire_department_rounded,
                      size: 12.sp, color: Colors.red),
                ]
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToSubCategory(
      BuildContext context, CatigoriesData category) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (_) => GetProductsByCatIdBloc()
                  ..add(ResetPagination())
                  ..add(GetAllPoductsByCatIdEvent(categoryID: category.id!))),
            BlocProvider(create: (_) => MangeSearchFilterProductsCubit()),
            BlocProvider(
                create: (_) => GetMinMaxCubit()..getMinMax(category.id)),
            BlocProvider(
                create: (_) =>
                    SearchFilterPoductsBloc()..add(ResetSearchFilterToInit())),
          ],
          child: ProductScreen(
            key: ValueKey(category.id),
            cData: category,
            isNotHome: true,
          ),
        );
      }),
    );

    // Refresh parent on return
    if (context.mounted) {
      context.read<GetProductsByCatIdBloc>().add(ResetPagination());
      context
          .read<GetProductsByCatIdBloc>()
          .add(GetAllPoductsByCatIdEvent(categoryID: parentId));
    }
  }
}
