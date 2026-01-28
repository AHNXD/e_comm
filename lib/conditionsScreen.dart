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
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        foregroundColor: Colors.black87,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'title_conditions'.tr(context),
          textAlign: TextAlign.center,
          style: TextStyle(
              color: AppColors.textTitleAppBarColor,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp),
        ),
      ),
      body: Column(
        children: [
          // --- Scrollable Content ---
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              children: [
                // Logo Header
                Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 2.h),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: Image.asset(
                      AppImagesAssets.logoNoBg,
                      height: 10.h,
                    ),
                  ),
                ),

                // Intro Text
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    'condition_description'.tr(context),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                ),

                // Terms List
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: terms.length,
                  separatorBuilder: (context, index) => SizedBox(height: 2.h),
                  itemBuilder: (BuildContext context, int index) {
                    final term = terms[index];
                    return _TermCard(term: term);
                  },
                ),

                // Bottom padding for scroll
                SizedBox(height: 10.h),
              ],
            ),
          ),

          // --- Sticky Footer (Only if not from Home) ---
          if (!widget.home)
            Container(
              padding: EdgeInsets.all(5.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        activeColor: AppColors.primaryColors,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        onChanged: (value) {
                          setState(() {
                            isChecked = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isChecked = !isChecked;
                            });
                          },
                          child: Text(
                            "agree_terms".tr(context),
                            style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.h),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: isChecked
                          ? () async {
                              await SaveService.saveBool("terms", true);
                              if (context.mounted) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => LoginScreen()));
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonCategoryColor,
                        disabledBackgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: isChecked ? 4 : 0,
                      ),
                      child: Text(
                        "submit".tr(context),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: isChecked ? Colors.white : Colors.grey[500],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}

// --- Component: Term Card ---
class _TermCard extends StatelessWidget {
  final Map term;

  const _TermCard({required this.term});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Title
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                    color: AppColors.primaryColors,
                    borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  term['title'][lang] ?? '',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryColors,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Sub-terms List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: term["body"]?.length ?? 0,
            itemBuilder: (BuildContext context, int subIndex) {
              final subTerm = term["body"][subIndex];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sub-term Title
                    if (subTerm["title"][lang] != null &&
                        subTerm["title"][lang] != '')
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Text(
                          subTerm["title"][lang],
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                    // Sub-term Bio/Description
                    if (subTerm["bio"][lang] != null &&
                        subTerm["bio"][lang] != '')
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          subTerm["bio"][lang],
                          style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.grey[700],
                              height: 1.4),
                        ),
                      ),

                    // Conditions List (Bullets)
                    if (subTerm["body"] is List &&
                        (subTerm["body"] as List).isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F7),
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          children:
                              (subTerm["body"] as List).map<Widget>((cond) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Icon(
                                      Icons.circle,
                                      color: AppColors.buttonCategoryColor,
                                      size: 5.sp,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "${cond[lang]}",
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                          fontSize: 9.sp,
                                          color: Colors.grey[800],
                                          height: 1.4),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
