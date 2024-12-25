import 'package:zein_store/Apis/Urls.dart';
import 'package:zein_store/Future/Home/Blocs/get_categories/get_categories_bloc.dart';
import 'package:zein_store/Future/Home/Pages/product_screen.dart';
import 'package:zein_store/Future/Home/Widgets/error_widget.dart';
import 'package:zein_store/Utils/colors.dart';
import 'package:zein_store/Utils/images.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../custom_circular_progress_indicator.dart';

class HomePageCategoriesButtonWidget extends StatefulWidget {
  const HomePageCategoriesButtonWidget({
    super.key,
  });

  @override
  State<HomePageCategoriesButtonWidget> createState() =>
      _CategoriesButtonWidgetState();
}

class _CategoriesButtonWidgetState
    extends State<HomePageCategoriesButtonWidget> {
  final _scrollControllerCategories = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollControllerCategories.addListener(_onScrollCategories);
  }

  @override
  void dispose() {
    _scrollControllerCategories
      ..removeListener(_onScrollCategories)
      ..dispose();

    super.dispose();
  }

  void _onScrollCategories() {
    final currentScroll = _scrollControllerCategories.offset;
    final maxScroll = _scrollControllerCategories.position.maxScrollExtent;

    if (currentScroll >= (maxScroll * 0.9)) {
      context.read<GetCategoriesBloc>().add(GetAllCategoriesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
      builder: (context, state) {
        switch (state.status) {
          case GetCategoriesStatus.loading:
            return const Center(
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CustomCircularProgressIndicator()),
            );
          case GetCategoriesStatus.success:
            return SizedBox(
              height: 105,
              width: double.infinity,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                controller: _scrollControllerCategories,
                itemCount: state.hasReachedMax
                    ? state.categories.length
                    : state.categories.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  return index >= state.categories.length
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(4),
                            child: SizedBox(
                                height: 30,
                                width: 30,
                                child: CustomCircularProgressIndicator()),
                          ),
                        )
                      : Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (builder) {
                                  return ProductScreen(
                                    isNotHome: false,
                                    cData: state.categories[index],
                                  );
                                }));
                              },
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: 1.h,
                                      left: 10,
                                      right: 10,
                                      bottom: 20),
                                  padding: const EdgeInsets.only(
                                      top: 30, left: 30, right: 30, bottom: 8),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: state
                                                    .categories[index].isOffer!
                                                ? Colors.red
                                                : AppColors.primaryColors[400]!,
                                            blurStyle: BlurStyle.solid,
                                            blurRadius: 10,
                                            offset: const Offset(0, 4))
                                      ],
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.white),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        state.categories[index].name!,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      if (state.categories[index].isOffer!)
                                        const Text(
                                          " %",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                left: 0,
                                right: 0,
                                child: CircleAvatar(
                                    radius: 6.w,
                                    backgroundImage: state
                                            .categories[index].files!.isNotEmpty
                                        ? NetworkImage(
                                            state.categories[index].files?[0]
                                                        .path !=
                                                    null
                                                ? Urls.storageCategories +
                                                    state.categories[index]
                                                        .files![0].name!
                                                : state.categories[index]
                                                    .files![0].name!,
                                          )
                                        : const AssetImage(
                                            AppImagesAssets.plus))),
                          ],
                        );
                },
              ),
            );
          case GetCategoriesStatus.error:
            return Center(
                child: MyErrorWidget(
              msg: state.errorMsg,
              onPressed: () {
                context
                    .read<GetCategoriesBloc>()
                    .add(ResetPaginationCategoriesEvent());
                context.read<GetCategoriesBloc>().add(GetAllCategoriesEvent());
              },
            ));
        }
      },
    );
  }
}
