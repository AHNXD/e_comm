// import 'package:zein_store/Future/Auth/cubit/auth_cubit.dart';
// import 'package:zein_store/Utils/app_localizations.dart';
// import 'package:zein_store/Utils/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//

// enum SwitchStateWael {
//   email("Email"),
//   phone("Phone Number"),
//   emailAndPhone("Email and Phone Number");

//   final String value;
//   const SwitchStateWael(this.value);

//   // SwitchStateWael nextState() {
//   //   switch (this) {
//   //     case email:
//   //       return SwitchStateWael.phone;
//   //     case phone:
//   //       return SwitchStateWael.emailAndPhone;
//   //     case emailAndPhone:
//   //       return SwitchStateWael.email;
//   //     default:
//   //       return SwitchStateWael.phone;
//   //   }
//   // }
// }

// class SwitchTextWidget extends StatelessWidget {
//   const SwitchTextWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AuthCubit, AuthState>(
//       builder: (context, state) {
//         SwitchStateWael sState = context.read<AuthCubit>().swichState;
//         return AnimatedContainer(
//           curve: Curves.fastOutSlowIn,
//           height: 4.3.h,
//           decoration: BoxDecoration(
//               color: const Color(0xFFdddddd),
//               borderRadius: BorderRadius.circular(4.w)),
//           duration: const Duration(seconds: 1),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: MaterialButton(
//                   height: double.infinity,
//                   padding:
//                       EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
//                   color: sState == SwitchStateWael.email
//                       ? const Color(0xff4bb050)
//                       : null,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(4.w)),
//                   onPressed: () {
//                     context.read<AuthCubit>().setSwitchState =
//                         SwitchStateWael.email;
//                   },
//                   child: Center(
//                     child: Text(
//                       "email".tr(context),
//                       style: TextStyle(
//                           fontSize: 14.sp,
//                           color: sState == SwitchStateWael.email
//                               ? Colors.white
//                               : Colors.black),
//                     ),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: MaterialButton(
//                   height: double.infinity,
//                   padding:
//                       EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
//                   color: sState == SwitchStateWael.phone
//                       ? AppColors.buttonCategoryColor
//                       : null,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(4.w)),
//                   onPressed: () {
//                     context.read<AuthCubit>().setSwitchState =
//                         SwitchStateWael.phone;
//                   },
//                   child: Center(
//                       child: Text(
//                     "phone_number".tr(context),
//                     style: TextStyle(
//                         fontSize: 14.sp,
//                         color: sState == SwitchStateWael.phone
//                             ? Colors.white
//                             : Colors.black),
//                   )),
//                 ),
//               ),
//               MaterialButton(
//                 height: double.infinity,
//                 padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
//                 color: sState == SwitchStateWael.emailAndPhone
//                     ? Colors.redAccent
//                     : null,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(4.w)),
//                 onPressed: () {
//                   context.read<AuthCubit>().setSwitchState =
//                       SwitchStateWael.emailAndPhone;
//                 },
//                 child: Center(
//                     child: Text(
//                   "email_and_phone".tr(context),
//                   style: TextStyle(
//                       fontSize: 14.sp,
//                       color: sState == SwitchStateWael.emailAndPhone
//                           ? Colors.white
//                           : Colors.black),
//                 )),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
