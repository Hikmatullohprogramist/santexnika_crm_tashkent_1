import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santexnika_crm/tools/format_date_time.dart';
import 'package:santexnika_crm/widgets/background_widget.dart';
import 'package:santexnika_crm/widgets/error_widget.dart';
import 'package:santexnika_crm/widgets/loading_widget.dart';

import 'package:santexnika_crm/widgets/mobile/button.dart';
import 'package:santexnika_crm/widgets/mobile/mobile_input.dart';
import 'package:santexnika_crm/widgets/mobile_api_error.dart';
import 'package:santexnika_crm/widgets/my_dialog_widget.dart';

import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/rows_text_widget.dart';

import '../../../../tools/appColors.dart';
import '../../cubit/types/types_cubit.dart';

class MobileTypeScreen extends StatefulWidget {
  const MobileTypeScreen({super.key});

  @override
  State<MobileTypeScreen> createState() => _MobileTypeScreenState();
}

class _MobileTypeScreenState extends State<MobileTypeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<TypesCubit>().getTypes();
    });
    super.initState();
  }

  final txtTypesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bottombarColor,
      body: RefreshIndicator(
        onRefresh: () async {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            context.read<TypesCubit>().getTypes();
          });
        },
        child: BlocBuilder<TypesCubit, TypesState>(
          builder: (BuildContext context, state) {
            if (state is TypesLoadingState) {
              return const ApiLoadingWidget();
            } else if (state is TypesErrorState) {
              return MobileAPiError(
                message: state.error,
                onTap: () {
                  context.read<TypesCubit>().getTypes();
                },
              );
            } else if (state is TypesSuccessState) {
              return ListView.builder(
                itemCount: state.data.length,
                itemBuilder: (context, index) {
                  var data = state.data[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MobileBackgroundWidget(
                      child: Column(
                        children: [
                          RowsTextWidget(
                            title: "Nomi: ",
                            name: data.name ?? '',
                          ),
                          const Hg(
                            height: 5,
                          ),
                          RowsTextWidget(
                            title: "Sana: ",
                            name: formatDate(
                              DateTime.parse(
                                data.createdAt.toString(),
                              ),
                            ),
                          ),
                        ],
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
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: AppColors.primaryColor,
      //   onPressed: () {
      //     showMobileDialogWidget(
      //       context,
      //       Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.spaceAround,
      //           children: [
      //             const TextWidget(txt: "Pul turi "),
      //             MobileInput(
      //               controller: txtTypesController,
      //               label: "Nomi",
      //             ),
      //             Row(
      //               children: [
      //                 Expanded(
      //                   child: MobileButton(
      //                     onTap: () {
      //                       Get.back();
      //                     },
      //                     icon: Icon(
      //                       Icons.exit_to_app,
      //                       size: 20,
      //                       color: AppColors.whiteColor,
      //                     ),
      //                     label: "Bekor qilish",
      //                   ),
      //                 ),
      //                 const Wd(),
      //                 Expanded(
      //                   child: MobileButton(
      //                     icon: Icon(
      //                       Icons.save,
      //                       size: 20,
      //                       color: AppColors.whiteColor,
      //                     ),
      //                     label: "Saqlash",
      //                     onTap: () {
      //                       if (txtTypesController.text.isEmpty) {
      //                         mobileErrorDialogWidgets(context);
      //                       } else {
      //                         context.read<TypesCubit>().postTypes(
      //                               txtTypesController.text,
      //                             );
      //                         Get.back();
      //                       }
      //                     },
      //                   ),
      //                 ),
      //               ],
      //             )
      //           ],
      //         ),
      //       ),
      //       1.2,
      //       3,
      //     );
      //   },
      //   child: const Icon(
      //     Icons.add,
      //     color: Colors.white,
      //   ),
      // ),
    );
  }
}
