import 'package:e_comm/Future/Home/Widgets/home_screen/back_widget.dart';
import 'package:e_comm/Future/Home/Widgets/home_screen/categories_button_widget.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../Cubits/searchProductByCatId/search_product_by_category_id_cubit.dart';

class TopOvalWidget extends StatefulWidget {
  const TopOvalWidget(
      {super.key,
      required this.firstText,
      required this.parentId,
      required this.isNotHome});
  final String firstText;
  final int parentId;
  final bool isNotHome;

  @override
  State<TopOvalWidget> createState() => _TopOvalWidgetState();
}

class _TopOvalWidgetState extends State<TopOvalWidget> {
  late TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    double selectHeight(screenHeight) {
      if (screenWidth > 280 && screenWidth < 450) {
        return screenHeight * 0.39;
      } else if (screenWidth >= 450 && screenWidth < 600) {
        return screenHeight * 0.6;
      } else if (screenWidth >= 600 && screenWidth < 900) {
        return screenHeight * 0.7;
      }
      return screenHeight * 0.9;
    }

    return ClipPath(
      clipBehavior: Clip.hardEdge,
      clipper: CoustomClipPath(),
      child: Container(
        margin: EdgeInsets.zero,
        color: AppColors.offersContainerColor,
        height: selectHeight(screenHeight),
        child: Column(
          children: [
            BackWidget(
              canPop: widget.isNotHome,
              hasBackButton: true,
              hasStyle: false,
              iconColor: Colors.white,
              textColor: Colors.white,
              text: "products".tr(context),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
              child: TextFormField(
                controller: controller,
                onChanged: (value) {
                  value = controller.text;
                },
                onFieldSubmitted: (value) {
                  context
                      .read<SearchProductByCategoryIdCubit>()
                      .searchProductsByCategories(value, widget.parentId);
                },
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    hintText: "search_product_hint".tr(context),
                    hintStyle: const TextStyle(
                      color: Colors.black54,
                    ),
                    filled: true,
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.clear();
                        context
                            .read<SearchProductByCategoryIdCubit>()
                            .searchProductsByCategories('', widget.parentId);
                      },
                      icon: const Icon(
                        textDirection: TextDirection.ltr,
                        Icons.close,
                        color: AppColors.buttonCategoryColor,
                      ),
                    ),
                    prefixIcon: IconButton(
                      onPressed: () {
                        context
                            .read<SearchProductByCategoryIdCubit>()
                            .searchProductsByCategories(
                                controller.text, widget.parentId);
                      },
                      icon: const Icon(
                        textDirection: TextDirection.ltr,
                        Icons.search,
                        color: AppColors.buttonCategoryColor,
                      ),
                    ),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(4.w))),
              ),
            ),
            SizedBox(
              height: 8.h,
              child: CategoriesButtonWidget(
                parentId: widget.parentId,
                firstText: widget.firstText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CoustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height + 4.h;
    final Path path = Path();
    double heightOffset = height * 0.25;
    path.lineTo(0, height - heightOffset);
    path.quadraticBezierTo(
      width * 0.5,
      height,
      width,
      height - heightOffset,
    );
    path.lineTo(width, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class CoustomDownClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height;
    final Path path = Path();

    path.lineTo(0, height);
    path.quadraticBezierTo(
      width * 0.5,
      height - 11.h,
      width,
      height,
    );
    path.lineTo(width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
