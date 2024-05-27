import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santexnika_crm/widgets/mobile/button.dart';
import 'package:santexnika_crm/widgets/mobile/mobile_input.dart';

import '../../../../../models/pruduct/productModel.dart';
import '../../../../../models/transfer_model.dart';
import '../../../../../tools/appColors.dart';
import '../../../../../widgets/my_dialog_widget.dart';
import '../../../../../widgets/sized_box.dart';
import '../../../../../widgets/text_widget/text_widget.dart';
import '../../../../settings/cubit/branches/branches_cubit.dart';
import '../../../cubit/store_cubit.dart';

class MobileTransferUi extends StatefulWidget {
  final List<ProductModel> selectedProducts;

  const MobileTransferUi({super.key, required this.selectedProducts});

  @override
  State<MobileTransferUi> createState() => _MobileTransferUiState();
}

class _MobileTransferUiState extends State<MobileTransferUi> {
  int? selectedBranch;
  Map<int, TextEditingController> _controllers = {};

  void _initControllers() {
    widget.selectedProducts.asMap().forEach((index, product) {
      _controllers[index] ??= TextEditingController(text: "");
    });
  }

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const TextWidget(txt: "Filialga o'tlazish"),
        const Hg(
          height: 20,
        ),
        BlocBuilder<BranchesCubit, BranchesState>(
          builder: (context, state) {
            if (state is BranchesLoadingState) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (state is BranchesErrorState) {
              return TextWidget(txt: state.error);
            } else if (state is BranchesSuccessState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    txt: 'Filialni tanlang',
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
                        value: selectedBranch,
                        items: state.data.map((value) {
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
                          setState(() {
                            selectedBranch = value;
                          });
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
        const Hg(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                widget.selectedProducts.isNotEmpty
                    ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.selectedProducts.length,
                        itemBuilder: (context, index) {
                          var data = widget.selectedProducts[index];
                          _controllers[index] ??=
                              TextEditingController(text: '');
                          _controllers[index]!.text = "0";
                          return Card(
                            color: AppColors.toqPrimaryColor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    child: TextWidget(txt: data.name ?? ''),
                                    alignment: Alignment.center,
                                  ),
                                  const Hg(),
                                  TextWidget(
                                    txt:
                                        "Ombordagi miqdor/${data.quantity ?? "N|A"}",
                                    fontWeight: FontWeight.w400,
                                    size: 16.sp,
                                  ),
                                  const Hg(),
                                  MobileInput(
                                    label: "Soni",
                                    controller: _controllers[index],
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                    inputFormatter: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d*'),
                                      ),
                                    ],
                                  ),
                                  const Hg(),
                                  MobileButton(
                                    height: 50,
                                    color: AppColors.errorColor,
                                    width: double.infinity,
                                    label: "O'chirish",
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    onTap: () {
                                      widget.selectedProducts.remove(data);
                                      setState(() {});
                                    },
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: TextWidget(txt: "Tovarlar hali tanlanmadi !"),
                      ),
              ],
            ),
          ),
        ),
        const Hg(),
        MobileButton(
          height: 50,
          width: double.infinity,
          label: 'Tasdiqlash',
          icon: Icon(
            Icons.done_all,
            color: AppColors.selectedColor,
          ),
          onTap: () async {
            if (selectedBranch != null) {
              List<TransferModel> readyProducts =
                  widget.selectedProducts.asMap().entries.map((entry) {
                int index = entry.key;
                var product = entry.value;
                TextEditingController controller = _controllers[index]!;

                int quantity = int.tryParse(controller.text.trim()) ?? 0;

                return TransferModel(
                  branchId: selectedBranch!,
                  storeId: product.id!,
                  quantity: quantity,
                );
              }).toList();

              await context
                  .read<StoreCubit>()
                  .transfer2Branches(readyProducts)
                  .then((_) {
                Navigator.of(context).pop(); // Close the dialog
              }).catchError((error) {
                print(error);
              });
            } else {
              errorDialogWidgets(context);
            }
          },
        )
      ],
    );
  }
}
