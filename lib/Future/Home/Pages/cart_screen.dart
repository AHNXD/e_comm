// import 'package:e_comm/Future/Home/Cubits/cartCubit/cart.bloc.dart';
// import 'package:e_comm/Utils/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sizer/sizer.dart';

// class CartPage extends StatefulWidget {
//   const CartPage({super.key});

//   @override
//   State<CartPage> createState() => _CartPageState();
// }

// class _CartPageState extends State<CartPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       body: BlocBuilder<CartCubit, CartState>(
//         builder: (context, state) {
//           if(state is AddToCartState){

//           }
//           final list = context.read<CartCubit>().pcw;
//           if (list.isNotEmpty) {
//             return ListView.builder(
//               padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
//               itemCount: list.length,
//               itemBuilder: (BuildContext context, int index) {
//                 // return list[index];
//                 return null;
//               },
//             );
//           } else {
//             return const Center(
//                 child: Text("Empty Cart Please Add Any Product To Cart"));
//           }
//         },
//       ),
//     );
//   }
// }
