import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santexnika_crm/errors/service_error.dart';
import 'package:santexnika_crm/models/pruduct/productModel.dart';
import 'package:santexnika_crm/models/transfer_model.dart';
import 'package:santexnika_crm/screens/settings/cubit/branches/branches_cubit.dart';
import 'package:santexnika_crm/screens/store/cubit/store_cubit.dart';
import 'package:santexnika_crm/screens/store/pages/check_branch2branch.dart';
import 'package:santexnika_crm/screens/store/pages/desktop/store_desktop/store_desktop.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/tools/constantas.dart';
import 'package:santexnika_crm/tools/format_date_time.dart';
import 'package:santexnika_crm/widgets/button_widget.dart';
import 'package:santexnika_crm/widgets/input/post_input.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/text_widget.dart';

class Transfer2Brach extends StatefulWidget {
  final List<ProductModel> selectedProducts;
  String? query;

  Transfer2Brach({
    super.key,
    required this.selectedProducts,
    this.query,
  });

  @override
  State<Transfer2Brach> createState() => _Transfer2BrachState();
}

class _Transfer2BrachState extends State<Transfer2Brach> {
  int? selectedBranch;
  String? selectedBranchName;

  List<TransferModel> readyProducts = [];

  final Map<int, TextEditingController> _controllers = {};

  void _initControllers() {
    widget.selectedProducts.asMap().forEach((index, product) {
      _controllers[index] ??= TextEditingController(text: "0");
    });
  }

  final GlobalKey<StoreDesktopUIState> storeKeyState =
      GlobalKey<StoreDesktopUIState>();
  @override
  void initState() {
    super.initState();
    _initControllers();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<BranchesCubit>().getBranches();
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
              txt: "Filialga o'tkazish",
            )),
        const Hg(),
        SizedBox(
          height: 100.h,
          child: BlocBuilder<BranchesCubit, BranchesState>(
            builder: (context, state) {
              if (state is BranchesLoadingState) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              } else if (state is BranchesErrorState) {
                return const TextWidget(txt: postError);
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
                            selectedBranch = value;
                            selectedBranchName = state.data
                                    .firstWhere(
                                        (element) => element.id == value)
                                    .name ??
                                "";

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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  txt: "${data.name ?? "N/A"} ${index + 1}",
                                  txtColor: AppColors.whiteColor,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    TextWidget(
                                      txt:
                                          "Ombordagi miqdori ${data.quantity ?? "N/A"} /",
                                      txtColor: AppColors.whiteColor,
                                    ),
                                    const Wd(),
                                    PostInput(
                                      label: "Soni",
                                      controller: _controllers[index],
                                      // Use the controller for this index

                                      txtColor: AppColors.whiteColor,
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
                                  ],
                                ),
                              ],
                            ),
                            ButtonWidget(
                              radius: 12,
                              color: AppColors.primaryColor,
                              label: "O'chirish",
                              height: 60.h,
                              fontSize: 16.sp,
                              width: 200.w,
                              iconSize: 32,
                              icon: Icons.remove_circle,
                              onTap: () {
                                widget.selectedProducts.remove(data);
                                setState(() {});
                              },
                            ),
                          ],
                        ),
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
            if (selectedBranch != null) {
              List<int> amountLists = [];
              List<String> products = [];
              List<TransferModel> readyProducts =
                  widget.selectedProducts.asMap().entries.map((entry) {
                int index = entry.key;
                var product = entry.value;
                TextEditingController controller = _controllers[index]!;

                int quantity = int.tryParse(controller.text.trim()) ?? 0;
                amountLists.add(quantity);
                products.add(product.name.toString());
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
                printBranchTransferCheck(
                    products,
                    amountLists,
                    AppConstants.currentBranch,
                    selectedBranchName.toString(),
                    AppConstants.currentBranchUser,
                    formatDate(DateTime.now()));
                if (widget.query != "") {
                  context.read<StoreCubit>().searchProduct(widget.query!);
                }
                widget.selectedProducts.clear();

                Navigator.pop(context, true);
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
