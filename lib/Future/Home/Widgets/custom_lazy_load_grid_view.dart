import 'package:flutter/material.dart';
import 'custom_circular_progress_indicator.dart';

class CustomLazyLoadGridView<T> extends StatelessWidget {
  const CustomLazyLoadGridView({
    super.key,
    required this.items,
    required this.hasReachedMax,
    required this.itemBuilder,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.62,
    this.crossAxisSpacing = 10.0, // Reduced slightly to allow more card width
    this.mainAxisSpacing = 10.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(child: CustomCircularProgressIndicator()),
            )
        ],
      ),
    );
  }
}
