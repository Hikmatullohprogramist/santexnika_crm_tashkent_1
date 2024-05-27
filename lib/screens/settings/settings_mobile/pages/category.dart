import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:santexnika_crm/screens/settings/settings_mobile/widgets/category_add.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/widgets/background_widget.dart';
import 'package:santexnika_crm/widgets/error_widget.dart';
import 'package:santexnika_crm/widgets/loading_widget.dart';

import 'package:santexnika_crm/widgets/mobile/button.dart';
import 'package:santexnika_crm/widgets/mobile/mobile_input.dart';
import 'package:santexnika_crm/widgets/mobile_api_error.dart';

import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/rows_text_widget.dart';

import '../../../../tools/format_date_time.dart';
import '../../cubit/category/category_cubit.dart';

class MobileCategoryScreen extends StatefulWidget {
  const MobileCategoryScreen({super.key});

  @override
  State<MobileCategoryScreen> createState() => _MobileCategoryScreenState();
}

class _MobileCategoryScreenState extends State<MobileCategoryScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<CategoryCubit>().getCategory(0);
      },
    );
    super.initState();
  }

  int? selectedValuee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bottombarColor,
      body: RefreshIndicator(
        onRefresh: () async {
          WidgetsBinding.instance.addPostFrameCallback(
            (timeStamp) {
              context.read<CategoryCubit>().getCategory(0);
            },
          );
        },
        child: BlocBuilder<CategoryCubit, CategoryState>(
          builder: (BuildContext context, state) {
            if (state is CategoryLoadingState) {
              return const ApiLoadingWidget();
            } else if (state is CategoryErrorState) {
              return MobileAPiError(
                message: state.error,
                onTap: () {
                  context.read<CategoryCubit>().getCategory(0);
                },
              );
            } else if (state is CategorySuccessState) {
              return ListView.builder(
                itemCount: state.data.data.length,
                itemBuilder: (context, index) {
                  var data = state.data.data[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Slidable(
                      endActionPane: ActionPane(
                        motion: const StretchMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (v) {
                              context.read<CategoryCubit>().deleteCategory(
                                    data.id!,
                                  );
                            },
                            icon: Icons.delete,
                            backgroundColor: AppColors.errorColor,
                            foregroundColor: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ],
                      ),
                      child: MobileBackgroundWidget(
                        child: Column(
                          children: [
                            RowsTextWidget(
                              title: 'Nomi: ',
                              name: data.name ?? '',
                            ),
                            const Hg(
                              height: 5,
                            ),
                            RowsTextWidget(
                              title: 'Boshlangan sana: ',
                              name: formatDate(
                                DateTime.parse(data.createdAt ?? ''),
                              ),
                            ),
                            const Hg(
                              height: 5,
                            ),
                            RowsTextWidget(
                              title: 'Mahsulot soni: ',
                              name: data.storesCount.toString() ?? '',
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showMobileDialogWidget(
            context,
            MobileCategoryAdd(),
            1.2,
            2.9,
          );
        },
        backgroundColor: AppColors.primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
