import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santexnika_crm/errors/service_error.dart';
import 'package:santexnika_crm/models/pruduct/productModel.dart';
import 'package:santexnika_crm/models/transfer_model.dart';
import 'package:santexnika_crm/screens/firms/cubit/company_cubit.dart';
import 'package:santexnika_crm/screens/store/cubit/store_cubit.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/widgets/button_widget.dart';
import 'package:santexnika_crm/widgets/input/post_input.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

class TransferForFirms extends StatefulWidget {
  final List<ProductModel> selectedProducts;
  final String? query;

  const TransferForFirms(
      {super.key, required this.selectedProducts, this.query});

  @override
  State<TransferForFirms> createState() => _TransferForFirmsState();
}

class _TransferForFirmsState extends State<TransferForFirms> {
  int? selectedCompany;

  List<TransferModel> readyProducts = [];

  final Map<int, TextEditingController> _controllers = {};

  void _initControllers() {
    widget.selectedProducts.asMap().forEach((index, product) {
      _controllers[index] ??= TextEditingController(text: "0");
    });
  }

  @override
  void initState() {
    super.initState();
    _initControllers();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<CompanyCubit>().getCompany(1, 100000);
    });
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Align(
            alignment: Alignment.center,
            child: TextWidget(
              txt: "Firmaga biriktirish",
            )),
        const Hg(),
        SizedBox(
          height: 100.h,
          child: BlocBuilder<CompanyCubit, CompanyState>(
            builder: (context, state) {
              if (state is CompanyLoadingState) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              } else if (state is CompanyErrorState) {
                return const TextWidget(txt: postError);
              } else if (state is CompanySuccessState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      txt: 'Firmani tanlang',
                      size: 14.sp,
                    ),
                    Hg(
                      height: 8.h,
                    ),
                    Container(
                      height: 40.spMax,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(5.r),
                        border: Border.all(
                          color: AppColors.borderColor,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          dropdownColor: AppColors.primaryColor,
                          focusColor: Colors.black,
                          value: selectedCompany,
                          items: state.data.data.map((value) {
                            return DropdownMenuItem(
                              value: value.id,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                ),
                                child: TextWidget(
                                  txt: value.name ?? "",
                                  txtColor: Colors.white,
                                  size: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            selectedCompany = value;

                            setState(() {});
                          },
                          isExpanded: true,
                          hint: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                            ),
                            child: const Text(
                              "Filialni tanlang",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
        const Hg(),
        Expanded(
          child: widget.selectedProducts.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.selectedProducts.length,
                  itemBuilder: (ctx, index) {
                    var data = widget.selectedProducts[index];

                    _controllers[index] ??= TextEditingController(text: "0");
                    // _controllers[index]!.text = "0";

                    return Card(
                      color: AppColors.toqPrimaryColor,
                      margin: const EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextWidget(
                          txt: "${data.name ?? "N/A"} ${index + 1}",
                          txtColor: AppColors.whiteColor,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         TextWidget(
                        //           txt: "${data.name ?? "N/A"} ${index + 1}",
                        //           txtColor: AppColors.whiteColor,
                        //         ),
                        //         Row(
                        //           crossAxisAlignment: CrossAxisAlignment.end,
                        //           children: [
                        //             TextWidget(
                        //               txt:
                        //                   "Ombordagi miqdori ${data.quantity ?? "N/A"} /",
                        //               txtColor: AppColors.whiteColor,
                        //             ),
                        //             const Wd(),
                        //             PostInput(
                        //               label: "Soni",
                        //               controller: _controllers[index],
                        //               // Use the controller for this index
                        //
                        //               txtColor: AppColors.whiteColor,
                        //               keyboardType:
                        //                   const TextInputType.numberWithOptions(
                        //                 decimal: true,
                        //               ),
                        //               inputFormatter: [
                        //                 FilteringTextInputFormatter.allow(
                        //                   RegExp(r'^\d*\.?\d*'),
                        //                 ),
                        //               ],
                        //             ),
                        //           ],
                        //         ),
                        //       ],
                        //     ),
                        //     ButtonWidget(
                        //       radius: 12,
                        //       color: AppColors.primaryColor,
                        //       label: "O'chirish",
                        //       height: 60.h,
                        //       fontSize: 16.sp,
                        //       width: 200.w,
                        //       iconSize: 32,
                        //       icon: Icons.remove_circle,
                        //       onTap: () {
                        //         widget.selectedProducts.remove(data);
                        //         setState(() {});
                        //       },
                        //     ),
                        //   ],
                        // ),
                      ),
                    );
                  })
              : const Center(
                  child: TextWidget(txt: "Tovarlar hali tanlanmadi !")),
        ),
        const Hg(),
        ButtonWidget(
          radius: 12,
          color: AppColors.primaryColor,
          label: "Tasdiqlash",
          height: 60.h,
          fontSize: 16.sp,
          iconSize: 32,
          icon: Icons.done_all,
          iconColor: AppColors.successColor,
          onTap: () async {
            if (selectedCompany != null) {
              List<int> readyProducts =
                  widget.selectedProducts.map((e) => e.id!).toList();

              context
                  .read<CompanyCubit>()
                  .attachProduct(selectedCompany!, readyProducts)
                  .then((_) {
                if (widget.query != "") {
                  context.read<StoreCubit>().searchProduct(widget.query!);
                }

                widget.selectedProducts.clear();
                Navigator.of(context).pop();
              }).catchError((error) {
                if (kDebugMode) {
                  print(error);
                }
              });
            } else {
              errorDialogWidgets(context);
            }
          },
        ),
        const Hg(),
      ],
    );
  }
}
