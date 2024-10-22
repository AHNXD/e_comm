import 'package:flutter/material.dart';
import '../../../Utils/colors.dart';

class SizeSelector extends StatefulWidget {
  const SizeSelector(
      {super.key,
      this.sizes,
      this.selectedIndex,
      required this.onSizeSelected});
  final List<String>? sizes;
  final int? selectedIndex;
  final Function(int) onSizeSelected;
  @override
  State<SizeSelector> createState() => _SizeSelectorState();
}

class _SizeSelectorState extends State<SizeSelector> {
  @override
  Widget build(BuildContext context) {
    int selectedIndex = -1;

    if (widget.sizes != null && widget.sizes!.isNotEmpty) {
      return Row(
        children: [
          const Text(
            'Sizes: ',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.sizes!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                      widget.onSizeSelected(index);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: selectedIndex == index
                            ? AppColors.primaryColors
                            : Colors.grey.shade200,
                        child: Text(
                          widget.sizes![index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: selectedIndex == index
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );
    }

    return const SizedBox();
  }
}
