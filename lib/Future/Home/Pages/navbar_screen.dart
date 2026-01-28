import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:zein_store/Future/Home/Cubits/cartCubit/cart.bloc.dart';
import 'package:zein_store/Future/Home/Cubits/pages_cubit/pages_cubit.dart';
import 'package:zein_store/Future/Home/Widgets/home_screen/drawer_widget.dart';
import 'package:zein_store/Utils/colors.dart';
import 'package:zein_store/Utils/enums.dart';
import '/main.dart';

class NavBarPage extends StatefulWidget {
  const NavBarPage({super.key});

  @override
  State<NavBarPage> createState() => _NavBarPageState();
}

class _NavBarPageState extends State<NavBarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const DrawerWidget(),
      backgroundColor: const Color(0xFFF9F9F9), // Clean background
      resizeToAvoidBottomInset: false,
      extendBody: true, // Important: Allows body to go behind the nav bar
      body: SafeArea(
        child: BlocBuilder<PagesScreenCubit, PageScreenState>(
          builder: (context, state) {
            return SizedBox(
              height: 100.h,
              width: 100.w,
              child: state is PagesScreenChange
                  ? state.page
                  : state is PageScreenInitialState
                      ? state.page
                      : const SizedBox(),
            );
          },
        ),
      ),
      // Custom Floating Navigation Bar
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 80,
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10),
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.buttonCategoryColor, // Primary Color
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: AppColors.buttonCategoryColor.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: BlocBuilder<PagesScreenCubit, PageScreenState>(
              builder: (context, state) {
                int currentIndex = state is PageScreenInitialState
                    ? state.pageType.index
                    : state is PagesScreenChange
                        ? state.pageType.index
                        : 0;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // 1. Home
                    _NavBarItem(
                      icon: Icons.home_outlined,
                      selectedIcon: Icons.home_rounded,
                      label: "Home",
                      isSelected: currentIndex == 0,
                      onTap: () => _onItemTapped(0),
                    ),

                    // 2. Cart (With Badge)
                    BlocBuilder<CartCubit, CartState>(
                      builder: (context, cartState) {
                        int cartCount = context.read<CartCubit>().pcw.length;
                        return _NavBarItem(
                          icon: Icons.shopping_bag_outlined,
                          selectedIcon: Icons.shopping_bag_rounded,
                          label: "Cart",
                          isSelected: currentIndex == 1,
                          badgeCount: cartCount,
                          onTap: () => _onItemTapped(1),
                        );
                      },
                    ),

                    // 3. History
                    _NavBarItem(
                      icon: Icons.history_rounded,
                      selectedIcon:
                          Icons.history_edu_rounded, // or similar filled
                      label: "History",
                      isSelected: currentIndex == 2,
                      onTap: () => _onItemTapped(2),
                    ),

                    // 4. Favorites
                    _NavBarItem(
                      icon: Icons.favorite_border_rounded,
                      selectedIcon: Icons.favorite_rounded,
                      label: "Fav",
                      isSelected: currentIndex == 3,
                      onTap: () => _onItemTapped(3),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    context
        .read<PagesScreenCubit>()
        .changedScreen(AppScreen.values[index], context);
  }
}

// --- Custom Nav Bar Item Widget ---
class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int badgeCount;

  const _NavBarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuint,
        padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 4.w : 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon Transition
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: Icon(
                    isSelected ? selectedIcon : icon,
                    key: ValueKey(isSelected),
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),

                // Optional: Label indicator dot
                if (isSelected)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  )
              ],
            ),

            // Badge Logic
            if (badgeCount > 0)
              Positioned(
                top: -5,
                right: -5,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2))
                      ]),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Center(
                    child: Text(
                      badgeCount > 9 ? "9+" : badgeCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
