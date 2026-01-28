import 'package:zein_store/Apis/Urls.dart';
import 'package:zein_store/Future/Home/Blocs/get_categories/get_categories_bloc.dart';
import 'package:zein_store/Future/Home/Blocs/get_products_by_cat_id/get_products_by_cat_id_bloc.dart';
import 'package:zein_store/Future/Home/Blocs/search_filter_products/search_filter_poducts_bloc.dart';
import 'package:zein_store/Future/Home/Cubits/get_min_max_cubit/get_min_max_cubit.dart';
import 'package:zein_store/Future/Home/Cubits/mange_search_filter_products/mange_search_filter_products_cubit.dart';
import 'package:zein_store/Future/Home/Pages/product_screen.dart';
import 'package:zein_store/Future/Home/Widgets/error_widget.dart';
import 'package:zein_store/Utils/colors.dart';
import 'package:zein_store/Utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../custom_circular_progress_indicator.dart';

class HomePageCategoriesButtonWidget extends StatefulWidget {
  const HomePageCategoriesButtonWidget({super.key});

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
    _scrollControllerCategories.dispose();
    super.dispose();
  }

  void _onScrollCategories() {
    if (_scrollControllerCategories.hasClients) {
      final currentScroll = _scrollControllerCategories.offset;
      final maxScroll = _scrollControllerCategories.position.maxScrollExtent;
      if (currentScroll >= (maxScroll * 0.9)) {
        context.read<GetCategoriesBloc>().add(GetAllCategoriesEvent());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
      builder: (context, state) {
        switch (state.status) {
          case GetCategoriesStatus.loading:
            return SizedBox(
              height: 15.h,
              child: const Center(child: CustomCircularProgressIndicator()),
            );
          case GetCategoriesStatus.success:
            return SizedBox(
              // Slightly increased height so the shadow doesn't get clipped
              height: 16.h,
              width: double.infinity,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                controller: _scrollControllerCategories,
                itemCount: state.hasReachedMax
                    ? state.categories.length
                    : state.categories.length + 1,
                separatorBuilder: (context, index) => SizedBox(width: 3.w),
                itemBuilder: (BuildContext context, int index) {
                  // Loading Indicator at the end
                  if (index >= state.categories.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: CustomCircularProgressIndicator(),
                      ),
                    );
                  }

                  final category = state.categories[index];
                  final isOffer = category.isOffer ?? false;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (builder) {
                        return MultiBlocProvider(
                          providers: [
                            BlocProvider<GetProductsByCatIdBloc>(
                              create: (_) => GetProductsByCatIdBloc()
                                ..add(ResetPagination())
                                ..add(GetAllPoductsByCatIdEvent(
                                    categoryID: category.id!)),
                            ),
                            BlocProvider<MangeSearchFilterProductsCubit>(
                              create: (_) => MangeSearchFilterProductsCubit(),
                            ),
                            BlocProvider<GetMinMaxCubit>(
                              create: (_) =>
                                  GetMinMaxCubit()..getMinMax(category.id),
                            ),
                            BlocProvider<SearchFilterPoductsBloc>(
                              create: (_) => SearchFilterPoductsBloc()
                                ..add(ResetSearchFilterToInit()),
                            ),
                          ],
                          child: ProductScreen(
                            key: ValueKey(category.id),
                            isNotHome: false,
                            cData: category,
                          ),
                        );
                      }));
                    },
                    child: SizedBox(
                      width:
                          26.w, // Slightly narrower for a sleek vertical look
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.bottomCenter,
                        children: [
                          // --- 1. The Base Card (Podium) ---
                          Container(
                            height: 10.h,
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF9E9E9E)
                                      .withOpacity(0.15), // Soft shadow
                                  blurRadius: 5,
                                  offset: const Offset(0, 4),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 5.h, // Push text down
                                  left: 8,
                                  right: 8,
                                  bottom: 12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    category.name!,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.textTitleAppBarColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 9.sp,
                                      height: 1.1,
                                    ),
                                  ),
                                  // Optional: Tiny dot to balance layout if text is short
                                  if (isOffer) ...[
                                    const SizedBox(height: 4),
                                    Container(
                                      height: 4,
                                      width: 4,
                                      decoration: const BoxDecoration(
                                        color: Colors.redAccent,
                                        shape: BoxShape.circle,
                                      ),
                                    )
                                  ]
                                ],
                              ),
                            ),
                          ),

                          // --- 2. The Floating Avatar Ring ---
                          Positioned(
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(3), // Border width
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                // Gradient Border if Offer, White if Normal
                                gradient: isOffer
                                    ? const LinearGradient(
                                        colors: [
                                          Color(0xFFFF512F), // Orange/Red
                                          Color(0xFFDD2476), // Pink/Red
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : const LinearGradient(
                                        colors: [Colors.white, Colors.white]),
                                boxShadow: [
                                  BoxShadow(
                                    color: isOffer
                                        ? Colors.red.withOpacity(0.3)
                                        : Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  )
                                ],
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(3), // White Gap
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(
                                  radius: 7.w,
                                  backgroundColor: const Color(0xFFF5F5F7),
                                  backgroundImage: (category.files != null &&
                                          category.files!.isNotEmpty)
                                      ? NetworkImage(
                                          category.files![0].path != null
                                              ? Urls.storageCategories +
                                                  category.files![0].name!
                                              : category.files![0].name!,
                                        )
                                      : const AssetImage(AppImagesAssets.plus)
                                          as ImageProvider,
                                ),
                              ),
                            ),
                          ),

                          // --- 3. Optional "Hot" Badge (Tiny absolute badge) ---
                          if (isOffer)
                            Positioned(
                              top: 2,
                              right: 2.w, // Offset slightly
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 2)
                                  ],
                                ),
                                child: Icon(
                                  Icons.local_fire_department_rounded,
                                  color: Colors.red,
                                  size: 10.sp,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          case GetCategoriesStatus.error:
            return SizedBox(
              height: 15.h,
              child: Center(
                  child: MyErrorWidget(
                msg: state.errorMsg,
                onPressed: () {
                  context
                      .read<GetCategoriesBloc>()
                      .add(ResetPaginationCategoriesEvent());
                  context
                      .read<GetCategoriesBloc>()
                      .add(GetAllCategoriesEvent());
                },
              )),
            );
        }
      },
    );
  }
}
