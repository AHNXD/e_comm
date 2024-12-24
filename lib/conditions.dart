import 'package:e_comm/Future/Auth/Pages/login_screen.dart';
import 'package:e_comm/Future/Auth/cubit/auth_cubit.dart';
import 'package:e_comm/Future/Home/Pages/navbar_screen.dart';
import 'package:e_comm/Utils/app_localizations.dart';
import 'package:e_comm/Utils/colors.dart';
import 'package:e_comm/Utils/images.dart';
import 'package:e_comm/Utils/services/save.dart';
import 'package:e_comm/terms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class ConditionsScreen extends StatefulWidget {
  const ConditionsScreen({super.key});

  @override
  State<ConditionsScreen> createState() => _ConditionsScreenState();
}

class _ConditionsScreenState extends State<ConditionsScreen> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    // Determine the terms to use based on locale
    final terms = SaveService.retrieve("LOCALE") == "ar" ? termsAR : termsEN;

    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Text('title_conditions'.tr(context),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.primaryColors,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp)),
            Center(
              child: Image.asset(
                AppImagesAssets.logoNoBg,
                height: 20.h,
              ),
            ),
            Text('conditio n_description'.tr(context)),
            Expanded(
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: terms.length,
                itemBuilder: (BuildContext context, int index) {
                  final term = terms[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Render the main term title
                      Text(
                        term['title'] ?? '',
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColors),
                      ),
                      const SizedBox(height: 8),
                      // Render nested sub-terms
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: term["body"]?.length ?? 0,
                        itemBuilder: (BuildContext context, int subIndex) {
                          final subTerm = term["body"][subIndex];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Render the sub-term title
                              Text(
                                subTerm["title"] ?? '',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Render the sub-term description
                              if (subTerm["bio"] != "")
                                Text(
                                  subTerm["bio"] ?? '',
                                  style: TextStyle(fontSize: 10.sp),
                                ),
                              const SizedBox(height: 8),
                              // Render any conditions under the sub-term
                              if (subTerm["body"] is List)
                                ...subTerm["body"].map<Widget>((cond) {
                                  return Text(
                                    textAlign: TextAlign.justify,
                                    "- $cond",
                                    style: TextStyle(fontSize: 8.sp),
                                  );
                                }).toList(),
                              const SizedBox(height: 8),
                            ],
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value ?? false;
                    });
                  },
                ),
                Text(
                  "agree_terms".tr(context),
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            ElevatedButton(
                onPressed: isChecked
                    ? () async {
                        await SaveService.saveBool("terms", true);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (builder) {
                          return LoginScreen();
                        }));
                      }
                    : null, // Disable the button if not checked
                child: Text("submit".tr(context)),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50), // Full-width button
                ))
          ],
        ),
      ),
    ));
  }
}
