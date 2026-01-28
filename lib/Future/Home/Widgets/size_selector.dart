import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../Utils/colors.dart';

class SizeSelector extends StatefulWidget {
  const SizeSelector({
    super.key,
    this.sizes,
    this.initialIndex, // Changed name for clarity
    required this.onSizeSelected,
  });

  final List<String>? sizes;
  final int? initialIndex;
  final Function(int) onSizeSelected;

  @override
  State<SizeSelector> createState() => _SizeSelectorState();
}

class _SizeSelectorState extends State<SizeSelector> {
  // Move state variable outside of build method
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    // Initialize selection if provided
    if (widget.initialIndex != null) {
      _selectedIndex = widget.initialIndex!;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sizes == null || widget.sizes!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Label
        Text(
          'Sizes', // You can use .tr(context) here
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 1.h),

        // Horizontal List
        SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: widget.sizes!.length,
            separatorBuilder: (context, index) => SizedBox(width: 3.w),
            itemBuilder: (context, index) {
              final bool isSelected = _selectedIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                  widget.onSizeSelected(index);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.buttonCategoryColor
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: isSelected
                            ? AppColors.buttonCategoryColor
                            : Colors.grey.shade300,
                        width: 1.5),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.buttonCategoryColor
                                  .withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : [],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    widget.sizes![index],
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.grey[700],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
