import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zein_store/Future/Home/Cubits/aboutUs/about_us_cubit.dart';
import 'package:zein_store/Future/Home/Widgets/error_widget.dart';
import 'package:zein_store/Future/Home/models/aboutUs_model.dart';
import 'package:zein_store/Future/Home/models/links_model.dart';
import 'package:zein_store/Utils/app_localizations.dart';
import 'package:zein_store/Utils/colors.dart';
import 'package:zein_store/Utils/functions.dart';
import 'package:zein_store/Utils/images.dart';

import '../Widgets/custom_circular_progress_indicator.dart';

// Mapping indices to specific icons for social links
final List<IconData> icons = [
  Icons.facebook,
  Icons.telegram,
  Icons.location_on
];

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data when screen initializes
    context.read<AboutUsCubit>().getAboutUsInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Clean Light Background
      appBar: AppBar(
        foregroundColor: Colors.black87,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "about_us".tr(context),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textTitleAppBarColor,
              fontSize: 14.sp),
        ),
      ),
      body: BlocBuilder<AboutUsCubit, AboutUsState>(
        builder: (context, state) {
          if (state is GetAboutUsSuccessfulState) {
            return AboutUsWidget(aboutUs: state.aboutUs, links: state.links);
          } else if (state is GetAboutUsErrorState) {
            return Center(
              child: MyErrorWidget(
                  msg: state.msg,
                  onPressed: () {
                    context.read<AboutUsCubit>().getAboutUsInfo();
                  }),
            );
          } else {
            return const Center(child: CustomCircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class AboutUsWidget extends StatelessWidget {
  final AboutUsModel aboutUs;
  final Links links;

  const AboutUsWidget({
    super.key,
    required this.aboutUs,
    required this.links,
  });

  Future<void> _launchUrl(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        massege(context, "unknown_error".tr(context), Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: Column(
        children: [
          // --- 1. Brand Header ---
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Column(
              children: [
                Image.asset(
                  AppImagesAssets.logoNoBg,
                  height: 15.h,
                  width: 15.h,
                ),
                SizedBox(height: 2.h),
                Text(
                  aboutUs.shopName ?? "Syring",
                  style: TextStyle(
                    color: AppColors.primaryColors,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  aboutUs.descrption ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    height: 1.5,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // --- 2. Contact Information ---
          _SectionHeader(
              title: "contact_info".tr(context),
              icon: Icons
                  .contact_phone_rounded), // Ensure you have this key or use "Contact Info"

          SizedBox(height: 1.5.h),

          // Phone Numbers List
          if (aboutUs.phoneNumber != null)
            _ContactTile(
              value: aboutUs.phoneNumber!,
              icon: Icons.phone_in_talk,
              onTap: () => _launchUrl("tel:${aboutUs.phoneNumber}", context),
            ),

          // Hardcoded extra numbers from your previous code
          _ContactTile(
            value: "+963980555592",
            icon: Icons.support_agent,
            onTap: () => _launchUrl("tel:+963980555592", context),
          ),
          _ContactTile(
            value: "+936937816715",
            icon: Icons.headset_mic,
            onTap: () => _launchUrl("tel:+936937816715", context),
          ),

          SizedBox(height: 3.h),

          // --- 3. Social Media Links ---
          if (links.data != null && links.data!.isNotEmpty) ...[
            _SectionHeader(
                title: "follow_us".tr(context),
                icon: Icons.public), // Ensure key or use "Follow Us"
            SizedBox(height: 1.5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(links.data!.length, (index) {
                final link = links.data![index].link;
                // Cycle through icons securely
                final iconData =
                    icons.length > index ? icons[index] : Icons.link;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _SocialButton(
                    icon: iconData,
                    onTap: () =>
                        link != null ? _launchUrl(link, context) : null,
                  ),
                );
              }),
            ),
            SizedBox(height: 4.h),
          ],

          // --- 4. Developer Credits (Footer) ---
          Column(
            children: [
              Text(
                "development_by".tr(context),
                style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1),
              ),
              const SizedBox(height: 8),
              Text(
                "${aboutUs.companyName ?? "Tech Company"}\nAli Al-Hadi Nizam  •  Ayham Kefo",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColors.withOpacity(0.8),
                    height: 1.5),
              ),
              SizedBox(height: 3.h),
              Text(
                "v 1.0.0", // Version
                style: TextStyle(color: Colors.grey[300], fontSize: 9.sp),
              )
            ],
          ),
        ],
      ),
    );
  }
}

// --- Helper Widgets ---

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: AppColors.primaryColors),
        SizedBox(width: 2.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _ContactTile extends StatelessWidget {
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  const _ContactTile({
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 0, // Flat look
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColors.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child:
                      Icon(icon, color: AppColors.primaryColors, size: 16.sp),
                ),
                SizedBox(width: 4.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5),
                    ),
                  ],
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 10.sp, color: Colors.grey[300])
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ]),
        child: Icon(icon, color: AppColors.primaryColors, size: 20.sp),
      ),
    );
  }
}
