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

class UserPaymentUpdateWidget extends StatefulWidget {
  final int userId;
  final int paymentId;
  final String paymentPrice;
  final String paymentComment;

  const UserPaymentUpdateWidget(
      {required this.userId,
      required this.paymentId,
      required this.paymentPrice,
      required this.paymentComment});

  @override
  State<UserPaymentUpdateWidget> createState() =>
      _UserPaymentUpdateWidgetState();
}

class _UserPaymentUpdateWidgetState extends State<UserPaymentUpdateWidget> {
  TextEditingController txtPrice = TextEditingController();
  TextEditingController txtComment = TextEditingController();

  @override
  void initState() {
    txtComment.text = widget.paymentComment;
    txtPrice.text = widget.paymentPrice;
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
                  .updateUserPaymentHistory(double.parse(txtPrice.text),
                      txtComment.text.trim(), widget.userId, widget.paymentId)
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
