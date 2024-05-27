import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/widgets/mobile/button.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';
import 'package:get/get.dart';

import 'button_widget.dart';

void showCustomDialogWidget(
  BuildContext context,
  Widget child,
  double width,
  double height,
) async {
  showGeneralDialog(
    barrierColor: Colors.black.withOpacity(0.5),
    transitionBuilder: (context, a1, a2, widget) {
      final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
      return Transform(
        transform: Matrix4.translationValues(
          0.0,
          curvedValue * 200,
          0.0,
        ),
        child: Center(
          child: Material(
            color: AppColors.bottombarColor,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: MediaQuery.of(context).size.width / width,
              height: MediaQuery.of(context).size.height / height,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: AppColors.bottombarColor,
                  borderRadius: BorderRadius.circular(10)),
              child: child,
            ),
          ),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
    barrierDismissible: true,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, animation1, animation2) {
      return Container();
    },
  );
}

Future showCustomDialogWidgetAsync(
  BuildContext context,
  Widget child,
  double width,
  double height,
) async {
  return showGeneralDialog(
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionBuilder: (context, a1, a2, widget) {
      final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
      return Transform(
        transform: Matrix4.translationValues(
          0.0,
          curvedValue * 200,
          0.0,
        ),
        child: Center(
          child: Material(
            color: AppColors.bottombarColor,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: MediaQuery.of(context).size.width / width,
              height: MediaQuery.of(context).size.height / height,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: AppColors.bottombarColor,
                  borderRadius: BorderRadius.circular(10)),
              child: child,
            ),
          ),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
    barrierLabel: '',
    context: context,
    pageBuilder: (context, animation1, animation2) {
      return Container();
    },
  );
}

void showMobileDialogWidget(
  BuildContext context,
  Widget child,
  double width,
  double height,
) async {
  showGeneralDialog(
    barrierColor: Colors.black.withOpacity(0.5),
    transitionBuilder: (context, a1, a2, widget) {
      final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
      return Transform(
        transform: Matrix4.translationValues(
          0.0,
          curvedValue * 200,
          0.0,
        ),
        child: Center(
          child: Material(
            color: AppColors.bottombarColor,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: MediaQuery.of(context).size.width / width,
              height: MediaQuery.of(context).size.height / height,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: AppColors.bottombarColor,
                  borderRadius: BorderRadius.circular(10)),
              child: child,
            ),
          ),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
    barrierDismissible: true,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, animation1, animation2) {
      return Container();
    },
  );
}

void errorDialogWidgets(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black45,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (BuildContext buildContext, Animation animation,
        Animation secondaryAnimation) {
      return Center(
        child: Material(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.primaryColor,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.primaryColor),
            width: 300.w,
            height: 110.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const TextWidget(
                  txt: 'Xatolik',
                  txtColor: Colors.red,
                ),
                TextWidget(
                  txt: 'Iltimos, barcha maydonlarni toʻldiring',
                  size: 13.sp,
                ),
                Hg(),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        child: TextWidget(
                          txt: "OK",
                          size: 11.sp,
                          txtColor: Colors.blue,
                        ),
                        onTap: () {
                          Get.back();
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

void mobileErrorDialogWidgets(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black45,
    transitionDuration: const Duration(milliseconds: 200),
    transitionBuilder: (context, a1, a2, widget) {
      final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;

      return Transform(
        transform: Matrix4.translationValues(
          0.0,
          curvedValue * 200,
          0.0,
        ),
        child: Center(
          child: Material(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.primaryColor,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.primaryColor),
              width: MediaQuery.sizeOf(context).width / 1.5,
              height: 130,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const TextWidget(
                    txt: 'Xatolik',
                    txtColor: Colors.red,
                    size: 22,
                    fontWeight: FontWeight.w600,
                  ),
                  Hg(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextWidget(
                      txt: 'Iltimos, barcha maydonlarni toʻldiring',
                      size: 13.sp,
                    ),
                  ),
                  Hg(
                    height: 5,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          child: TextWidget(
                            txt: "OK",
                            size: 15.sp,
                            txtColor: Colors.blue,
                          ),
                          onTap: () {
                            Get.back();
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return SizedBox();
    },
  );
}

void deletedDialog(
  BuildContext context,
  VoidCallback onTap,
) {
  showCustomDialogWidget(
    context,
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(
          txt: "O'chirish",
          txtColor: Colors.red,
          size: 24.sp,
        ),
        const TextWidget(
          txt: "Rostdan ham o`chirmoqchimisiz?",
        ),
        Row(
          children: [
            Expanded(
              child: ButtonWidget(
                color: AppColors.primaryColor,
                isVisible: false,
                onTap: () {
                  Get.back();
                },
                label: 'Bekor qilish',
              ),
            ),
            const Wd(),
            Expanded(
              child: ButtonWidget(
                color: AppColors.primaryColor,
                isVisible: false,
                onTap: onTap,
                label: "O'chirish",
              ),
            ),
          ],
        )
      ],
    ),
    4,
    5,
  );
}

void mobileDeletedDialog(
  BuildContext context,
  VoidCallback onTap,
) {
  showCustomDialogWidget(
    context,
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(
          txt: "O'chirish",
          txtColor: Colors.red,
          size: 24.sp,
        ),
        const TextWidget(
          txt: "Rostdan ham o`chirmoqchimisiz?",
        ),
        Row(
          children: [
            Expanded(
              child: MobileButton(
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                  size: 20,
                ),
                color: AppColors.primaryColor,
                isVisible: true,
                onTap: () {
                  Get.back();
                },
                label: 'Bekor qilish',
              ),
            ),
            const Wd(),
            Expanded(
              child: MobileButton(
                color: AppColors.primaryColor,
                isVisible: true,
                onTap: onTap,
                label: "O'chirish",
                icon: Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                  size: 20,
                ),
              ),
            ),
          ],
        )
      ],
    ),
    1.1,
    4,
  );
}
