// import 'package:e_comm/Future/Home/Widgets/Compair_Screen/search_dropdown_widget.dart';
// import 'package:e_comm/Future/Home/Widgets/home_screen/back_widget.dart';
// import 'package:e_comm/Utils/functions.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../Cubits/CompairPruductsCubit/compair_products_cubit.dart';
// import '../Cubits/cartCubit/cart.bloc.dart';
// import '../Widgets/cartScreen1/cart_tile.dart';

// class CompairScreen extends StatefulWidget {
//   const CompairScreen({super.key});

//   @override
//   State<CompairScreen> createState() => _CompairScreenState();
// }

// class _CompairScreenState extends State<CompairScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: AppBar().preferredSize,
//         child: const BackWidget(canPop: false,
//           hasBackButton: true,
//           hasStyle: false,
//           iconColor: Colors.black,
//           text: "Compair Products",
//           textColor: Colors.black,
//         ),
//       ),
//       body: SafeArea(
//         child: BlocBuilder<CompairProductsCubit, CompairProductsState>(
//           builder: (context, state) {
//             return Column(
//               children: [
//                 SearchDropDownWidget(
//                   numberProduct: 1,
//                   namesList: getPruductsName(context),
//                 ),
//                 // Container(
//                 //   margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
//                 //   padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
//                 //   decoration: BoxDecoration(
//                 //       borderRadius: BorderRadius.circular(4.w),
//                 //       border: Border.all(
//                 //         color: Colors.red,
//                 //       )),
//                 //   child: Row(
//                 //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //     children: [
//                 //       Image.asset(
//                 //         AppImagesAssets.test1,
//                 //         height: 15.h,
//                 //         width: 20.w,
//                 //       ),
//                 //       Column(
//                 //         children: [
//                 //           Text("Fresh Orange",
//                 //               style: TextStyle(
//                 //                 fontWeight: FontWeight.w600,
//                 //                 color: AppColors.textButtonColors,
//                 //                 fontSize: 15.sp,
//                 //               )),
//                 //           SizedBox(
//                 //             height: 2.h,
//                 //           ),
//                 //           Text("500 gm.",
//                 //               style: TextStyle(
//                 //                 color: Colors.black54,
//                 //                 fontSize: 10.sp,
//                 //               )),
//                 //         ],
//                 //       ),
//                 //       SizedBox(
//                 //         width: 1.w,
//                 //       ),
//                 //       Stack(
//                 //         children: [
//                 //           Padding(
//                 //             padding: EdgeInsets.only(right: 10.w, top: 2.h),
//                 //             child: Text(
//                 //               "14.",
//                 //               style: TextStyle(
//                 //                   color: AppColors.textButtonColors,
//                 //                   fontSize: 30.sp,
//                 //                   fontWeight: FontWeight.w900),
//                 //             ),
//                 //           ),
//                 //           Positioned(
//                 //             bottom: 4.5.h,
//                 //             left: 15.w,
//                 //             child: Text(
//                 //               "29\$",
//                 //               style: TextStyle(
//                 //                   color: AppColors.textButtonColors,
//                 //                   fontSize: 12.sp,
//                 //                   fontWeight: FontWeight.w600),
//                 //             ),
//                 //           ),
//                 //         ],
//                 //       ),
//                 //     ],
//                 //   ),
//                 // ),

//                 CartTile(
//                   product: context.read<CompairProductsCubit>().productOne,
//                   deleteProudct: () {
//                     setState(() {
//                       context
//                           .read<CompairProductsCubit>()
//                           .productOne
//                           .userQuantity = 0;
//                       context.read<CartCubit>().removeformTheCart(
//                           context.read<CompairProductsCubit>().productOne);
//                     });
//                   },
//                   onRemove: () {
//                     if (context
//                             .read<CompairProductsCubit>()
//                             .productOne
//                             .userQuantity !=
//                         1) {
//                       setState(() {
//                         context
//                             .read<CompairProductsCubit>()
//                             .productOne
//                             .userQuantity--;
//                       });
//                     }
//                   },
//                   onAdd: () {
//                     setState(() {
//                       if (context
//                               .read<CompairProductsCubit>()
//                               .productOne
//                               .userQuantity ==
//                           0) {
//                         context.read<CartCubit>().addToCart(
//                             context.read<CompairProductsCubit>().productOne);
//                       }
//                       if (context
//                               .read<CompairProductsCubit>()
//                               .productOne
//                               .userQuantity <
//                           context
//                               .read<CompairProductsCubit>()
//                               .productOne
//                               .quantity!) {
//                         context
//                             .read<CompairProductsCubit>()
//                             .productOne
//                             .userQuantity++;
//                       }
//                     });
//                   },
//                 ),
//                 SearchDropDownWidget(
//                   numberProduct: 2,
//                   namesList: getPruductsName(context),
//                 ),
//                 CartTile(
//                   product: context.read<CompairProductsCubit>().productTwo,
//                   deleteProudct: () {
//                     setState(() {
//                       context
//                           .read<CompairProductsCubit>()
//                           .productTwo
//                           .userQuantity = 0;
//                       context.read<CartCubit>().removeformTheCart(
//                           context.read<CompairProductsCubit>().productTwo);
//                     });
//                   },
//                   onRemove: () {
//                     if (context
//                             .read<CompairProductsCubit>()
//                             .productTwo
//                             .userQuantity !=
//                         1) {
//                       setState(() {
//                         context
//                             .read<CompairProductsCubit>()
//                             .productTwo
//                             .userQuantity--;
//                       });
//                     }
//                   },
//                   onAdd: () {
//                     setState(() {
//                       if (context
//                               .read<CompairProductsCubit>()
//                               .productTwo
//                               .userQuantity ==
//                         0) {
//                         context.read<CartCubit>().addToCart(
//                             context.read<CompairProductsCubit>().productTwo);
//                       }
//                       if (context
//                               .read<CompairProductsCubit>()
//                               .productTwo
//                               .userQuantity <
//                           context
//                               .read<CompairProductsCubit>()
//                               .productTwo
//                               .quantity!) {
//                         context
//                             .read<CompairProductsCubit>()
//                             .productTwo
//                             .userQuantity++;
//                       }
//                     });
//                   },
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
