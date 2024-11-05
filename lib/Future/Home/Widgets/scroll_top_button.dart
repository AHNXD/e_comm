import 'package:flutter/material.dart';

import '../../../Utils/colors.dart';

class ScrollToTopButton extends StatelessWidget {
  final ScrollController scrollController;

  const ScrollToTopButton({super.key, required this.scrollController});

  void _scrollToTop() {
    scrollController.animateTo(
      0.0,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.buttonCategoryColor,
      onPressed: _scrollToTop,
      tooltip: 'Scroll to Top',
      child: const Icon(
        Icons.arrow_upward,
        color: Colors.white,
      ),
    );
  }
}
