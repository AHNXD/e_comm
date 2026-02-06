import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:zein_store/Future/Auth/Pages/login_screen.dart';
import 'package:zein_store/Future/Auth/cubit/auth_cubit.dart';
import 'package:zein_store/Future/Home/Cubits/locale/locale_cubit.dart';
import 'package:zein_store/Future/Home/Pages/navbar_screen.dart';
import 'package:zein_store/Utils/images.dart';
import 'package:zein_store/conditionsScreen.dart';
import 'Future/Home/Widgets/custom_circular_progress_indicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack, // Adds a little "bounce" effect
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.5, 1.0, curve: Curves.easeIn)),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Theme colors for easier management
    final primaryColor = Theme.of(context).primaryColor;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) async {
        // Only trigger navigation automatically if it's NOT the first use
        if (state is! IsFirstUseTrue) {
          await Future.delayed(const Duration(seconds: 2));
          if (!mounted) return;

          if (state is IsVaildToken) {
            _navigateTo(const NavBarPage());
          } else if (state is IsNotVaildToken || state is TokenErrorState) {
            _navigateTo(LoginScreen());
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  primaryColor.withOpacity(0.05),
                  primaryColor.withOpacity(0.1),
                ],
              ),
            ),
            child: Column(
              children: [
                const Spacer(flex: 3),

                // Animated Logo
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          spreadRadius: 5,
                        )
                      ],
                    ),
                    child: Image.asset(
                      AppImagesAssets.logoNoBg,
                      width: 50.w,
                      height: 50.w,
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                // Dynamic Footer (Loading or Language Selection)
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: state is IsFirstUseTrue
                        ? _buildLanguageSelection(context)
                        : const CustomCircularProgressIndicator(),
                  ),
                ),

                const Spacer(flex: 1),

                SizedBox(height: 5.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageSelection(BuildContext context) {
    return Column(
      children: [
        Text(
          "Choose your language / اختر اللغة",
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 3.h),
        Row(
          children: [
            Expanded(child: _langButton(context, "English", "en")),
            SizedBox(width: 4.w),
            Expanded(child: _langButton(context, "العربية", "ar")),
          ],
        ),
      ],
    );
  }

  Widget _langButton(BuildContext context, String label, String langCode) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        side:
            BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.5)),
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      onPressed: () {
        context.read<LocaleCubit>().changeLanguage(langCode);
        _navigateTo(ConditionsScreen(home: false));
      },
      child: Text(
        label,
        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _navigateTo(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}
