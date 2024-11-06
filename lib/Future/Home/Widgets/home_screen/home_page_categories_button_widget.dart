import 'package:e_comm/Apis/Urls.dart';
import 'package:e_comm/Future/Home/Pages/product_screen.dart';
import 'package:e_comm/Future/Home/Widgets/error_widget.dart';
import 'package:e_comm/Future/Home/models/catigories_model.dart';
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
        return SizedBox(
          height: 105,
          child: ListView.builder(
            itemCount: model.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (builder) {
                        return ProductScreen(
                          isNotHome: false,
                          cData: model[index],
                        );
                      }));
                    },
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.only(
                            top: 1.h, left: 10, right: 10, bottom: 20),
                        padding: const EdgeInsets.only(
                            top: 30, left: 30, right: 30, bottom: 8),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: model[index].isOffer!
                                      ? Colors.red
                                      : AppColors.primaryColors[400]!,
                                  blurRadius: 15,
                                  offset: const Offset(0, 4))
                            ],
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white),
                        // child: Text(
                        //   model[index].name!,
                        //   style: const TextStyle(
                        //       color: Colors.black, fontWeight: FontWeight.bold),
                        // ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              model[index].name!,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            if (model[index].isOffer!)
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
                          backgroundImage: model[index].files!.isNotEmpty
                              ? NetworkImage(
                                  model[index].files?[0].path != null
                                      ? Urls.storageProducts +
                                          model[index].files![0].name!
                                      : model[index].files![0].name!,
                                )
                              : const AssetImage(AppImagesAssets.test1))),
                ],
              );
              // }
            },
            scrollDirection: Axis.horizontal,
          ),
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