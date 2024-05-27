import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santexnika_crm/tools/format_date_time.dart';
import 'package:santexnika_crm/widgets/background_widget.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';

import '../../../../../tools/appColors.dart';
import '../../../../../widgets/mobile/sotre_text.dart';

class MobileStoreListTitle extends StatefulWidget {
  final String name;
  final double quality;
  final String category;
  final dynamic image;
  final String oem;
  final double barCode;
  final double comePrice;
  final double sellPrice;
  final DateTime date;
  final Color? color;
  final VoidCallback? onTap;

  final bool? checkBox;
  final Function(bool?)? onChanged;

  const MobileStoreListTitle({
    super.key,
    required this.name,
    required this.quality,
    required this.category,
    required this.oem,
    required this.barCode,
    required this.comePrice,
    required this.sellPrice,
    required this.date,
    this.image,
    this.checkBox,
    this.onChanged,
    this.color,
    this.onTap,
  });

  @override
  State<MobileStoreListTitle> createState() => _MobileStoreListTitleState();
}

class _MobileStoreListTitleState extends State<MobileStoreListTitle> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: MobileBackgroundWidget(
        color: widget.color,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12.0.w,
                vertical: 8,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.borderColor),
                      ),
                      width: 120.w,
                      child: Center(
                        child:widget.image!=null? Image.network(
                          widget.image,
                        ):Image.asset('assets/no_image.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    StoreTextWidget(txt: widget.name),
                    StoreTextWidget(txt: "${widget.quality} ta"),
                    StoreTextWidget(txt: widget.category),
                    StoreTextWidget(txt: widget.oem),
                    StoreTextWidget(txt: widget.barCode.toString()),
                    Row(
                      children: [
                        StoreTextWidget(
                          txt: widget.comePrice.toString(),
                          color: AppColors.errorColor,
                        ),
                        const Wd(),
                        StoreTextWidget(
                          txt: widget.sellPrice.toString(),
                          color: AppColors.whiteColor,
                        ),
                      ],
                    ),
                    Visibility(
                      visible: true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StoreTextWidget(
                            txt: formatDate(widget.date),
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
