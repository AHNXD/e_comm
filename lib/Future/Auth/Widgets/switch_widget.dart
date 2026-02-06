// import 'package:zein_store/Future/Auth/cubit/auth_cubit.dart';
// import 'package:zein_store/Utils/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:load_switch/load_switch.dart';
// 

// class SwitchWidget extends StatelessWidget {
//   const SwitchWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AuthCubit, AuthState>(
//       builder: (context, state) {
//         bool value = context.read<AuthCubit>().getSignUpStateIsEmail;
//         return Row(
//           textDirection: TextDirection.ltr,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "Email",
//               style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 12.sp),
//             ),
//             SizedBox(
//               width: 4.w,
//             ),
//             LoadSwitch(
//               isActive: true,
//               isLoading: false,
//               width: 8.w,
//               height: 2.h,
//               value: true,
//               future: () async {
//                 await Future.delayed(Duration(seconds: 2));
//                 return value;
//               },
//               style: SpinStyle.circle,
//               curveIn: Curves.easeInBack,
//               curveOut: Curves.easeOutBack,
//               animationDuration: const Duration(milliseconds: 500),
//               switchDecoration: (value, val) => BoxDecoration(
//                 color: AppColors.buttonCategoryColor,
//                 borderRadius: BorderRadius.circular(30),
//                 shape: BoxShape.rectangle,
//               ),
//               spinColor: (value) => value
//                   ? const Color.fromARGB(255, 31, 65, 232)
//                   : const Color.fromARGB(255, 255, 77, 77),
//               spinStrokeWidth: 3,
//               thumbDecoration: (value, val) => BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(30),
//                 shape: BoxShape.rectangle,
//               ),
//               onChange: (v) {
//                context.read<AuthCubit>().setSignUpStatusIsEmail = !value;
//               },
//               onTap: (v) {
               
//               },
//             ),
//             SizedBox(
//               width: 4.w,
//             ),
//             Text(
//               "Phone Number",
//               style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 12.sp),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
