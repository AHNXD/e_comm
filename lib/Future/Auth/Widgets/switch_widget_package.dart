// import 'package:e_comm/Utils/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';

// /// This enum is for switch states.
// /// We find next state with [nextState] function
// enum SwitchStateWael {
//   email("Email"),
//   phone("Phone Number"),
//   emailAndPhone("Email and Phone Number");

//   final String value;
//   const SwitchStateWael(this.value);

//   SwitchStateWael nextState() {
//     switch (this) {
//       case email:
//         return SwitchStateWael.phone;
//       case phone:
//         return SwitchStateWael.emailAndPhone;
//       case emailAndPhone:
//         return SwitchStateWael.email;
//       default:
//         return SwitchStateWael.phone;
//     }
//   }
// }

// class WaelThreeStateSwtich extends StatelessWidget {
//   const WaelThreeStateSwtich({
//     Key? key,
//     required this.onChanged,
//     this.dotVerticalPadding = 2,
//     this.dotHorizontalPadding = 1,
//     this.startBackgroundColor,
//     this.middleBackgroundColor,
//     this.endBackgroundColor,
//     this.dotColor,
//     this.disableBackgroundColor,
//     this.disableDotColor,
//     this.width = 70,
//     this.height = 30,
//     this.child,
//     required this.state,
//     this.borderRadius,
//     this.disable = false,
//     this.dotShadow,
//   }) : super(key: key);

//   /// Function for handling [SwitchStateWael] is changed.
//   /// It return [SwitchStateWael] in function as argument for you to handle your functionality.
//   final Function(SwitchStateWael) onChanged;

//   /// Switch width
//   final double? width;

//   /// Switch height
//   final double? height;

//   /// Dot vertical padding from Switch Container
//   final double? dotVerticalPadding;

//   /// Dot horizonatl padding from Switch Container
//   final double? dotHorizontalPadding;

//   /// Border Radius of Switch
//   final BorderRadius? borderRadius;

//   /// Background Color of Start state of [SwitchStateWael]
//   final Color? startBackgroundColor;

//   /// Background Color of Middle state of [SwitchStateWael]
//   final Color? middleBackgroundColor;

//   /// Background Color of End state of [SwitchStateWael]
//   final Color? endBackgroundColor;

//   /// Color for Switch dot
//   final Color? dotColor;

//   /// Color for background of switch in disable mode
//   final Color? disableBackgroundColor;

//   /// Color for dot in disable mode
//   final Color? disableDotColor;

//   /// You can change dot in switch and customize with your widget
//   final Widget? child;

//   /// State of swtich
//   final SwitchStateWael state;

//   /// Disable or Enable switch
//   final bool? disable;

//   /// Box Shadow for Dot
//   final List<BoxShadow>? dotShadow;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: borderRadius ??
//           BorderRadius.circular(
//             200,
//           ),
//       onTap: !disable!
//           ? () {
//               onChanged(state.nextState());
//             }
//           : null,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           AnimatedContainer(
//               alignment: Alignment.center,
//               duration: const Duration(milliseconds: 300),
//               width: width,
//               height: height! + 2.h,
//               decoration: BoxDecoration(
//                 color: !disable!
//                     ? state == SwitchStateWael.email
//                         ? startBackgroundColor ?? AppColors.buttonCategoryColor
//                         : state == SwitchStateWael.phone
//                             ? middleBackgroundColor ??
//                                 AppColors.buttonCategoryColor
//                             : endBackgroundColor ?? AppColors.buttonCategoryColor
//                     : AppColors.buttonCategoryColor,
//                 borderRadius: borderRadius ??
//                     BorderRadius.circular(
//                       200,
//                     ),
//               ),
//               padding: EdgeInsets.symmetric(
//                 horizontal: dotHorizontalPadding!,
//                 vertical: dotVerticalPadding!,
//               ),
//               child:null ,
//                //  AnimatedAlign(
//               //   duration: 300.milliseconds,
//               //   alignment: state == SwitchStateWael.start
//               //       ? AlignmentDirectional.centerStart
//               //       : state == SwitchStateWael.middle
//               //           ? AlignmentDirectional.center
//               //           : AlignmentDirectional.centerEnd,
//               //   child: child ??
//               //       Container(
//               //         height: height,
//               //         width: height,
//               //         decoration: BoxDecoration(
//               //           shape: BoxShape.circle,
//               //           color: !disable!
//               //               ? dotColor ?? SwitchColors.dotColor
//               //               : SwitchColors.disableDotColor,
//               //           boxShadow: !disable!
//               //               ? dotShadow ??
//               //                   [
//               //                     const BoxShadow(
//               //                       color: Colors.black,
//               //                       blurRadius: 10,
//               //                       spreadRadius: -5,
//               //                     ),
//               //                   ]
//               //               : null,
//               //         ),
//               //       ),
//               // ),
//               ),
//         ],
//       ),
//     );
//   }
// }
