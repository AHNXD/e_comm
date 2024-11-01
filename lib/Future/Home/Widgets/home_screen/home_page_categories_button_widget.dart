import 'package:e_comm/Apis/Urls.dart';
import 'package:e_comm/Future/Home/Pages/product_screen.dart';
import 'package:e_comm/Future/Home/Widgets/error_widget.dart';
import 'package:e_comm/Future/Home/models/catigories_model.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/Utils/colors.dart';
import 'package:e_comm/Utils/images.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../Cubits/getCatigories/get_catigories_cubit.dart';

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
  // int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetCatigoriesCubit, GetCatigoriesState>(
      builder: (context, state) {
        if (state is GetCatigoriesLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is GetCatigoriesErrorState) {
          return MyErrorWidget(
              msg: state.msg,
              onPressed: () {
                context.read<GetCatigoriesCubit>().getCatigories();
              });
        }
        List<CatigoriesData> model =
            context.read<GetCatigoriesCubit>().homeData;
        return ListView.builder(
          itemCount: model.length + 1,
          itemBuilder: (context, index) {
            return Expanded(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (index != 0) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (builder) {
                          return ProductScreen(
                            isNotHome: false,
                            cData: model[index - 1],
                          );
                        }));
                      }
                      // when press the all button its should let the user to see all products
                      // else {
                      //   Navigator.push(context,
                      //       MaterialPageRoute(builder: (builder) {
                      //     return ProductScreen(
                      //       isNotHome: false,
                      //       cData: model[index - 1],
                      //     );
                      //   }));
                      // }
                    },
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.only(
                            top: 30, left: 10, right: 10, bottom: 20),
                        padding: const EdgeInsets.only(
                            top: 30, left: 30, right: 30, bottom: 8),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: AppColors.primaryColors[400]!,
                                  blurRadius: 15,
                                  offset: const Offset(0, 4))
                            ],
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white),
                        child: index == 0
                            ? Text(
                                "all".tr(context),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    model[index - 1].name!,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  if (index != 0 && model[index - 1].isOffer!)
                                    const CircleAvatar(
                                      backgroundColor: Colors.red,
                                      child: Text(
                                        "%",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
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
                          backgroundImage: index != 0
                              ? model[index - 1].files!.isNotEmpty
                                  ? NetworkImage(
                                      model[index - 1].files?[0].path != null
                                          ? Urls.storageProducts +
                                              model[index - 1].files![0].name!
                                          : model[index - 1].files![0].name!,
                                    )
                                  : const AssetImage(AppImagesAssets.test1)
                              : const AssetImage(AppImagesAssets.fruit))),
                ],
              ),
            );
            // }
          },
          scrollDirection: Axis.horizontal,
        );
      },
    );
  }
}

// child: MaterialButton(
                      //   animationDuration: const Duration(seconds: 2),
                      //   shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(9.w)),
                      //   color: index == 0
                      //       ? AppColors.buttonCategoryColor
                      //       : Colors.white,
                      //   onPressed: () {
                      //     if (index != 0) {
                      //       setState(() {
                      //         Navigator.push(context,
                      //             MaterialPageRoute(builder: (builder) {
                      //           return ProductScreen(
                      //             isNotHome: false,
                      //             cData: model[index - 1],
                      //           );
                      //         }));
                      //       });
                      //     }
                      //   },
                      //   child: Row(
                      //     children: [
                      //       Text(
                      //         index == 0
                      //             ? "all".tr(context)
                      //             : model[index - 1].name!,
                      //         style: TextStyle(
                      //             color:
                      //                 index == 0 ? Colors.white : Colors.black,
                      //             fontWeight: FontWeight.bold),
                      //       ),
                      //       if (index != 0 && model[index - 1].isOffer!)
                      //         const SizedBox(
                      //           width: 8,
                      //         ),
                      //       index != 0 && model[index - 1].isOffer!
                      //           ? const CircleAvatar(
                      //               backgroundColor: Colors.red,
                      //               child: Text(
                      //                 "%",
                      //                 style: TextStyle(
                      //                     color: Colors.white,
                      //                     fontWeight: FontWeight.bold),
                      //               ),
                      //             )
                      //           : const SizedBox()
                      //     ],
                      //   ),
                      // ),