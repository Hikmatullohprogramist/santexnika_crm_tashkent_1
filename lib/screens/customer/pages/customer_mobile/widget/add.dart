import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

import '../../../../../widgets/input/phone_input.dart';
import '../../../../../widgets/mobile/button.dart';
import '../../../../../widgets/mobile/mobile_input.dart';
import '../../../../../widgets/my_dialog_widget.dart';
import '../../../../../widgets/sized_box.dart';
import '../../../../../widgets/text_widget/text_widget.dart';
import '../../../cubit/customer_cubit.dart';

class MobileAddCustomer extends StatefulWidget {
  final bool forAdd;
  final String? name;
  final String? phone;
  final String? comment;
  final int? id;

  const MobileAddCustomer(
      {super.key,
      required this.forAdd,
      this.name,
      this.phone,
      this.comment,
      this.id});

  @override
  State<MobileAddCustomer> createState() => _MobileAddCustomerState();
}

class _MobileAddCustomerState extends State<MobileAddCustomer> {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtPhone = TextEditingController();
  TextEditingController txtComment = TextEditingController();
  String txt = '';

  @override
  void dispose() {
    txtName.dispose();
    txtComment.dispose();
    txtPhone.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.forAdd) {
      txt = "qo'shish";
    } else {
      txtName.text = widget.name.toString();
      txtPhone.text = widget.phone.toString();
      txtComment.text = widget.comment.toString();
      txt = "o'zgartirish";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextWidget(txt: "Haridor $txt"),
            MobileInput(
              controller: txtName,
              label: "Nomi",
            ),
            PhoneInput(
              inputWidth: double.infinity,
              controller: txtPhone,
              label: 'Telefon nomer',
            ),
            MobileInput(
              controller: txtComment,
              label: 'Izoh',
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: MobileButton(
                    icon: Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                    label: "Bekor qilish",
                    onTap: () {
                      Get.back();
                    },
                  ),
                ),
                const Wd(),
                Expanded(
                  child: MobileButton(
                    icon: Icon(
                      Icons.save,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                    label: "Saqlash",
                    onTap: () {
                      if (widget.forAdd) {
                        if (txtName.text.isNotEmpty || txtPhone.text.isNotEmpty) {
                          context
                              .read<CustomerCubit>()
                              .postCustomer(
                                txtName.text.trim(),
                                txtPhone.text,
                                txtComment.text.trim(),
                                1,
                              )
                              .then(
                            (_) {
                              context.read<CustomerCubit>().getCustomer(0, "");
                              Get.back();
                            },
                          ).catchError(
                            (error) {
                              print(error);
                            },
                          );
                        } else {
                          mobileErrorDialogWidgets(context);
                        }
                      } else {
                        if (txtName.text.isNotEmpty || txtPhone.text.isNotEmpty) {
                          context.read<CustomerCubit>().updateCustomer(
                                txtName.text.trim(),
                                txtPhone.text,
                                txtComment.text.trim(),
                                1,
                                widget.id!,
                              );
      
                          context.read<CustomerCubit>().getCustomer(0, "");
                          Get.back();
                        } else {
                          mobileErrorDialogWidgets(context);
                        }
                      }
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
