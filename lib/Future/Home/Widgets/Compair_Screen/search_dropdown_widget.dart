import 'package:dropdown_search/dropdown_search.dart';
import 'package:zein_store/Future/Home/Cubits/CompairPruductsCubit/compair_products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class SearchDropDownWidget extends StatelessWidget {
  const SearchDropDownWidget(
      {super.key, required this.namesList, required this.numberProduct});
  final List<String> namesList;
  final int numberProduct;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompairProductsCubit, CompairProductsState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.only(left: 2.w, right: 2.w, top: 2.h),
          child: DropdownSearch<String>(
            dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3.w)))),
            popupProps: const PopupProps.menu(
                showSearchBox: true, showSelectedItems: true),
            items: namesList,
            // dropdownSearchDecoration: InputDecoration(labelText: "Name"),
            onChanged: (s) {
              // context
              //     .read<CompairProductsCubit>()
              //     .changeProduct(getPruductByName(context, s!), numberProduct);
            },
            selectedItem:
                numberProduct == 1 ? namesList.first : namesList.elementAt(1),
          ),
        );
      },
    );
  }
}
