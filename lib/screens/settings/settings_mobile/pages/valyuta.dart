import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:santexnika_crm/screens/settings/settings_mobile/widgets/update_price.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/widgets/background_widget.dart';
import 'package:santexnika_crm/widgets/error_widget.dart';
import 'package:santexnika_crm/widgets/loading_widget.dart';

import 'package:santexnika_crm/widgets/mobile/button.dart';
import 'package:santexnika_crm/widgets/mobile/mobile_input.dart';
import 'package:santexnika_crm/widgets/mobile_api_error.dart';

import 'package:santexnika_crm/widgets/my_dialog_widget.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/rows_text_widget.dart';

import '../../cubit/price/price_cubit.dart';

class MobileValyutaScreen extends StatefulWidget {
  const MobileValyutaScreen({super.key});

  @override
  State<MobileValyutaScreen> createState() => _MobileValyutaScreenState();
}

class _MobileValyutaScreenState extends State<MobileValyutaScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<PriceCubit>().getPrice();
      },
    );
    super.initState();
  }

  TextEditingController txtValue = TextEditingController();
  TextEditingController txtName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bottombarColor,
      body: RefreshIndicator(
        onRefresh: () async {
          WidgetsBinding.instance.addPostFrameCallback(
            (timeStamp) {
              context.read<PriceCubit>().getPrice();
            },
          );
        },
        child: BlocBuilder<PriceCubit, PriceState>(
          builder: (BuildContext context, state) {
            if (state is PriceLoadingState) {
              return const ApiLoadingWidget();
            } else if (state is PriceErrorState) {
              return MobileAPiError(
                message: state.error,
                onTap: () {
                  context.read<PriceCubit>().getPrice();
                },
              );
            } else if (state is PriceSuccessState) {
              return ListView.builder(
                itemCount: state.data.length,
                itemBuilder: (context, index) {
                  var data = state.data[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Slidable(
                      endActionPane: ActionPane(
                        motion: const StretchMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (v) {
                              txtValue.text = data.value ?? "0";
                              txtName.text = data.name ?? "0";
                              showMobileDialogWidget(
                                  context,
                                  MobileUpdatePrice(
                                    name: data.name ?? '',
                                    value: data.value ?? '0',
                                    id: data.id ?? 0,
                                  ),
                                  1.2,
                                  2);
                            },
                            icon: Icons.edit,
                            backgroundColor: AppColors.selectedColor,
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
                              name: data.name ?? "",
                            ),
                            const Hg(
                              height: 5,
                            ),
                            RowsTextWidget(
                              title: 'Value: ',
                              name: data.value ?? "",
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
    );
  }
}
