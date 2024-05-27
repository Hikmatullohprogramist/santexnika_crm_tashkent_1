import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santexnika_crm/screens/firms/cubit/company_cubit.dart';
import 'package:santexnika_crm/screens/settings/cubit/types/types_cubit.dart';
import 'package:santexnika_crm/screens/settings/cubit/users/users_cubit.dart';
import 'package:santexnika_crm/widgets/buttons.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';

import '../../../../tools/appColors.dart';
import '../../../../widgets/input/post_input.dart';
import '../../../../widgets/sized_box.dart';
import '../../../../widgets/text_widget/text_widget.dart';
import '../../../settings/cubit/price/price_cubit.dart';

class UserPaymentAddWidget extends StatefulWidget {
  final int id;

  const UserPaymentAddWidget({super.key, required this.id});

  @override
  State<UserPaymentAddWidget> createState() => _UserPaymentAddWidgetState();
}

class _UserPaymentAddWidgetState extends State<UserPaymentAddWidget> {
  TextEditingController txtPrice = TextEditingController();
  TextEditingController txtComment = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const TextWidget(txt: "Ishchini oylik tolovi"),
        Column(
          children: [
            PostInput(
              controller: txtPrice,
              label: "Summa",
              txtColor: Colors.white,
              inputWidth: double.infinity,
              radius: 5,
            ),
            Hg(
              height: 20.h,
            ),
            PostInput(
              controller: txtComment,
              label: "Izoh",
              txtColor: Colors.white,
              inputWidth: double.infinity,
              radius: 5,
            ),
          ],
        ),
        CustomButtons(
          onTap: () {
            if (txtPrice.text.isNotEmpty) {
              context
                  .read<UsersCubit>()
                  .postUserPaymentHistory(double.parse(txtPrice.text),
                      txtComment.text.trim(), widget.id)
                  .then(
                    (value) => Navigator.pop(context),
                  );
            } else {
              errorDialogWidgets(context);
            }
          },
        )
      ],
    );
  }
}
