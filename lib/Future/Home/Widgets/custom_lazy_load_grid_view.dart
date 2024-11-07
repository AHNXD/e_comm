import 'package:flutter/material.dart';

import '../../../Utils/colors.dart';

class CustomLazyLoadGridView<T> extends StatelessWidget {
  const CustomLazyLoadGridView({
    super.key,
    required this.items,
    required this.hasReachedMax,
    required this.itemBuilder,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.43,
    this.crossAxisSpacing = 8.0,
    this.mainAxisSpacing = 8.0,
    this.padding = const EdgeInsets.all(8.0),
  });

  final List<T> items;
  final bool hasReachedMax;
  final Widget Function(BuildContext, T) itemBuilder;
  final int crossAxisCount;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        children: [
          GridView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              crossAxisSpacing: crossAxisSpacing,
              mainAxisSpacing: mainAxisSpacing,
            ),
            itemBuilder: (context, index) => itemBuilder(context, items[index]),
          ),
          if (!hasReachedMax)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.buttonCategoryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
