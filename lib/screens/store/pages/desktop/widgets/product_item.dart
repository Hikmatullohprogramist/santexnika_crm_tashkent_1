
import 'package:flutter/material.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

class ProductItem extends StatelessWidget {
  final String title;
  final String subTitle;
  final int index;

  const ProductItem(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: AppColors.bottombarColor,
      child: ListTile(
        dense: true,
        title: TextWidget(
          txt: title,
        ),
        subtitle: TextWidget(
          txt: subTitle,
          size: 12,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        isThreeLine: true,
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.image,
              semanticLabel: "Label",
              color: AppColors.whiteColor,
            )),
        trailing: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.menu,
            color: AppColors.whiteColor,
          ),
        ),
      ),
    );
  }
}
