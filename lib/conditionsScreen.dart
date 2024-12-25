import 'package:zein_store/Future/Auth/Pages/login_screen.dart';
import 'package:zein_store/Utils/app_localizations.dart';
import 'package:zein_store/Utils/colors.dart';
import 'package:zein_store/Utils/constants.dart';
import 'package:zein_store/Utils/images.dart';
import 'package:zein_store/Utils/services/save.dart';
import 'package:zein_store/terms.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ConditionsScreen extends StatefulWidget {
  const ConditionsScreen({required this.home, super.key});
  final bool home;
  @override
  State<ConditionsScreen> createState() => _ConditionsScreenState();
}

class _ConditionsScreenState extends State<ConditionsScreen> {
  bool isChecked = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            foregroundColor: Colors.white,
            scrolledUnderElevation: 0,
            backgroundColor: AppColors.primaryColors,
            centerTitle: true,
            title: Text('title_conditions'.tr(context),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ))),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              children: [
                Center(
                  child: Image.asset(
                    AppImagesAssets.logoNoBg,
                    height: 20.h,
                  ),
                ),
                Text('condition_description'.tr(context)),
                ListView.builder(
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
                          term['title'][lang] ?? '',
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
                                  subTerm["title"][lang] ?? '',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (subTerm["bio"][lang] != '')
                                  const SizedBox(height: 4),
                                // Render the sub-term description
                                if (subTerm["bio"][lang] != '')
                                  Text(
                                    subTerm["bio"][lang] ?? '',
                                    style: TextStyle(fontSize: 10.sp),
                                  ),
                                const SizedBox(height: 8),
                                // Render any conditions under the sub-term
                                if (subTerm["body"] is List)
                                  ...subTerm["body"].map<Widget>((cond) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          left: lang == "ar" ? 0 : 24,
                                          right: lang == "ar" ? 24 : 0,
                                          top: 4,
                                          bottom: 4),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            color:
                                                AppColors.buttonCategoryColor,
                                            size: 12.sp,
                                          ),
                                          SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              "${cond[lang]}",
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(fontSize: 8.sp),
                                            ),
                                          ),
                                        ],
                                      ),
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
                if (!widget.home)
                  Column(
                    children: [
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
                            minimumSize:
                                Size(double.infinity, 50), // Full-width button
                          )),
                      SizedBox(
                        height: 16,
                      )
                    ],
                  )
              ],
            ),
          ),
        ));
  }
}
