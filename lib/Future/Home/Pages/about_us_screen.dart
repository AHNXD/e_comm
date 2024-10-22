import 'package:e_comm/Future/Home/Cubits/aboutUs/about_us_cubit.dart';
import 'package:e_comm/Future/Home/Widgets/error_widget.dart';
import 'package:e_comm/Future/Home/models/aboutUs_model.dart';
import 'package:e_comm/Future/Home/models/links_model.dart';
import 'package:e_comm/Utils/functions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/Utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../Utils/colors.dart';

final List<IconData> icons = [Icons.facebook, Icons.message, Icons.pin_drop];

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AboutUsCubit>().getAboutUsInfo();
    return Scaffold(
      //     appBar: PreferredSize(
      // preferredSize: AppBar().preferredSize,
      // child: BackWidget(
      //   canPop: false,
      //   hasBackButton: false,
      //   text: "about_us".tr(context),
      //   hasStyle: false,
      //   iconColor: Colors.black,
      //   textColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.primaryColors,
        centerTitle: true,
        title: Text(
          "about_us".tr(context),
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SafeArea(child: BlocBuilder<AboutUsCubit, AboutUsState>(
        builder: (context, state) {
          if (state is GetAboutUsSuccessfulState) {
            return AboutUsWidget(aboutUs: state.aboutUs, links: state.links);
          } else if (state is GetAboutUsErrorState) {
            return MyErrorWidget(
                msg: state.msg,
                onPressed: () {
                  context.read<AboutUsCubit>().getAboutUsInfo();
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )),
    );
  }
}

class AboutUsWidget extends StatelessWidget {
  final AboutUsModel aboutUs;
  final Links links;
  const AboutUsWidget({super.key, required this.aboutUs, required this.links});
  void _launchUrl(String url, BuildContext context) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      massege(context, "unknown_error".tr(context), Colors.red);
    }
  }

  IconData _getIconData(int index) {
    return icons[index];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Image.asset(
            AppImagesAssets.logoNoBg,
            height: 220,
            width: 220,
          ),
        ),
        Center(
          child: Text(
            aboutUs.shopName ?? "",
            style: TextStyle(
                color: Colors.black,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold),
          ),
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.w),
              gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.indigo, Colors.purple])),
          margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          child: Center(
            child: Text(
              aboutUs.descrption ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp),
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 8),
          child: RichText(
            text: TextSpan(
              text: "phone_number".tr(context),
              children: [
                TextSpan(
                  text: "\n${aboutUs.phoneNumber ?? ""}",
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp),
                ),
              ],
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const Spacer(),
        SizedBox(
          height: 60,
          child: Center(
            child: ListView.builder(
              itemCount: links.data!.length ?? 0,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                final link = links.data?[index].link;
                final iconData = _getIconData(index);

                return IconButton(
                    onPressed: () {
                      if (link != null) {
                        _launchUrl(link, context);
                      } else {
                        massege(
                            context, "unknown_error".tr(context), Colors.red);
                      }
                    },
                    icon: Icon(
                      iconData,
                      size: 32.0,
                      color: AppColors.primaryColors,
                    ));
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 3.h),
          child: Column(
            children: [
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "development_by".tr(context),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                          text: "\n${aboutUs.companyName ?? ""}",
                          style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue))
                    ],
                  )),
            ],
          ),
        )
      ],
    );
  }
}
