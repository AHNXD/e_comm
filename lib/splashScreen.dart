import 'package:e_comm/Future/Auth/Pages/login_screen.dart';
import 'package:e_comm/Future/Auth/cubit/auth_cubit.dart';
import 'package:e_comm/Future/Home/Pages/navbar_screen.dart';
import 'package:e_comm/Utils/images.dart';
import 'package:e_comm/conditions.dart';
// import 'package:e_comm/Future/Home/Widgets/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'Future/Home/Widgets/custom_circular_progress_indicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late final Animation<double> _scaleAnimation =
      CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn);

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) async {
        await Future.delayed(const Duration(seconds: 1), () {
          if (state is IsVaildToken) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (builder) {
              return const NavBarPage();
            }));
          } else if (state is IsFirstUseTrue) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (builder) {
              return ConditionsScreen(
                home: false,
              );
            }));
          } else if (state is IsNotVaildToken) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (builder) {
              return LoginScreen();
            }));
          } else if (state is TokenErrorState) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (builder) {
              return LoginScreen();
            }));
            //   return Scaffold(
            //     body: MyErrorWidget(
            //       msg: state.message,
            //       onPressed: context.read<AuthCubit>().checkToken,
            //     ),
            //   );
          }
        });
      },
      builder: (context, state) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              ScaleTransition(
                scale: _scaleAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(60.0),
                  child: Image.asset(
                    AppImagesAssets.logoNoBg,
                    width: 140.sp,
                    height: 140.sp,
                    // fit: BoxFit.cover,
                  ),
                ),
              ),
              const Spacer(flex: 1),
              const Center(child: CustomCircularProgressIndicator()),
              const Spacer(flex: 2),
            ],
          ),
        );
      },
    );
  }
}
